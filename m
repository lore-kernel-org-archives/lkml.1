Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZLERzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZLERzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 12:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZLERzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 12:55:35 -0500
Received: from netrider.rowland.org ([192.131.102.5]:60747 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755720AbZLERze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 12:55:34 -0500
Date: Sat, 5 Dec 2009 12:55:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ed Tomlinson <edt@aei.ca>
cc: Andries Brouwer <aeb@cwi.nl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [BUG] 2.6.32 - Sddr-09 SM reader resets endlessly
In-Reply-To: <200912042344.21996.edt@aei.ca>
Message-ID: <Pine.LNX.4.44L0.0912051246580.15558-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Ed Tomlinson wrote:

> Alan,
> 
> For console:
> 
> [ 1259.709281] usb 3-1: new full speed USB device using ohci_hcd and address 4
> [ 1259.867687] usb 3-1: New USB device found, idVendor=0781, idProduct=0200

Not shown explicitly, the bcdDevice value is 0208.

> [ 1259.874603] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [ 1259.881956] usb 3-1: Product: USB SSFDC
> [ 1259.881958] usb 3-1: Manufacturer: SanDisk
> [ 1259.882194] usb 3-1: configuration #1 chosen from 1 choice
> [ 1259.891501] scsi10 : SCSI emulation for USB Mass Storage devices
> [ 1259.892743] usb-storage: device found at 4
> [ 1259.892746] usb-storage: waiting for device to settle before scanning
> [ 1264.892142] scsi 10:0:0:0: Direct-Access     Sandisk0 ImageMate SDDR-0 0208 PQ: 0 ANSI: 0

The '0' at the end of "Sandisk0" is caused by a bug in usb-storage.

> [ 1264.901175] sd 10:0:0:0: Attached scsi generic sg8 type 0
> [ 1265.279293] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1265.558305] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1265.837226] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1266.112307] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1266.388099] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1266.666283] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1266.830235] sddr09: could not read card info
> [ 1266.847287] sddr09: could not read card info
> [ 1266.851769] usb-storage: device scan complete
> [ 1266.852988] sd 10:0:0:0: [sdh] Test WP failed, assume Write Enabled
> [ 1266.852991] sd 10:0:0:0: [sdh] Assuming drive cache: write through
> [ 1266.991289] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1267.297268] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1267.574303] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1267.851310] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1268.129290] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1268.408257] usb 3-1: reset full speed USB device using ohci_hcd and address 4
> [ 1268.560201] sd 10:0:0:0: [sdh] Attached SCSI removable disk
> [ 1280.034256] usb 3-1: USB disconnect, address 4
> 
> Here is the trace. 

Skipping to the important part, where the sddr09 driver implements TEST 
UNIT READY:

> ffff8801571e5240 2548283209 S Co:3:004:0 s 41 00 0000 0000 000c 12 = 00200000 00000000 00000000
> ffff8801571e5240 2548536793 C Co:3:004:0 -32 12 >

That failure is responsible for the resets.

Andries, do you have any idea what's going on?  Evidently this device 
doesn't accept the protocol used by the sddr09 driver.

Alan Stern

