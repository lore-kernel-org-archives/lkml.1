Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZFVOE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZFVOE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZFVOER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:04:17 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:50965 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbZFVOEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:04:16 -0400
From: Frans Pop <elendil@planet.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
Date: Mon, 22 Jun 2009 16:04:15 +0200
User-Agent: KMail/1.9.9
References: <200906211446.38598.elendil@planet.nl> <200906220843.14337.elendil@planet.nl> <200906221321.44672.bzolnier@gmail.com>
In-Reply-To: <200906221321.44672.bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906221604.17915.elendil@planet.nl>
X-OriginalArrivalTime: 22 Jun 2009 14:04:18.0665 (UTC) FILETIME=[559F1590:01C9F342]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, you wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: fix handling of unexpected IRQs vs request_irq()
>
> Add ide_host_enable_irqs() helper and use it in ide_host_register()
> before registering ports.  Then remove no longer needed IRQ unmasking
> from in init_irq().
>
> This should fix the problem with "screaming" shared IRQ on the first
> port (after request_irq() call while we have the unexpected IRQ pending
> on the second port) which was uncovered by my rework of the serialized
> interfaces support.

Thanks Bart. This does solve the "nobody cared" problem.
Tested-by: Frans Pop <elendil@planet.nl>

I also tested it without David's initial patch (i.e. *with* 
IDE_HFLAG_SERIALIZE in host-flags) and that seems to work fine too:
ide0 at 0x1fe02c00000-0x1fe02c00007,0x1fe02c0000a on irq 14 (serialized)
ide1 at 0x1fe02c00010-0x1fe02c00017,0x1fe02c0001a on irq 14 (serialized)

No idea whether serialized is to be preferred or not. Guess that's David's 
call now.


I do still get the "bad DMA info in identify block" error for the CD 
drive, so that's still a regression relative to 2.6.26:
 hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
-hdd: MWDMA2 mode selected
+hdd: bad DMA info in identify block
+hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4

Cheers,
FJP
