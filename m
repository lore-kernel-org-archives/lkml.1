Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbXKHACN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbXKHACN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXKHAB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:01:58 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:44287 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbXKHAB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:01:56 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>
Cc: James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Date: Thu, 8 Nov 2007 02:01:44 +0200
Message-Id: <20071107235548.M95675@visp.net.lb>
In-Reply-To: <20071107232045.GA26706@havoc.gtf.org>
References: <20071101213013.M54162@visp.net.lb> <20071106221521.4f64a066.akpm@linux-foundation.org> <20071107132630.M65286@visp.net.lb> <4731D85E.70201@daa.com.au> <20071107160426.M31617@visp.net.lb> <47320E37.8010106@rtr.ca> <20071107232045.GA26706@havoc.gtf.org>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-rc2 not working very well


dmesg
[   12.386395] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   12.405579] ide: Assuming 33MHz system bus speed for PIO modes; override 
with idebus=xx
[   12.430441] SC1200: IDE controller (0x100b:0x0502 rev 0x01) at  PCI slot 
0000:00:12.2
[   12.454070] SC1200: not 100% native mode: will probe irqs later
[   12.471947]     ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:pio, 
hdb:pio
[   12.493873]     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:pio, 
hdd:pio
[   12.515810] Probing IDE interface ide0...
[   12.528810] Clocksource tsc unstable (delta = -497423729 ns)
[   12.545888] Time: pit clocksource has been installed.
[   12.563379] hda: SanDisk SDCFH-1024, CFA DISK drive
[   12.578340] hda: applying conservative PIO "downgrade"
[   12.593869] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO1
[   12.594006] hda: MW DMA 2 mode selected
[   12.594297] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   12.608778] Probing IDE interface ide1...
[   12.623192] hda: max request size: 128KiB
[   12.635322] hda: 2001888 sectors (1024 MB) w/1KiB Cache, CHS=1986/16/63, 
DMA
[   12.657134]  hda:<4>hda: dma_timer_expiry: dma status == 0x21
[   12.865846] hda: DMA timeout error
[   12.876092]  ide_dma_end dma_stat=21 err=1 newerr=0
[   12.890753] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
DataRequest }
[   12.914977] ide: failed opcode was: unknown
[   12.927743] hda: DMA disabled
[   12.937035] ide0: reset: success
[   12.948324]  hda1

Mounting taking long time on 1GB card cause of DMA issues. In dmesg i am not 
sure about timestamp showing few seconds, in real life it took about 2 
minutes.

after that in dmesg
[   14.965070] hda: dma_timer_expiry: dma status == 0x21
[   15.107909] hda: DMA timeout error
[   15.118149]  ide_dma_end dma_stat=21 err=1 newerr=0
[   15.132809] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
DataRequest }
[   15.157035] ide: failed opcode was: unknown
[   15.169799] hda: DMA disabled
[   15.178797] ide0: reset: success
[   15.312698] hda: dma_timer_expiry: dma status == 0x21
[   15.650705] hda: DMA timeout error
[   15.660952]  ide_dma_end dma_stat=21 err=1 newerr=0
[   15.675614] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
DataRequest }
[   15.699836] ide: failed opcode was: unknown
[   15.712601] hda: DMA disabled
[   15.721603] ide0: reset: success
[   16.325999] hda: dma_timer_expiry: dma status == 0x21
[   16.565756] hda: DMA timeout error
[   16.576001]  ide_dma_end dma_stat=21 err=1 newerr=0
[   16.590661] hda: dma timeout error: status=0x58 { DriveReady SeekComplete 
DataRequest }
[   16.614886] ide: failed opcode was: unknown
[   16.627651] hda: DMA disabled
[   16.636659] ide0: reset: success
[   16.650061] EXT2-fs warning: mounting unchecked fs, running e2fsck is 
recommended


On Wed, 7 Nov 2007 18:20:45 -0500, Jeff Garzik wrote
> On Wed, Nov 07, 2007 at 02:12:55PM -0500, Mark Lord wrote:
> > That cannot be correct (??).  Is this with hdparm-7.7 (latest 
sourceforge) 
> > ??
> > Can you show us the "hdparm --Istdout" output as well, please.
> 
> If this is applicable...  FWIW hdparm was only recently (in past <72
> hours) updated from 6.9 to 7.7 in Fedora...
> 
> 	Jeff


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

