Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXLTAWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXLTAWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 19:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXLTAWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 19:22:42 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:47566 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbXLTAWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 19:22:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuE6ALVEaUdV4n6YRmdsb2JhbACHYYgWAQEBN5oKAw
Message-ID: <024201c8429e$6df3f670$3ba6fea9@atmel.com>
From: "Ulf Samuelsson" <ulf@atmel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <linux@maxim.org.za>
Cc: "Russell King" <linux@arm.linux.org.uk>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>, <kernel@avr32linux.org>,
       <linux-kernel@vger.kernel.org>, "Remy Bohmer" <linux@bohmer.net>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
Subject: Re: [PATCH v2 0/6] atmel_serial: Cleanups, irq handler splitup & DMA
Date: Wed, 19 Dec 2007 23:13:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



| The following patchset cleans up the atmel_serial driver a bit,
| moves a significant portion of the interrupt handler into a tasklet,
| and adds DMA support. This is the result of a combined effort by Chip
| Coldwell, Remy Bohmer and me. The patches should apply cleanly onto
| Linus' latest git tree.
| 
| With DMA, I see transfer rates around 92 kbps when transferring a big
| file using ZModem (both directions are roughly the same.)
| 

The start and stop bits will use 20 % of the bit rate so the
teoretical max throughput at 115,200 BAUD is 115,200 * 0,8 = 92160 bps.

What would be interesting is to figure out if we can get reliable
transmission at higher frequencies - 230/460/921 kbps.

| Note that break and error handling doesn't work too well with DMA
| enabled. This is a common problem with all the efforts I've seen
| adding DMA support to this driver (including my own). The PDC error
| handling also accesses icount without locking. I'm tempted to just
| ignore the problem for now and hopefully come up with a solution
| later.

Have told the guys responsible for the USART IP block we
need to improve the H/W for error control for the last 3-4 years.
Why not at 120000 gates/sq mm, add error counters???

Best Regards
Ulf Samuelsson
