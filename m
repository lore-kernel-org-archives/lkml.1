Return-Path: <linux-kernel-owner+w=401wt.eu-S941634AbXGaCc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941634AbXGaCc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940551AbXGaCZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:25:32 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:56467 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941042AbXGaCZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:25:30 -0400
Subject: Re: [PATCH 2/2] Debug handling of early spurious interrupts
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070730112223.7b52cf63.akpm@linux-foundation.org>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070718154659.c8b5ffea.akpm@linux-foundation.org>
	 <1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184896944.27369.50.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070720144302.2785e961.akpm@linux-foundation.org>
	 <1185789494.9831.107.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070730112223.7b52cf63.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Tue, 31 Jul 2007 11:25:26 +0900
Message-Id: <1185848726.23316.50.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 11:22 -0700, Andrew Morton wrote: 
> On Mon, 30 Jul 2007 18:58:14 +0900
> Fernando Luis V__zquez Cao <fernando@oss.ntt.co.jp> wrote:
> 
> > > 
> > > So bad things might happen because of this change.  And if they do, they
> > > will take a loooong time to be discovered, because non-shared interrupt
> > > handlers tend to dwell in crufty old drivers which not many people use.
> > > 
> > > So I'm wondering if it would be more prudent to only do all this for shared
> > > handlers?
> > 
> > I have been testing this patches on all my machines, which spans three
> > different architectures: i386, x86_64 (EM64T and Opteron), and ia64.
> > 
> > The good news is that nothing catastrophic happened and, in the process,
> > I managed to find some somewhat buggy interrupt handlers.
> > 
> > I will present a brief summary of my findings here.
> 
> That's quite a lot of breakage for such a small sample of machines.  I do
> suspect that if we were to merge this lot into mainline, all sorts of bad
> stuff would happen.
Yup.

> otoh, as you point out, pretty much everthing which goes wrong is due to
> incorrect or dubious driver behaviour, and there is value in weeding these
> things out. 
> 
> But the problem with this process is that we're weeding things out at
> runtime.  Some drivers don't get used by many people and users of some
> architectures (esp embedded) tend to lag kernel.org by a long time.  So it
> could be years before all the fallout from this change is finally wrapped
> up.
Yes, that is a big concern. However, the same embedded people is
starting to use both kexec and kdump, so they may suffer the issues we
are trying to weed out anyway, even if these patches are not applied.
The difference is that with this new functionality it is possible to
catch potential problems relatively easily, because any incorrect
behaviour this may cause will be easily reproducible and, in most cases,
will reveal itself early at boot time.

As things stand now, I guess we will keep seeing occasional crashes and
strange behaviour in kexec-booted kernels, which in some cases will be
due to incorrect handling of spurious interrupts. Besides, such problems
are really difficult to reproduce because, commonly, we would need to
hit an obscure corner case.

> > If we find drivers that are not fixable we should probably consider this
> > new behaviour on a per-driver basis, as Andrew suggested.
> 
> We haven't found any such yet, have we?
Not yet, fortunately.

> > This would
> > probably require passing a new flag into request_irq. Besides, when such
> > a driver is detected we should emit a warning that it may not work
> > properly in a kdump kernel.
> > 
> > I would appreciate your comments on this.
> 
> Oh well, let's just keep maintaining it in -mm for now, gather more
> information so that we can make a more informed decision later on.
Makes sense. I will look into all the issues I have found so far, do
some more testing (I think a new approach is needed to speed up testing
of these issues...), and get back to you.

Thank you.

Fernando

