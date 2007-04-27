Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbXD0UKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbXD0UKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbXD0UKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:10:35 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48815 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178AbXD0UJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:09:51 -0400
Date: Fri, 27 Apr 2007 22:06:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704272202160.506@yvahk01.tjqt.qr>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27 2007 08:18, Linus Torvalds wrote:
>
>Actually, you don't need to apply the patch - just do
>
>	echo 5 > /proc/sys/vm/dirty_background_ratio
>	echo 10 > /proc/sys/vm/dirty_ratio
>
>and say if it seems to improve things. I think those are much saner 
>defaults especially for a desktop system (and probably for most servers 
>too, for that matter).

Interesting. For my laptop, I have configured like 90 for
dirty_background_ratio and 95 for dirty_ratio. Makes for a nice
delayed write, but I do not do workloads bigger than extracing kernel
tarballs (~250 MB) and coding away on that machine (488 MB RAM) anyway.
Setting it to something like 95, I could probably rm -Rf the kernel
tree again and the disk never gets active because it is all cached.
But if dirty_ratio is lowered, the disk will get active soon.

>Historical note: allowing about half of memory to contain dirty pages made 
>more sense back in the days when people had 16-64MB of memory, and a 
>single untar of even fairly small projects would otherwise hit the disk. 
>But memory sizes have grown *much* more quickly than disk speeds (and 
>latency requirements have gone down, not up), so a default that may 
>actually have been perfectly fine at some point seems crazy these days..



Jan
-- 
