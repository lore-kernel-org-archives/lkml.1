Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYGDUmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYGDUmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYGDUlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:41:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51957 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752196AbYGDUlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:41:52 -0400
Date: Fri, 4 Jul 2008 21:22:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alan@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080704212204.7c94ca7c@lxorguk.ukuu.org.uk>
In-Reply-To: <200807042153.56644.linux@rainbow-software.org>
References: <200807042153.56644.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When I don't have any RAID array created, both drives are detected but it 
> appears to work only in MWDMA2 mode:

The speed is meaningless in hardware RAID mode. Its also btw usually
faster (except for some cases of RAID1 with high PCI bus utilisation like
video capture boxes) in non RAID mode ;)

> ata3: PATA max MWDMA2 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
> ata4: PATA max MWDMA2 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11

I'll have a poke at that, see if I can make it lie more meaningfully

> ata4.00: configured for DMA

as it does here.

> Also I get some errors about HPA when rebooting but haven't captured them yet. 

IT821x does not support the HPA in 'raid' mode, only in non RAID mode so
it would complain about the HPA.


> But the more interesting thing is that once I create a RAID1 array (and run 
> background rebuild), the driver does not work anymore:

Ok that is a bug I've not met. What firmware revision is this and does it
work after the rebuild is done ?

> ata3.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_masl=0x80)
> ata3: failed to recover some devices, retrying in 5 secs
> ata3.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_masl=0x80)
> ata3: failed to recover some devices, retrying in 5 secs
> ata3.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_masl=0x80)
> ata3: failed to recover some devices, retrying in 5 secs

It seems to have decided to be indefinitely busy from that.

Alan
