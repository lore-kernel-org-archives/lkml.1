Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0CIBUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:20:33 -0500
Received: from LION.seas.upenn.edu ([158.130.12.194]:42353 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab0CIBUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:20:31 -0500
Message-ID: <4B95A24D.2090903@seas.upenn.edu>
Date: Mon, 08 Mar 2010 20:20:13 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: mickib1@gmail.com
CC: jkosina@suse.cz, chatty@enac.fr, peterhuewe@gmx.de, micki@n-trig.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       rafi@seas.upenn.edu
Subject: Re: [PATCH 6/7] HID: N-trig MTM Driver fix And cleanup patch 6
References: <1268082827-2680-1-git-send-email-micki@n-trig.com> <1268082827-2680-2-git-send-email-micki@n-trig.com> <1268082827-2680-3-git-send-email-micki@n-trig.com> <1268082827-2680-4-git-send-email-micki@n-trig.com> <1268082827-2680-5-git-send-email-micki@n-trig.com> <1268082827-2680-6-git-send-email-micki@n-trig.com>
In-Reply-To: <1268082827-2680-6-git-send-email-micki@n-trig.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   static const struct hid_device_id ntrig_devices[] = {
>   	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN),
> -		.driver_data = NTRIG_DUPLICATE_USAGES },
> +		.driver_data = NTRIG_USB_DEVICE_ID },

The vendor and device id are in the first field "HID_USB_DEVICE", driver 
data is for flags, not id.  Its merely a coincidence that they are the 
same in this case.

The duplicate usages tells hid to let you have more than one "x" and "y" 
axis.  Otherwise each finger gets a new set (the second finger gets "z" 
and "rx" and so on).

>   static int __init ntrig_init(void)
>   {
> +	info("N-trig Driver Version 1.6\n");

Perhaps you mean:
MODULE_VERSION("1.06");
