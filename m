Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZGUVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZGUVjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZGUVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:39:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:6413 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbZGUVjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=F4Ael4nclYDfqs6bu1MCd/1GQVJoDrvsUWjuG+DuVBjwyMhYcfgkppnJQhdz5Vf410
         Gt1L4Z/N3/mqIZruCuhfHT2Dlfe0F7ywKAsYz9sgq2SMfFgaSpe+MjJSUADsbof80WEd
         +WQ2aNNKirJIDovJGOtU6N2XJC7aXblZIS1eQ=
Message-ID: <4A66357E.1080200@gmail.com>
Date: Tue, 21 Jul 2009 23:39:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
CC: Linux USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Blacklisting a usbhid device
References: <d1351198778762a135751934d1977539.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <d1351198778762a135751934d1977539.squirrel@intranet.cs.nmsu.edu>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 10:40 PM, Rick L. Vinyard, Jr. wrote:
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -63,6 +63,7 @@ static const struct hid_blacklist {
> 
>  	{ USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS,
> HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_WISEGROUP_LTD2, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS,
> HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
> +	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G13, 0x00000004 },
> 
>  	{ 0, 0 }
>  };

It's too late for driver base to not bind the device with usbhid. Use
hid_ignore_list in drivers/hid/hid-core.c instead. This list contains
rather quirks.
