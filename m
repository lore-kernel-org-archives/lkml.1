Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0BWHAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:00:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:33446 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab0BWHAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:00:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Loo <tloo@saltstorm.net>
Subject: Re: Sony Ericson w995 does not local net mode
Followup-To: gmane.linux.kernel
Date: Tue, 23 Feb 2010 07:55:23 +0100
Organization: Saltstorm labs.
Message-ID: <hlvu34$dag$1@dough.gmane.org>
References: <4B7ACB75.4070907@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: host-90-232-223-38.mobileonline.telia.com
User-Agent: KNode/4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Sechser wrote:

> Hello guys,
> 
> 
> Please CC me for Questions and answers
> 
> 
> I have got an w995 Sony Ericsson, but i cant make local net via usb 
with
> it. I uploaded a recent software version: 1215-7995 R1HA036 091216
> 

I have run into this aswell. The log seems to indicate its related, 
though I have a Sony Ericsson J105i (Naite) phone. I figured out it had 
to be explicitly whitelisted in the drivers/net/usb/cdc_ether.c module.

I proposed the following patch for the J105i 
<http://article.gmane.org/gmane.linux.network/147442/> back in 
december, but I don't think it was picked up. As I mentioned in the 
patch, I think a slew of the new SE models trip on this particular 
issue.

Try replacing the USB id in the patch with the W995 one and see if it 
makes any difference.

Regards,
Thomas Loo


