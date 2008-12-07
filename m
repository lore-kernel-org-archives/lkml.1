Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYLGSr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYLGSr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYLGSrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:47:19 -0500
Received: from main.gmane.org ([80.91.229.2]:33331 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbYLGSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:47:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PROBLEM] Hw problem or software bug? DMA: Out of SW-IOMMU space....
Date: Sun, 07 Dec 2008 12:47:08 -0600
Message-ID: <493C1A2C.3080801@shaw.ca>
References: <12bfabe40812061948w4069e389ub90c4af86a493da6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <12bfabe40812061948w4069e389ub90c4af86a493da6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giangiacomo Mariotti wrote:
> I'm running Linux 2.6.27.8.(PS. Today I've sent another e-mail about a
> problem with my new Intel I7 920, but it doesn't seem related except
> for the fact that with 2.6.26.8 neither of them seem to occur.)
> I just read this through dmesg :
> Dec  7 03:33:49 debian-hell kernel: [57102.830078] DMA: Out of
> SW-IOMMU space for 16384 bytes at device 0000:00:1f.2
> Dec  7 03:33:49 debian-hell kernel: [57102.830167] ata1.00: exception
> Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Dec  7 03:33:49 debian-hell kernel: [57102.830175] ata1.00: cmd
> 35/00:00:af:e5:54/00:04:08:00:00/e0 tag 0 dma 524288 out
> Dec  7 03:33:49 debian-hell kernel: [57102.830176]          res
> 50/00:00:ae:e5:54/00:00:08:00:00/e0 Emask 0x40 (internal error)
> Dec  7 03:33:49 debian-hell kernel: [57102.830180] ata1.00: status: { DRDY }
> Dec  7 03:33:49 debian-hell kernel: [57102.897407] ata1.00: configured
> for UDMA/133
> Dec  7 03:33:49 debian-hell kernel: [57102.897420] ata1: EH complete
> Dec  7 03:33:49 debian-hell kernel: [57102.897542] DMA: Out of
> SW-IOMMU space for 16384 bytes at device 0000:00:1f.2
> Dec  7 03:33:49 debian-hell kernel: [57102.897574] ata1.00: exception
> Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Dec  7 03:33:49 debian-hell kernel: [57102.897580] ata1.00: cmd
> 35/00:00:af:e5:54/00:04:08:00:00/e0 tag 0 dma 524288 out
> Dec  7 03:33:49 debian-hell kernel: [57102.897581]          res
> 50/00:00:af:6d:70/00:00:74:00:00/e0 Emask 0x40 (internal error)
> Dec  7 03:33:49 debian-hell kernel: [57102.897584] ata1.00: status: { DRDY }
> Dec  7 03:33:49 debian-hell kernel: [57102.921416] ata1.00: configured
> for UDMA/133
> Dec  7 03:33:49 debian-hell kernel: [57102.921435] ata1: EH complete
> Dec  7 03:33:49 debian-hell kernel: [57102.921552] DMA: Out of
> SW-IOMMU space for 16384 bytes at device 0000:00:1f.2
> Dec  7 03:33:49 debian-hell kernel: [57102.921586] ata1.00: exception
> Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Dec  7 03:33:49 debian-hell kernel: [57102.921592] ata1.00: cmd
> 35/00:00:af:e5:54/00:04:08:00:00/e0 tag 0 dma 524288 out
> Dec  7 03:33:49 debian-hell kernel: [57102.921593]          res
> 50/00:00:af:6d:70/00:00:74:00:00/e0 Emask 0x40 (internal error)
> Dec  7 03:33:49 debian-hell kernel: [57102.921597] ata1.00: status: { DRDY }
> Dec  7 03:33:49 debian-hell kernel: [57102.945397] ata1.00: configured
> for UDMA/133
> Dec  7 03:33:49 debian-hell kernel: [57102.945417] ata1: EH complete

Seems like you have lots of disks, it could be you just have too much IO 
in flight at the same time for the size of the IOMMU area. You might be 
able to avoid that by increasing the SW-IOMMU size.

However, your system should be AHCI capable, you should try to switch 
the SATA controller into that mode in the BIOS (possibly labelled RAID 
mode or something). Then it shouldn't need to use bounce buffers for 
disk access in the first place (plus give you NCQ support).

