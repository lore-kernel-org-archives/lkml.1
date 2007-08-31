Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbXHaIwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbXHaIwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbXHaIwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:52:00 -0400
Received: from unthought.net ([212.97.129.88]:43425 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbXHaIv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:51:59 -0400
Date: Fri, 31 Aug 2007 10:51:57 +0200
From: Jakob Oestergaard <jakob@unthought.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
Message-ID: <20070831085157.GS21979@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Frank van Maarseveen <frankvm@frankvm.com>,
	Hua Zhong <hzhong@gmail.com>,
	'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org
References: <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188535485.6626.85.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org> <1188536658.6626.98.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org> <20070831074028.GR21979@unthought.net> <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 01:07:56AM -0700, Linus Torvalds wrote:
...
> When we add NEW BEHAVIOUR, we don't add it to old interfaces when that 
> breaks old user mode! We add a new flag saying "I want the new behaviour".
> 
> This is not rocket science, guys. This is very basic kernel behaviour. The 
> kernel exists only to serve user space, and that means that there is no 
> more important thing to do than to make sure you don't break existing 
> users, unless you have some *damns* strong reasons.

100% agreed.

> The fact that he may *also* have broken insane setups is totally 
> irrelevant. Don't go off on some tangent that has nothing to do with the 
> regression in question!

It does not have "nothing" to do with the regression.

Some setups which worked more by accident than by design earlier on were broken
by the fix. This could have been avoided, I agree, but the breakage was caused
by the fix (or the breakage is the fix, however you prefer to look at it).

> > If ext3 in some rare case (which would still mean it hit a few thousand users)
> > failed to remember that a file had been marked read-only and allowed writes to
> > it, wouldn't we want to fix that too?  It would cause regressions, but we'd fix
> > it, right?
> 
> Stop blathering. Of course we fix security holes. But we don't break 
> things that don't need breaking. This wasn't a security hole.

*part* of it wasn't a security hole.

The other half very much was.

...
> In other words, it should (as I already mentioned once) have used 
> "nosharecache" by default, which makes it all work.
> 
> Then, people who want to re-use the caches (which in turn may mean that 
> everything needs to have the same flags), THOSE PEOPLE, who want the NEW 
> SEMANTICS (errors and all) should then use a "sharecache" flag.
> 
> See? You don't have to screw people over.

Sure, given that Trond (or whomever) has the time it takes to go and implement
all of this, there's no need to screw anyone.

Assuming he's on a schedule and this will have to wait, I agree with him that
it makes the most sense to play it safe security/consistency-wise rather than
functionality-wise.

> > mount passes back the error code on a failed mount. autofs passes that error
> > along too (when people configure syslog correctly). In short; when these
> > serious mistakes are made and caught, the admin sees an error in his logs.
> 
> Bullshit. "Seeing the error in his logs" doesn't help anything.

It makes troubleshooting possible, which adresses *the* major complaint from
*one* of the *two* people who complained about this.


-- 

 / jakob