> 
> First for the usb ID guys since the ids are not yet in usbid.txt:
> 
> PC mode            (for Windows(r))
>   usb 1-4: New USB device found, idVendor=0fce, idProduct=e112
>   usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>   usb 1-4: Product: Memory Card (MSC)
>   usb 1-4: Manufacturer: Sony Ericsson
>   usb 1-4: SerialNumber: 3582180356368990
>   usb 1-4: configuration #1 chosen from 1 choice
> 
> 
> USB mem. device        (File transfer)
>   usb 1-4: New USB device found, idVendor=0fce, idProduct=2112
>   usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>   usb 1-4: Product: Sony Ericsson W995
>   usb 1-4: Manufacturer: Sony Ericsson
>   usb 1-4: SerialNumber: 3582180356368990
>   usb 1-4: configuration #1 chosen from 5 choices
>   Initializing USB Mass Storage driver...
> 
> Other OS         (E.g. Mac(tm), Linux(tm))
>   usb 1-4: New USB device found, idVendor=0fce, idProduct=d112
>   usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>   usb 1-4: Product: Sony Ericsson W995
>   usb 1-4: Manufacturer: Sony Ericsson
>   usb 1-4: SerialNumber: 3582180356368990
>   usb 1-4: configuration #1 chosen from 1 choice
> 
> MTP devices        (E.g. certain car stereos)
>   usb 1-4: New USB device found, idVendor=0fce, idProduct=0112
>   usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>   usb 1-4: Product: W995
>   usb 1-4: Manufacturer: Sony Ericsson
>   usb 1-4: SerialNumber: 3582180356368990
>   usb 1-4: configuration #1 chosen from 1 choice
> 
> 
> Now USB mass storage works, PC mode doesnt bother me much, but i
> actually excepted Other OS mode to work, which it does not.
> 
> following are the logs:
> Feb  6 18:40:01 jebian2 kernel: [  247.240026] usb 1-4: new high 
speed
> USB device using ehci_hcd and address 6
> Feb  6 18:40:01 jebian2 kernel: [  247.376970] usb 1-4: New USB 
device
> found, idVendor=0fce, idProduct=d112
> Feb  6 18:40:01 jebian2 kernel: [  247.376977] usb 1-4: New USB 
device
> strings: Mfr=1, Product=2, SerialNumber=3
> Feb  6 18:40:01 jebian2 kernel: [  247.376983] usb 1-4: Product: Sony
> Ericsson W995
> Feb  6 18:40:01 jebian2 kernel: [  247.376987] usb 1-4: Manufacturer:
> Sony Ericsson
> Feb  6 18:40:01 jebian2 kernel: [  247.376991] usb 1-4: SerialNumber:
> 3582180356368990
> Feb  6 18:40:01 jebian2 kernel: [  247.378726] usb 1-4: configuration 
#1
> chosen from 1 choice
> Feb  6 18:40:01 jebian2 kernel: [  247.487110] cdc_wdm 1-4:1.7:
> cdc-wdm0: USB WDM device
> Feb  6 18:40:01 jebian2 kernel: [  247.487190] usbcore: registered 
new
> interface driver cdc_wdm
> Feb  6 18:40:01 jebian2 kernel: [  247.502990] cdc_acm 1-4:1.1: 
ttyACM0:
> USB ACM device
> Feb  6 18:40:01 jebian2 kernel: [  247.515010] cdc_acm 1-4:1.3: 
ttyACM1:
> USB ACM device
> Feb  6 18:40:01 jebian2 kernel: [  247.531016] usbcore: registered 
new
> interface driver cdc_acm
> Feb  6 18:40:01 jebian2 kernel: [  247.531024] cdc_acm: v0.26:USB
> Abstract Control Model driver for USB modems and ISDN adapters
> Feb  6 18:40:01 jebian2 kernel: [  247.536755] usbcore: registered 
new
> interface driver cdc_ether
> Feb  6 18:40:01 jebian2 kernel: [  247.543927] usb 1-4: unsupported 
MDLM
> descriptors
> Feb  6 18:40:01 jebian2 kernel: [  247.544394] usbcore: registered 
new
> interface driver zaurus
> Feb  6 18:40:01 jebian2 modem-manager: (ttyACM1) opening serial 
device...
> Feb  6 18:40:01 jebian2 modem-manager: (ttyACM1): probe requested by
> plugin 'Generic'
> Feb  6 18:40:01 jebian2 modem-manager: (ttyACM0) opening serial 
device...
> Feb  6 18:40:01 jebian2 modem-manager: (ttyACM0): probe requested by
> plugin 'Generic'
> Feb  6 18:40:03 jebian2 modem-manager: (ttyACM1) closing serial 
device...
> Feb  6 18:40:03 jebian2 modem-manager: (Generic): GSM modem
> /sys/devices/pci0000:00/0000:00:02.1/usb1/1-4 claimed port ttyACM1
> Feb  6 18:40:03 jebian2 modem-manager: Added modem
> /sys/devices/pci0000:00/0000:00:02.1/usb1/1-4
> Feb  6 18:40:03 jebian2 modem-manager: Exported modem
> /sys/devices/pci0000:00/0000:00:02.1/usb1/1-4 as
> /org/freedesktop/ModemManager/Modems/0
> Feb  6 18:40:03 jebian2 modem-manager: (ttyACM0) closing serial 
device...
> Feb  6 18:40:03 jebian2 modem-manager: (Generic): GSM modem
> /sys/devices/pci0000:00/0000:00:02.1/usb1/1-4 claimed port ttyACM0
> Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): new GSM
> device (driver: 'cdc_acm')
> Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): exported 
as
> /org/freedesktop/NetworkManager/Devices/2
> Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): now 
managed
> Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): device 
state
> change: 1 -> 2 (reason 2)
> Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): 
deactivating
> device (reason: 2).
> Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): device 
state
> change: 2 -> 3 (reason 0)
> 
> 
> when removing the device
> Feb  6 18:40:33 jebian2 kernel: [  279.107138] usb 1-4: USB 
disconnect,
> address 6
> Feb  6 18:40:33 jebian2 kernel: [  279.116777] ehci_hcd 0000:00:02.1:
> dma_pool_free buffer-2048, ffff880052624000/52624000 (bad dma)
> Feb  6 18:40:33 jebian2 modem-manager: Removed modem
> /sys/devices/pci0000:00/0000:00:02.1/usb1/1-4
> Feb  6 18:40:33 jebian2 NetworkManager: <info>  (ttyACM1): now 
unmanaged
> Feb  6 18:40:33 jebian2 NetworkManager: <info>  (ttyACM1): device 
state
> change: 3 -> 1 (reason 36)
> Feb  6 18:40:33 jebian2 NetworkManager: <info>  (ttyACM1): cleaning 
up...
> Feb  6 18:40:33 jebian2 NetworkManager: <info>  (ttyACM1): taking 
down
> device.
> 
> 
> dmesg orig:
> [  247.240026] usb 1-4: new high speed USB device using ehci_hcd and
> address 6
> [  247.376970] usb 1-4: New USB device found, idVendor=0fce,
> [  idProduct=d112 247.376977] usb 1-4: New USB device strings: Mfr=1,
> [  Product=2,
> SerialNumber=3
> [  247.376983] usb 1-4: Product: Sony Ericsson W995
> [  247.376987] usb 1-4: Manufacturer: Sony Ericsson
> [  247.376991] usb 1-4: SerialNumber: 3582180356368990
> [  247.378726] usb 1-4: configuration #1 chosen from 1 choice
> [  247.487110] cdc_wdm 1-4:1.7: cdc-wdm0: USB WDM device
> [  247.487190] usbcore: registered new interface driver cdc_wdm
> [  247.502990] cdc_acm 1-4:1.1: ttyACM0: USB ACM device
> [  247.515010] cdc_acm 1-4:1.3: ttyACM1: USB ACM device
> [  247.531016] usbcore: registered new interface driver cdc_acm
> [  247.531024] cdc_acm: v0.26:USB Abstract Control Model driver for 
USB
> modems and ISDN adapters
> [  247.536755] usbcore: registered new interface driver cdc_ether
> [  247.543927] usb 1-4: unsupported MDLM descriptors
> [  247.544394] usbcore: registered new interface driver zaurus
> [  279.107138] usb 1-4: USB disconnect, address 6
> [  279.116777] ehci_hcd 0000:00:02.1: dma_pool_free buffer-2048,
> ffff880052624000/52624000 (bad dma)
> 
> 
> 
> I guess you know better whats wrong than me.
> 
> 
> cheers
> 
> jan


