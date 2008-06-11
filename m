Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYFKShW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYFKShW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbYFKShK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:37:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:43002 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbYFKShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Kq6JllJwXh0+2zd7OLIolKE7fT1zVPGbSH0Fs6/Kwz7U0EJyQM1X+fJY8wlul58KrV
         Apgi1hfWwdkr74yj2h7+pPZBl5uk+BwB/xKGLZ7O146Ra5xR7AZUZQp7Uqvov9LWFRhK
         ax9HFlGiygG/55JTRq5tsIO6rgxjib2XbQTMw=
Message-ID: <48501B0A.2020902@gmail.com>
Date: Wed, 11 Jun 2008 20:35:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com
Subject: Re: [PATCH 06/10] HID: move logitech report quirks
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com> <484D070E.9050707@gmail.com> <Pine.LNX.4.64.0806111611540.10085@jikos.suse.cz> <200806111739.24421.oliver@neukum.org>
In-Reply-To: <200806111739.24421.oliver@neukum.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2008 05:39 PM, Oliver Neukum wrote:
> Am Mittwoch 11 Juni 2008 16:13:43 schrieb Jiri Kosina:
>> On Mon, 9 Jun 2008, Jiri Slaby wrote:
>>
>>>>> static const struct hid_device_id hid_blacklist[] = {
>>>>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
>>>>> USB_DEVICE_ID_MX3000_RECEIVER) },
>>>>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER)
>>>>> },
>>>>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
>>>>> USB_DEVICE_ID_S510_RECEIVER_2) },
>>>>>  	{ }
>>>>>  };
>>>> This shouldn't be needed as soon as the userspace supports the proper module
>>>> autoloading, right?
>>> This is needed to tell generic drivers not to bind these, its' generic
>>> blacklist. I have no idea how this could be done better with current
>>> drivers/base/.
>> Hmm ... but if we make sure that the order in `modules.order' puts all the 
>> specialized drivers before the generic one, the binding should be done 
>> correctly even without blacklist, right?
> 
> No. You might have two devices connected. The first correctly triggers
> the loading of the generic driver. The second would first load the specialised
> driver but the already loaded driver will be faster.

Hm, the problem here is, that report (supported inputs et al.) parsing needs to 
be done some time. Since some devices have reports broken too, some of their 
reports need to be fixed before parsing. So the parsing is postponed after 
*first* driver binds, then it's checked if the coming driver has report_fixup 
hook and if yes, it's executed and the device is finally parsed and set up. If 
it has not (e.g. generic), it's just parsed and set up.

If you bind the generic driver as the first driver and the particular device 
needs report fixing, it never performs the fixup. Actually what I don't know is 
how to solve this effectively.
