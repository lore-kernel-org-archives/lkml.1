Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbXJRMFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbXJRMFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761826AbXJRMFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:05:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50767
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760971AbXJRMFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:05:40 -0400
Date: Thu, 18 Oct 2007 05:05:54 -0700 (PDT)
Message-Id: <20071018.050554.115911163.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071018115702.GW5063@kernel.dk>
References: <20071018082145.GK5063@kernel.dk>
	<20071018.045505.106265100.davem@davemloft.net>
	<20071018115702.GW5063@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 18 Oct 2007 13:57:02 +0200

> Thanks a lot, Dave! The patch is a monster right now, I'll work on
> splitting it into a 3-step process. Any arch help is greatly
> appreciated.

I have some other bits that my compile hit, such as some things in the
crypto layer.

But I hesitate to send them to you because I think the on-stack cases
need some helpers such that DEBUG_SG works for them.

BTW, you missed a case in drivers/usb/core/message.c because of
the config used in your build.  This thing below is a good
argument for trying to avoid HIGHMEM et al. ifdefs in drivers :-)

--- drivers/usb/core/message.c~	2007-10-18 01:46:44.000000000 -0700
+++ drivers/usb/core/message.c	2007-10-18 03:15:20.000000000 -0700
@@ -438,7 +438,7 @@
 			io->urbs[i]->transfer_buffer = NULL;
 #else
 			io->urbs[i]->transfer_buffer =
-				page_address(sg[i].page) + sg[i].offset;
+				page_address(sg_page(&sg[i])) + sg[i].offset;
 #endif
 		} else {
 			/* hc may use _only_ transfer_buffer */
