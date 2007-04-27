Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbXD0VXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbXD0VXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbXD0VXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:23:02 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005AbXD0VW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:22:59 -0400
Date: Fri, 27 Apr 2007 14:22:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <Pine.LNX.4.61.0704272202160.506@yvahk01.tjqt.qr>
Message-ID: <alpine.LFD.0.98.0704271420390.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
 <Pine.LNX.4.61.0704272202160.506@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Jan Engelhardt wrote:
> 
> Interesting. For my laptop, I have configured like 90 for
> dirty_background_ratio and 95 for dirty_ratio. Makes for a nice
> delayed write, but I do not do workloads bigger than extracing kernel
> tarballs (~250 MB) and coding away on that machine (488 MB RAM) anyway.
> Setting it to something like 95, I could probably rm -Rf the kernel
> tree again and the disk never gets active because it is all cached.
> But if dirty_ratio is lowered, the disk will get active soon.

Yes. For laptops, you may want to
 - raise the dirty limits
 - increase the dirty scan times

but you do realize that if you then need memory for something else, 
latency just becomes *horrible*. So even on laptops, it's not obviously 
the right thing to do (these days, throwing money at the problem instead, 
and getting one of the nice new 1.8" flash disks, will solve all issues: 
you'd have no reason to try to delay spinning up the disk anyway).

		Linus
