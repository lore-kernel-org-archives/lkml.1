Return-Path: <linux-kernel-owner+w=401wt.eu-S2992862AbXEBGzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992862AbXEBGzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992864AbXEBGzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:55:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20151 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992862AbXEBGzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:55:17 -0400
Date: Wed, 2 May 2007 08:53:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS  is under heavy write load (massive starvation)
Message-ID: <20070502065355.GB15878@kernel.dk>
References: <1177660767.6567.41.camel@Homer.simpson.net> <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27 2007, Linus Torvalds wrote:
> So I do believe that we could probably do something about the IO 
> scheduling _too_:
> 
>  - break up large write requests (yeah, it will make for worse IO 
>    throughput, but if make it configurable, and especially with 
>    controllers that don't have insane overheads per command, the 
>    difference between 128kB requests and 16MB requests is probably not 
>    really even noticeable - SCSI things with large per-command overheads 
>    are just stupid)
> 
>    Generating huge requests will automatically mean that they are 
>    "unbreakable" from an IO scheduler perspective, so it's bad for latency 
>    for other reqeusts once they've started.

Overlooked this one initially... We actually don't generate huge
requests, exactly because of that. Even if the device can do large
requests (most SATA disks today can do 32meg), we default to 512kB as
the largest one that we will build due to file system requests. It's
trivial to reduce that limit, see /sys/block/<dev>/queue/max_sectors_kb.
That controls the maximum per-request size.

-- 
Jens Axboe

