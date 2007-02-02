Return-Path: <linux-kernel-owner+w=401wt.eu-S1423110AbXBBFsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423110AbXBBFsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 00:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423105AbXBBFsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 00:48:46 -0500
Received: from 1wt.eu ([62.212.114.60]:2219 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423110AbXBBFsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 00:48:46 -0500
Date: Fri, 2 Feb 2007 06:48:28 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rth@twiddle.net,
       linux-kernel@vger.kernel.org, alpha@gentoo.org
Subject: Re: epoll handling in the alpha port
Message-ID: <20070202054828.GE24090@1wt.eu>
References: <200702011520.46723.vapier@gentoo.org> <20070201210555.ac637298.akpm@linux-foundation.org> <200702020019.36248.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702020019.36248.vapier@gentoo.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 12:19:35AM -0500, Mike Frysinger wrote:
> On Friday 02 February 2007, Andrew Morton wrote:
> > It might be to late to fix this - we risk breaking userspace which worked
> > around it.
> 
> we'd be breaking userspace API, but not ABI ... and the largest consumers out 
> there (glibc/uclibc) have not been accounting for this, so we wouldnt be 
> breaking them
> 
> that's how we noticed the issue in Gentoo ... all the epoll calls are 
> automatically declared -ENOSYS stubs in glibc's libc.so
> 
> is there some other large consumer i'm not thinking of ?

Not necessarily some large consumers, but epoll() is quite older than its
kernel inclusion, so there certainly are some apps still using the syscall
without going through libc.

> > It would be safer to add the correct definitions while leaving the old ones
> > in place.
> 
> in the end, either works for me ... i can see linux's pretty hard 'dont break 
> userspace' policy coming into play here

I think it would be reasonable to use the NR_epoll* names first, and to
declare NR_sys_epoll* aliases which will point to NR_epoll*. You would
then add a comment with the date of the change, stating that you keep
them just in case there are some old apps. Then, someone coming on the
comment in 3 or 4 years could reasonably suggest removing those aliases.

Willy

