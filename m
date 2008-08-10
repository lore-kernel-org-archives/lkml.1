Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYHJQaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYHJQaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 12:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYHJQab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 12:30:31 -0400
Received: from h155.mvista.com ([63.81.120.155]:50651 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752643AbYHJQaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 12:30:30 -0400
Message-ID: <489F179D.2010101@ru.mvista.com>
Date: Sun, 10 Aug 2008 20:30:21 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Patrick Horn <phrh@yahoo.com>, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] ide: don't allow DMA to be enabled if CONFIG_IDEDMA_{ICS,PCI}_AUTO=n
References: <200703152145.40644.bzolnier@gmail.com>
In-Reply-To: <200703152145.40644.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> [PATCH] ide: don't allow DMA to be enabled if CONFIG_IDEDMA_{ICS,PCI}_AUTO=n

> For CONFIG_IDEDMA_{ICS,PCI}_AUTO=n and/or "ide=nodma" option the host/device

    Not only that: it also would affect CompactFlash with no DMA support but 
with DMA autotuning enabled in IDE core...

> are not programmed for DMA and it is also explicitly disabled by ide_set_dma()
> (->ide_dma_check returns "-1").  However the code responsible for manually
> enabling DMA ("hdparm -d 1") has a bug which results in DMA being erroneously
> enabled - ide_set_dma() incorrectly passes "0" return value to set_using_dma().

    Heh, I've just run into this myself while trying to retro-fit Palmchip 
BK3710 IDE driver into 2.6.18 properly.

> This may work if BIOS/firmware configured the host/device for DMA and chipset
> allows independent configuration of DMA/PIO modes but won't work after suspend
> and is generally unsafe on many chipsets (possibly including data corruption
> if the same registers are used for DMA/PIO timings).

    Timeouts ensued in my case...

WBR, Sergei
