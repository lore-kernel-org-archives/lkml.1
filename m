Return-Path: <linux-kernel-owner+w=401wt.eu-S933887AbXK2UMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbXK2UMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXK2UMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:12:23 -0500
Received: from rtr.ca ([76.10.145.34]:1945 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519AbXK2UMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:12:22 -0500
Message-ID: <474F1D24.4070009@rtr.ca>
Date: Thu, 29 Nov 2007 15:12:20 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Nick Warne <nick@ukfsn.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Peculiar out-of-sync boot log lines
References: <20071129193728.2f1c237e@linuxamd.linicks.net>
In-Reply-To: <20071129193728.2f1c237e@linuxamd.linicks.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Warne wrote:
> Hi all,
> 
> 2.6.23.9
> 
> I have noticed after applying Bart's patch to word93 blacklist my new
> DVD drive:
> 
> http://lkml.org/lkml/2007/10/23/475
> 
> I see now in logs (look at the hdd line:
> 
> [dmesg]
> hdc: 39876480 sectors (20416 MB) w/2048KiB Cache, CHS=39560/16/63,
> UDMA(66)
> hdc: cache flushes not supported
>  hdc: hdc1
> hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd:
> skipping word 93 validity check
> , UDMA(66)
> Uniform CD-ROM driver Revision: 3.20
> 
> 
> <7> ??  And the ", UDMA(66)" gets new lined, so in syslog it appears all
> by itself:
...

That's a minor bug with the patch.

The code does this:

ide_dma_verbose::printk( ... "2048kB Cache");
eighty_ninty_three::printk(KERN_DEBUG "%s: skipping word 93 validity check\n");
ide_dma_verbose::printk(", UDMA(66)"

Something in there needs to insert a '\n' before the "skipping word" message.
Since it doesn't do that right now, the KERN_DEBUG string appears as "<7>"
