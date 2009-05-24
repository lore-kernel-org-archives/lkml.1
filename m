Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZEXHQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZEXHQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZEXHQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:16:41 -0400
Received: from smtpout1.uol.com.br ([200.221.4.192]:56877 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbZEXHQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:16:40 -0400
Date: Sun, 24 May 2009 04:16:37 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
Message-ID: <20090524071637.GA5487@ime.usp.br>
References: <20090501091501.GA29466@ime.usp.br> <Pine.LNX.4.44L0.0905011509220.2989-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0905011509220.2989-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 334e2f1e1708a4b4385e806c56bdd1d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan & Co.

On May 01 2009, Alan Stern wrote:
> I've got a USB disk drive and cable that do not work on my home PC, 
> although they do work on my office PC.  If I use a different cable then 
> the drive does work on the home PC.  If I use the same cable but 
> substitute a USB stick for the drive, again it works.  So which 
> component is bad: the home PC, the cable, or the drive?

Yes, right.

Resuming our earlier discussion, I got another case of weird USB
messages here with kernel 2.6.30-rc5 (sorry, I have not yet had time to
use anything newer).

My father has a USB (1.1, I would say, which matches what the logs say)
stick/pen drive that, when I connect to my ECHI controller on my machine
with an ICH5 chipset, I get:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ 2285.628018] usb 4-2: new full speed USB device using uhci_hcd and address 2
[ 2285.784924] usb 4-2: New USB device found, idVendor=067b, idProduct=2315
[ 2285.784932] usb 4-2: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[ 2285.784936] usb 4-2: Product: USB Embedded Hub
[ 2285.784939] usb 4-2: Manufacturer: Leading Driver Co.,LTD.
[ 2285.785039] PM: Adding info for usb:4-2
[ 2285.785084] usb 4-2: configuration #1 chosen from 1 choice
[ 2285.787985] PM: Adding info for usb:4-2:1.0
[ 2285.788046] hub 4-2:1.0: USB hub found
[ 2285.789956] hub 4-2:1.0: 2 ports detected
[ 2285.794051] PM: Adding info for No Bus:usbdev4.2_ep81
[ 2285.794137] PM: Adding info for No Bus:usbdev4.2_ep00
[ 2286.064854] usb 4-2.1: new full speed USB device using uhci_hcd and address 3
[ 2286.184819] usb 4-2.1: New USB device found, idVendor=067b, idProduct=2317
[ 2286.184825] usb 4-2.1: New USB device strings: Mfr=1, Product=4, SerialNumber=0
[ 2286.184830] usb 4-2.1: Product: USB Mass Storage Device
[ 2286.184833] usb 4-2.1: Manufacturer: Leading Driver Co.,LTD.
[ 2286.184926] PM: Adding info for usb:4-2.1
[ 2286.184974] usb 4-2.1: configuration #1 chosen from 1 choice
[ 2286.187878] PM: Adding info for usb:4-2.1:1.0
[ 2286.187994] PM: Adding info for No Bus:usbdev4.3_ep01
[ 2286.188068] PM: Adding info for No Bus:usbdev4.3_ep82
[ 2286.188133] PM: Adding info for No Bus:usbdev4.3_ep00
[ 2286.239239] SCSI subsystem initialized
[ 2286.253935] Initializing USB Mass Storage driver...
[ 2286.254816] usb 4-2.2: new full speed USB device using uhci_hcd and address 4
[ 2286.255696] scsi0 : SCSI emulation for USB Mass Storage devices
[ 2286.255763] PM: Adding info for scsi:host0
[ 2286.255830] PM: Adding info for No Bus:host0
[ 2286.256419] usbcore: registered new interface driver usb-storage
[ 2286.256426] USB Mass Storage support registered.
[ 2286.257378] usb-storage: device found at 3
[ 2286.257382] usb-storage: waiting for device to settle before scanning
[ 2286.372799] usb 4-2.2: New USB device found, idVendor=067b, idProduct=2316
[ 2286.372807] usb 4-2.2: New USB device strings: Mfr=1, Product=5, SerialNumber=0
[ 2286.372811] usb 4-2.2: Product: USB Security Device
[ 2286.372814] usb 4-2.2: Manufacturer: Leading Driver Co.,LTD.
[ 2286.372906] PM: Adding info for usb:4-2.2
[ 2286.372957] usb 4-2.2: configuration #1 chosen from 1 choice
[ 2286.375825] PM: Adding info for usb:4-2.2:1.0
[ 2286.375951] PM: Adding info for No Bus:usbdev4.4_ep00
[ 2291.258587] usb-storage: device scan complete
[ 2291.261567] scsi 0:0:0:0: Direct-Access     Prolific USB Flash Disk   1.00 PQ: 0 ANSI: 0 CCS
[ 2291.262023] PM: Adding info for scsi:target0:0:0
[ 2291.262497] PM: Adding info for scsi:0:0:0:0
[ 2291.262711] PM: Adding info for No Bus:0:0:0:0
[ 2291.273924] Driver 'sd' needs updating - please use bus_type methods
[ 2291.274557] PM: Adding info for No Bus:0:0:0:0
[ 2291.280525] sd 0:0:0:0: [sda] 256000 512-byte hardware sectors: (131 MB/125 MiB)
[ 2291.283532] sd 0:0:0:0: [sda] Write Protect is off
[ 2291.283539] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[ 2291.283543] sd 0:0:0:0: [sda] Assuming drive cache: write through
[ 2291.283603] PM: Adding info for No Bus:sda
[ 2291.290517] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2291.290523]    : Sense Key : 0x0 [current] 
[ 2291.290529]    : ASC=0x0 ASCQ=0x0
[ 2291.298513] sd 0:0:0:0: [sda] Assuming drive cache: write through
[ 2291.298520]  sda: sda1
[ 2291.304573] PM: Adding info for No Bus:sda1
[ 2291.309522] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2291.309527]    : Sense Key : 0x0 [current] 
[ 2291.309533]    : ASC=0x0 ASCQ=0x0
[ 2291.309625] PM: Adding info for No Bus:8:0
[ 2291.309651] sd 0:0:0:0: [sda] Attached SCSI removable disk
[ 2291.330510] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2291.330518]    : Sense Key : 0x0 [current] 
[ 2291.330524]    : ASC=0x0 ASCQ=0x0
[ 2291.634434] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2291.634440]    : Sense Key : 0x0 [current] 
[ 2291.634446]    : ASC=0x0 ASCQ=0x0
[ 2291.703422] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2291.703430]    : Sense Key : 0x0 [current] 
[ 2291.703436]    : ASC=0x0 ASCQ=0x0
[ 2291.725411] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2291.725415]    : Sense Key : 0x0 [current] 
[ 2291.725420]    : ASC=0x0 ASCQ=0x0
[ 2291.735409] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2291.735417]    : Sense Key : 0x0 [current] 
[ 2291.735423]    : ASC=0x0 ASCQ=0x0
[ 2292.036329] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2292.036336]    : Sense Key : 0x0 [current] 
[ 2292.036342]    : ASC=0x0 ASCQ=0x0
[ 2292.046354] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2292.046361]    : Sense Key : 0x0 [current] 
[ 2292.046367]    : ASC=0x0 ASCQ=0x0
[ 2292.348248] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2292.348255]    : Sense Key : 0x0 [current] 
[ 2292.348261]    : ASC=0x0 ASCQ=0x0
[ 2292.414240] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2292.414246]    : Sense Key : 0x0 [current] 
[ 2292.414252]    : ASC=0x0 ASCQ=0x0
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

In particular, those ioctl_internal_command return code messages seem
strange, regarding other USB devices that I have. Are they being shown
because I have some debugging information in my kernel or are they
abnormal?


Thanks for any help,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
