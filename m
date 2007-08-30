Return-Path: <linux-kernel-owner+w=401wt.eu-S1763534AbXH3XiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763534AbXH3XiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 19:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758753AbXH3Xhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 19:37:55 -0400
Received: from pat.uio.no ([129.240.10.15]:45727 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759087AbXH3Xhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 19:37:54 -0400
Subject: RE: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org
In-Reply-To: <001501c7eb5d$d295d870$77c18950$@com>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <001001c7eb57$afd2d320$0f787960$@com>
	 <1188516173.6626.46.camel@heimdal.trondhjem.org>
	 <001501c7eb5d$d295d870$77c18950$@com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 19:37:50 -0400
Message-Id: <1188517070.6626.54.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.058)
X-UiO-Scanned: 1B9D6F2BC340E475233EA79478CC74D3B4409193
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 147 total 3573335 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 16:30 -0700, Hua Zhong wrote:

> There are two disjoint directories. I am wondering why there would be cache
> coherency issues in this case? Is this Linus nfs implementation specific or
> all other Unix systems all have the same issue?

How is the NFS client to know that these directories are disjoint, or
that no-one will ever create a hard link from one directory to another?
To my knowledge, the only way to ensure this is to put them on different
disk partitions.

I don't know if all Unix systems have this issue, but I have been told
that Solaris at least has it.

> > If you know what you are doing, then there is an option which allows
> > you to override the default behaviour.
> > 
> > > More importantly, it is a regression. My understanding is that unless
> > > absolutely necessary we do not introduce a "feature" that breaks
> > > working setups.
> > 
> > Your turn to define what you mean by "working"? In my book that means
> > "a setup that doesn't include unexpected or unintended behaviour".
> 
> "working" as in "I can mount the directory and do my work". And there has
> never been any problems as far as I know.

That is too narrow a definition: the minimum should be "everyone can
mount their directories and do their work". Your particular setup may be
safe, but that is why we have overrides: the default should be for the
kernel to be conservative, and to _tell_ users what it thinks is wrong.

> > Not being able to notice cache coherency failures on a file that is
> > mounted in two different places with two different sets of mount
> > options counts as "unexpected behaviour".
> > 
> > Not being able to notice that your mount options have been overridden
> > by the kernel also counts as "unexpected behaviour".
> 
> Fine. These are all very nice theories, but I just want to report this
> regression and hope it won't cause any big problems for any users out there.
> In the mean time, I am returning to 2.6.22.

Your choice.

Trond

