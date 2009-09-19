Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZISLZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZISLZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbZISLZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:25:29 -0400
Received: from 1wt.eu ([62.212.114.60]:49124 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166AbZISLZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:25:28 -0400
Date: Sat, 19 Sep 2009 13:25:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jim Meyering <jim@meyering.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
Message-ID: <20090919112523.GB28315@1wt.eu>
References: <87vdjgqcbd.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdjgqcbd.fsf@meyering.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 09:31:50PM +0200, Jim Meyering wrote:
> About a year ago, I fixed GNU rm to avoid quadratic readdir/stat seek
> penalties on ext3 and ext4 that became overwhelming on directories with
> many entries (1M entries started to look like infloop or DoS).
> 
>   From coreutils-7.0 NEWS:
> 
>     chgrp, chmod, chown, chcon, du, rm: now all display linear performance,
>     even when operating on million-entry directories on ext3 and ext4 file
>     systems.  Before, they would exhibit O(N^2) performance, due to linear
>     per-entry seek time cost when operating on entries in readdir order.
>     Rm was improved directly, while the others inherit the improvement
>     from the newer version of fts in gnulib.
> 
> To do that efficiently, I changed the core readdir loop (mainly via
> gnulib's fts.c) to preprocess entries, when needed, by sorting them
> on inode, and *then* processing them.  This optimization is enabled
> only when the affected file system is of a type likely to benefit,
> and when the number of directory entries is large enough to matter.

This is excellent. I've been used to play with variations of
'find -printf "%i %p\n"|sort -n|cut -f2|xargs <cmd>' to sort file
operations by inode to speed them up, especially when rm'ing a
kernel tree or when doing a prefetch to build from hot cache.

I think you might notice excellent results on CDs where seeks cost a
lot. That's where I first use the find|sort method above. I'm really
happy to see that such mechanisms are now implemented inside my
everyday tools, and I can't wait to upgrade!

Regards,
Willy

