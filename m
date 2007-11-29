Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbXK2SwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbXK2SwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759873AbXK2Svv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:51:51 -0500
Received: from hu-out-0506.google.com ([72.14.214.225]:32313 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834AbXK2Svu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:51:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=pHzWxQ9XWHGtUsloewlK3onVMqx+LgeYLl5mkC2/az0QGSh18KEcplmcQ9L+XoY6kwGxvg9zzQOJXXpLV3/PkApHG/PybXGDf9XeOLSFcXPHzQrNm7QDRlXbm1PT/GHK4yHcJqAiCZWY9hS4qAq0WtJfvnAK3AjvW+MA+nNHt+8=
Date: Thu, 29 Nov 2007 18:53:39 +0000
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: Johann Wilhelm <johann.wilhelm@student.tugraz.at>
Cc: Oliver Neukum <oliver@neukum.org>, Rui Santos <rsantos@grupopie.com>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       preining@logic.at, kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Add the infamous Huawei E220 to option.c
Message-ID: <20071129185339.GA10445@singular.local>
References: <20071128161305.b01167b3.zaitcev@redhat.com> <200711291149.46326.oliver@neukum.org> <474E9D7E.4040007@grupopie.com> <200711291255.08603.oliver@neukum.org> <20071129150550.86453nubw8i5xi68@webmail.tugraz.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071129150550.86453nubw8i5xi68@webmail.tugraz.at>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El jue. 29 de nov. de 2007, a las 15:05:50 +0100, Johann Wilhelm escribió:
> If everything's working please also add code to also support the other E220 
> device... so both PID 0x1003 and 0x1004 should be treaded the same way...
>
> to test the device with the 0x1004-PID maybe Jaime Velasco 
> <jsagarribay@gmail.com> could be asked.. he initialy added the lines for 
> this device in option.c
>

The following patch works for me (on kernel 2.6.23).


diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a18659e..352c94c 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -158,8 +158,8 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel Merlin XS620/S640 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel Merlin S620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1120) }, /* Novatel Merlin EX720 */

> 73
>
> Zitat von Oliver Neukum <oliver@neukum.org>:
>
>> Am Donnerstag 29 November 2007 schrieb Rui Santos:
>>> >> Just to remember that that specific flag was one SET and, was removed,
>>> >> in part, because of what I state. Of course we aim at perfection but, if
>>> >> the benefits are only for a few situations and, will cause all this
>>> >> problems for all other, perhaps the reinsert of that flag would be a
>>> >> positive action.
>>> >>
>>> >
>>> > OK, can you provide "lsusb -v" for the device in the CD mode and in
>>> > the modem mode?
>>> >
>>> Of course. Heri it is.
>>
>> Thanks. Please try this patch.
>>
>> 	Regards
>> 		Oliver
>>
>> ----
>>
>> --- a/drivers/usb/serial/option.c	2007-11-29 12:35:09.000000000 +0100
>> +++ b/drivers/usb/serial/option.c	2007-11-29 12:47:34.000000000 +0100
>> @@ -158,7 +158,7 @@ static struct usb_device_id option_ids[]
>>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
>>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
>>  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
>> -	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
>> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 
>> 0xff, 0xff, 0xff) },
>>  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
>>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel Merlin 
>> XS620/S640 */
>>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel Merlin 
>> S620 */
>>
>>
>
