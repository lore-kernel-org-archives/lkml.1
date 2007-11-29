Return-Path: <linux-kernel-owner+w=401wt.eu-S1763617AbXK2TNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763617AbXK2TNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762683AbXK2TND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:13:03 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:57054 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761762AbXK2TNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:13:01 -0500
Message-ID: <474F0F3A.6050001@grupopie.com>
Date: Thu, 29 Nov 2007 19:12:58 +0000
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Pete Zaitcev <zaitcev@redhat.com>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Add the infamous Huawei E220 to option.c
References: <20071128161305.b01167b3.zaitcev@redhat.com> <200711291149.46326.oliver@neukum.org> <474E9D7E.4040007@grupopie.com> <200711291255.08603.oliver@neukum.org>
In-Reply-To: <200711291255.08603.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Donnerstag 29 November 2007 schrieb Rui Santos:
>   
>>>> Just to remember that that specific flag was one SET and, was removed,
>>>> in part, because of what I state. Of course we aim at perfection but, if
>>>> the benefits are only for a few situations and, will cause all this
>>>> problems for all other, perhaps the reinsert of that flag would be a
>>>> positive action.
>>>>     
>>>>         
>>> OK, can you provide "lsusb -v" for the device in the CD mode and in
>>> the modem mode?
>>>   
>>>       
>> Of course. Heri it is.
>>     
>
> Thanks. Please try this patch.
>
> 	Regards
> 		Oliver
>
> ----
>
> --- a/drivers/usb/serial/option.c	2007-11-29 12:35:09.000000000 +0100
> +++ b/drivers/usb/serial/option.c	2007-11-29 12:47:34.000000000 +0100
> @@ -158,7 +158,7 @@ static struct usb_device_id option_ids[]
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
>  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
> -	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel Merlin XS620/S640 */
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel Merlin S620 */
>   

This patch worked for me on linux-2.6.24-rc3-git4. There are a few
errors but, it seems to be working as it should. Here is the dmesg output:

usb 4-1: new full speed USB device using uhci_hcd and address 9
usb 4-1: configuration #1 chosen from 1 choice
scsi13 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 9
usb-storage: waiting for device to settle before scanning
usb 4-1: USB disconnect, address 9
usb 4-1: new full speed USB device using uhci_hcd and address 10
usb 4-1: configuration #1 chosen from 1 choice
usb-storage: probe of 4-1:1.0 failed with error -5
option 4-1:1.0: GSM modem (1-port) converter detected
usb 4-1: GSM modem (1-port) converter now attached to ttyUSB0
usb-storage: probe of 4-1:1.1 failed with error -5
option 4-1:1.1: GSM modem (1-port) converter detected
usb 4-1: GSM modem (1-port) converter now attached to ttyUSB1
scsi16 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 10
usb-storage: waiting for device to settle before scanning
scsi 16:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0
ANSI: 2
sr0: scsi-1 drive
sr 16:0:0:0: Attached scsi CD-ROM sr0
sr 16:0:0:0: Attached scsi generic sg2 type 5
usb-storage: device scan complete
sr0: CDROM (ioctl) error, command: Get configuration 46 00 00 00 00 00
00 00 20 00
sr: Sense Key : No Sense [current]
sr: Add. Sense: No additional sense information



Rui Santos

