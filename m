Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbXHaEpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbXHaEpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXHaEo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:44:59 -0400
Received: from pat.uio.no ([129.240.10.15]:52963 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbXHaEo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:44:58 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 00:44:45 -0400
Message-Id: <1188535485.6626.85.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.082)
X-UiO-Scanned: 3D97D5D91B1228496C8D50C2766D2852ACDEF095
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 119 total 3574547 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 20:49 -0700, Linus Torvalds wrote:
> 
> On Thu, 30 Aug 2007, Trond Myklebust wrote:
> > 
> > Which is better than having it fail silently, or giving you a mount with
> > the wrong mount options.
> 
> No, Trond.
> 
> That commit gets reverted or fixed. It's a regression, and your theories 
> that it's "better" that way are obviously broken.
> 
> It's obviously broken because you seem to say that you know better, even 
> though you also admit that:
> 
>   "How is the NFS client to know that these directories are disjoint, or
>    that no-one will ever create a hard link from one directory to another? 
>    To my knowledge, the only way to ensure this is to put them on 
>    different disk partitions."
> 
> the point being that you just disallowed people from doing things that are 
> sane but _potentially_ dangerous. That's now how we work. The UNIX way sis 
> to give people rope - if you cannot *prove* that what they are doing is 
> wrong, then you damn well better not disallow it.
> 
> No regressions, Trond. Especially not for stuff that used to work, was 
> used, and that could be sanely expected to work (which this *definitely*
> sounds like).

It did not. The previous behaviour was to always silently override the
user mount options.

> Please send in a fix. If the fix involves making "nosharecache" the 
> default, then that is better than making policy decisions like this in the 
> kernel. The kernel should do what the user asks and not put in unnecessary 
> roadblocks.

This is _not_ a kernel policy decision. The kernel is simply informing
the user that it cannot fulfil the mount request as specified. Exactly
why do you think that NFS should be any different from other filesystems
when it comes to this?

AFAIK, every other filesystem will give you an EBUSY if you try to mount
a partition with -oro if you are already mounting somewhere else with
-orw. Every filesystem will give you an EBUSY if you try to mount the
partition with -oacl if it is mounted somewhere else with -onoacl. The
reason: exactly the same as NFS, the caches cannot remain consistent
when you try to mount two different super blocks that both refer to the
same underlying filesystem.

Trond

