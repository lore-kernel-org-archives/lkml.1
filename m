Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZLCXAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZLCXAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZLCXAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:00:25 -0500
Received: from mail001.aei.ca ([206.123.6.130]:52439 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZLCXAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:00:24 -0500
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.32 - Sddr-09 SM reader resets endlessly
Date: Thu, 3 Dec 2009 18:00:11 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32-crc; KDE/4.3.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031800.11780.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just booted in 2.6.32 and shortly after the boot finished my console was spammed with:

[   72.221620] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   72.375589] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   72.529568] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   72.683603] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   72.837601] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   72.991700] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   73.145679] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   73.309620] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   73.463603] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   73.617604] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   73.704218] usb 7-4.1: device descriptor read/all, error -32                                                                              
[   73.773612] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   73.927569] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   74.081627] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
[   74.244640] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5 

I noticed the leds on the devince blinking and unplugged it.  The messages stopped.

Plugging it in to another port gave:

[  120.096590] usb 7-4.2: new full speed USB device using ehci_hcd and address 7                                                             
[  120.188421] usb 7-4.2: New USB device found, idVendor=0781, idProduct=0200                                                                
[  120.196857] usb 7-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0                                                           
[  120.205801] usb 7-4.2: Product: USB SSFDC                                                                                                 
[  120.205803] usb 7-4.2: Manufacturer: SanDisk                                                                                              
[  120.206023] usb 7-4.2: configuration #1 chosen from 1 choice                                                                              
[  120.210375] scsi10 : SCSI emulation for USB Mass Storage devices                                                                          
[  120.210625] usb-storage: device found at 7                                                                                                
[  120.210627] usb-storage: waiting for device to settle before scanning                                                                     
[  125.210356] scsi 10:0:0:0: Direct-Access     Sandisk0 ImageMate SDDR-0 0208 PQ: 0 ANSI: 0                                                 
[  125.221014] sd 10:0:0:0: Attached scsi generic sg8 type 0                                                                                 
[  125.538583] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  125.693592] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  125.846595] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  125.999570] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  126.152625] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  126.306641] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  126.400839] sddr09: could not read card info
[  126.412283] sddr09: could not read card info
[  126.418737] sd 10:0:0:0: [sdh] Test WP failed, assume Write Enabled
[  126.418760] usb-storage: device scan complete
[  126.433764] sd 10:0:0:0: [sdh] Assuming drive cache: write through
[  126.497612] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  126.654080] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  126.810051] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  126.965658] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  127.121623] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  127.276631] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  127.366116] sd 10:0:0:0: [sdh] Attached SCSI removable disk
[  140.543572] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  140.699676] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  140.855450] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  141.010675] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  141.166668] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
[  141.322616] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7

just in case it happened to be an interaction with the hub used I tried another:

[ 1294.563062] usb 3-1: new full speed USB device using ohci_hcd and address 3
[ 1294.718252] usb 3-1: New USB device found, idVendor=0781, idProduct=0200
[ 1294.725162] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 1294.732507] usb 3-1: Product: USB SSFDC
[ 1294.732508] usb 3-1: Manufacturer: SanDisk
[ 1294.733099] usb 3-1: configuration #1 chosen from 1 choice
[ 1294.745034] scsi11 : SCSI emulation for USB Mass Storage devices
[ 1294.747443] usb-storage: device found at 3
[ 1294.747446] usb-storage: waiting for device to settle before scanning
[ 1299.747426] scsi 11:0:0:0: Direct-Access     Sandisk  ImageMate SDDR-0 0208 PQ: 0 ANSI: 0
[ 1299.756510] sd 11:0:0:0: Attached scsi generic sg8 type 0
[ 1300.134401] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1300.412298] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1300.688049] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1300.963179] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1301.244400] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1301.524066] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1301.687139] sddr09: could not read card info
[ 1301.703118] sddr09: could not read card info
[ 1301.707764] usb-storage: device scan complete
[ 1301.708402] sd 11:0:0:0: [sdh] Test WP failed, assume Write Enabled
[ 1301.708404] sd 11:0:0:0: [sdh] Assuming drive cache: write through
[ 1301.848059] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1302.124049] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1302.400044] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1302.677051] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1302.952305] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1303.229063] usb 3-1: reset full speed USB device using ohci_hcd and address 3
[ 1303.378075] sd 11:0:0:0: [sdh] Attached SCSI removable disk
[ 1314.966421] usb 3-1: reset full speed USB device using ohci_hcd and address 3

with the same results.

Ideas? 

Ed

