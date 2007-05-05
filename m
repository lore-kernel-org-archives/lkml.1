Return-Path: <linux-kernel-owner+w=401wt.eu-S376162AbXEEB4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376162AbXEEB4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376167AbXEEB4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:56:12 -0400
Received: from ozlabs.org ([203.10.76.45]:32775 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376162AbXEEB4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:56:11 -0400
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure
	for paravirtualization"
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <m1lkg4sk3f.fsf@ebiederm.dsl.xmission.com>
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	 <1178280770.23670.61.camel@localhost.localdomain>
	 <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
	 <1178289450.23670.100.camel@localhost.localdomain>
	 <m1lkg4sk3f.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 11:22:48 +1000
Message-Id: <1178328168.12284.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 09:07 -0600, Eric W. Biederman wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> 
> > On Fri, 2007-05-04 at 08:13 -0600, Eric W. Biederman wrote:
> >> We don't have any working code, there are no in tree users.
> >
> > Hi Eric,
> >
> > 	Lack of in-tree code is definitely not due to me.  The code which uses
> > it has been sitting in -mm for three months.  Suddenly ripping this out
> > and breaking all that work without replacing it is rude.
> 
> My memory is very fuzzy now, but I know it at least came up early on
> that everyone should be using %esi to point to real mode data and
> that didn't happen.

Hi Eric,

	Well, I certainly don't recall that (that's not to say that someone
didn't say it).  Trying to meet the requirements of Xen, VMI and other
future hypervisors lead to an awkward result; this is the main reason I
started on lguest, so we'd have a simple example in front of us to say
"do it this way".

	(It's not certain that anyone else will ever use this code, but we
should *try* IMHO).

> Before lguest.  Thank you very much.  This code should never ever
> have been in a stable kernel.  It is a very ill conceived interface.

I disagree.  It was *not* obvious how paravirt kernels should boot.
Lguest, for example, copied Xen's "set up kernel pagetables already"
design decision, which now seems wrong.  But it was the example we had.

> And frankly I don't think lguest should be merged until we are as
> close to certain as human beings can get that have the ABI reviewed
> and sorted out.  ABIs unfortunately are very very hard to change.

I think you misunderstand lguest.  I agree with this sentiment
completely: this is *why* lguest doesn't have an ABI.  It's all in-tree,
so it can simply be changed.  There's no guarantee that running
different kernels as guest and host will work.

Maybe later the ABI will nail down, but the last year of hacking on
various hypervisors has shown it's folly to try to get it right now.  We
need to play a lot first.

Hope that clarifies!
Rusty.


