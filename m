Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbXI0TaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbXI0TaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757686AbXI0T35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:29:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44154 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbXI0T34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:29:56 -0400
Date: Thu, 27 Sep 2007 21:31:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Andy Whitcroft <apw@shadowen.org>,
       Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm1 -- powerpc link failure
Message-ID: <20070927193123.GC1847@uranus.ravnborg.org>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org> <20070925134653.GB8447@shadowen.org> <Pine.LNX.4.64.0709251715530.7567@jikos.suse.cz> <20070927120308.GJ2213@shadowen.org> <Pine.LNX.4.64.0709271408170.7567@jikos.suse.cz> <20070927101342.92422296.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927101342.92422296.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 10:13:42AM -0700, Andrew Morton wrote:
> On Thu, 27 Sep 2007 14:13:21 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > On Thu, 27 Sep 2007, Andy Whitcroft wrote:
> > 
> > > Ok, this problem seems to still persist in 2.6.23-rc8-mm2.  It seems we 
> > > have three options from here:
> > > 1) update the compiler support list to exclude these compilers, or
> > > 2) back this change out, or
> > > 3) switch to the version not using __weak.
> > > The latter seems to be the least intrusive change.  As no-one closer to 
> > > the problem is stepping up to make the decision I will propose we go 
> > > with the third option here.
> > 
> > Andrew,
> > 
> > if you agree with Andy that we should support compilers that don't work 
> > with __weak, please drop i386-and-x86_64-randomize-brk.patch and replace 
> > it with the one below instead (this has been already posted at 
> > http://lkml.org/lkml/2007/8/31/113). Thanks.
> > 
> 
> We have quite a few instances of __weak in there.  What is special about
> this one?

The bug we trigger is an ld bug - not a compiler bug.
What happens is that we have the same function defined weak twice.
In fs/ we include binfmt_elf.o in the build because
CONFIG_BINFMT_ELF is set.
And in arch/powerpc/kernel/binfmt_elf32.c:
we do an: #include "../../../fs/binfmt_elf.c"

Without actually trying it out I assume we trigger the ld bug
because we define the same weak function twice.

And this is a non-typical situation.

	Sam
