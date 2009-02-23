Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZBWHUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZBWHUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZBWHUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:20:36 -0500
Received: from brick.kernel.dk ([93.163.65.50]:1463 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZBWHUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:20:35 -0500
Date: Mon, 23 Feb 2009 08:18:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: help! locks problem in block layer request queue?
Message-ID: <20090223071802.GK29783@kernel.dk>
References: <38D9F46DFF92C54980D2F2C1E8EE313024842389@pdsmsx503.ccr.corp.intel.com> <20090219131305.GD29783@kernel.dk> <38D9F46DFF92C54980D2F2C1E8EE3130248428D8@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38D9F46DFF92C54980D2F2C1E8EE3130248428D8@pdsmsx503.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(please don't top post reply to emails...)

On Sat, Feb 21 2009, Gao, Yunpeng wrote:
> Really awesome!  This is a big bug. I have re-write the code of
> processing requests from the request queue. The new code is copied
> from drivers/mtd/mtd_blkdevs.c and did some necessary modifies. Now it
> works well.  Many thanks to you :)

Glad that it now works :-)

> BTW, I noticed that MTD driver (drivers/mtd/mtd_blkdevs.c) and MMC
> driver (drivers/mmc/card/block.c and queue.c) also register a block
> device, and they create a kernel thread to process the request queue
> instead of process it directly. Why they do it like that? Is there any
> special reason for that?

If your request handling is slow, then it is often better to push
request handling to a dedicated thread. That may be the case if your
device can't do DMA for instance, and you have to transfer all the data
manually. Pushing that to a thread usually makes it easy to do that with
interrupts enabled and is thus nicer to the rest of the system.

-- 
Jens Axboe

