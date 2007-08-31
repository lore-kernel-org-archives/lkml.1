Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbXHaQoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbXHaQoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760295AbXHaQn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:43:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759988AbXHaQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:43:55 -0400
Date: Fri, 31 Aug 2007 09:43:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jakob Oestergaard <jakob@unthought.net>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <20070831085157.GS21979@unthought.net>
Message-ID: <alpine.LFD.0.999.0708310935240.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org>
 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
 <1188535485.6626.85.camel@heimdal.trondhjem.org>
 <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
 <1188536658.6626.98.camel@heimdal.trondhjem.org>
 <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org>
 <20070831074028.GR21979@unthought.net> <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org>
 <20070831085157.GS21979@unthought.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Jakob Oestergaard wrote:
> 
> > The fact that he may *also* have broken insane setups is totally 
> > irrelevant. Don't go off on some tangent that has nothing to do with the 
> > regression in question!
> 
> It does not have "nothing" to do with the regression.
> 
> Some setups which worked more by accident than by design earlier on were broken
> by the fix. This could have been avoided, I agree, but the breakage was caused
> by the fix (or the breakage is the fix, however you prefer to look at it).

Well, it's not a "fix" if it breaks other setups. 

It's especially not a fix since the whole requirement that all the flags 
be exactly the same is totally brain-dead in the first place. We *have* 
that kind of mount already, and it has nothing to do with NFS: it's called 
a "bind" mount.

So if you want an identical mount, with cache coherency and tying the two 
mount-points together (requiring that they have the same mount flags), 
then that has absolutely *nothing* to do with NFS. The VFS layer does that 
for you.

> *part* of it wasn't a security hole.
> 
> The other half very much was.

No, the fix was simply wrong.  It was done the wrong way, and it broke 
things it shouldn't have broken.

Let's put it this way: if I create a patch that stops the system from 
booting, I sure as hell fix a potential security hole, don't I?

Does that make my patch a "fix"?

No it does not.

> Sure, given that Trond (or whomever) has the time it takes to go and implement
> all of this, there's no need to screw anyone.
> 
> Assuming he's on a schedule and this will have to wait, I agree with him that
> it makes the most sense to play it safe security/consistency-wise rather than
> functionality-wise.

I disagree. Either that thing gets fixed before 2.6.23, or the commit that 
introduced the broken behaviour gets reverted.

We've had this policy of "regressions are fixed" for a long time, and 
we're not suddenly changing it.

This is *not* a security hole. In order to make it a security hole, you 
need to be root in the first place. So what you call a security hole is 
really no different from root installing a bad SUID binary. It's simply 
not the kernels place to then say "SUID binaries will not work, because 
it's a potential security hole".

See?

So stop calling this a security hole.  It's certainly a misfeature, but:

 - it's a misfeature that people are used to, and has been around forever.

 - there are bound to be ways to fix it that don't break existing users.

 - the requirement that all flags be the same for a mount to the same NFS 
   directory is *particularly* stupid, since there are better ways to do 
   that than go through NFS!

so I really don't see why people excuse the new behaviour.

			Linus
