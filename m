Return-Path: <linux-kernel-owner+w=401wt.eu-S1765319AbXHMOvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765319AbXHMOvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945200AbXHMMJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:09:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18867 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S945126AbXHMMJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:09:35 -0400
Date: Mon, 13 Aug 2007 14:09:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata git tree, mbox queue status and contents
Message-ID: <20070813120930.GQ23758@kernel.dk>
References: <46B35344.3090208@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B35344.3090208@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03 2007, Jeff Garzik wrote:
> * Kristen: ALPM patches.  We definitely want them, as they save a ton of 
> power.

The problem with ALPM, as I see it, is that it is way too aggressive. It
really needs to be combined with a timer to be useful, it's really a
huge shame that it doesn't come equipped with a timeout setting in
hardware. Lacking that, we could punt to using a second aligned timer
that just checks for activity in the last second, and if none was seen
then enable ALPM. That should have absolutely minimal impact on CPU
consumption. Likewise for when we see IO, when the rate/sec goes beyond
a low threshold then disable ALPM again.

In my testing on this notebook (x60), throughput was reduced to about
30% when using ALPM. So while it does save a good amount of power, it
also makes the disk a slow dog if you are actually using it.

-- 
Jens Axboe

