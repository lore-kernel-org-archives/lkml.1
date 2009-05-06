Return-Path: <linux-kernel-owner+w=401wt.eu-S1761789AbZEFVBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789AbZEFVBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760822AbZEFVBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:01:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:23027 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760327AbZEFVBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=peRlFrBy/oT7pyq2VxboxKajS+oGPeKDYKiWEitgvO6ljxzPPJj+0WrVt7unXHsTGG
         CVi3WzTCiFnOot+5q1e5HBoNEu+UlD66K+R+AYSRWUFoTW6BuHtCe0CsJdFwZupd8GM5
         jogIqhd2zDgeBynFQxypM40ANU2p9/sqrWyVM=
MIME-Version: 1.0
In-Reply-To: <20090506145832.GE3478@suse.de>
References: <2e609cef0905060747m281c15e8ybc8e20f9d4993178@mail.gmail.com>
	 <20090506145832.GE3478@suse.de>
Date: Thu, 7 May 2009 05:01:22 +0800
Message-ID: <2e609cef0905061401n2412c448k755a152917f4b9d6@mail.gmail.com>
Subject: Re: [PATCH] Yet another Conexant Clone to add to cdc-acm.c
From: =?UTF-8?B?WzZdW01lZSBFd11bzrxdICEhISAtLSBYS0ogfHwgbWluZGxlc3MgOkQ=?= 
	<xiaokj@gmail.com>
To: Greg KH <gregkh@suse.de>, Oliver Neukum <oliver@neukum.name>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/6 Greg KH <gregkh@suse.de>:
> On Wed, May 06, 2009 at 10:47:14PM +0800, [6][Mee Ew][μ] !!! -- XKJ || mindless :D wrote:
>> Dear Mighty Ones,
>>
>> Please be gentle with me. This is my first time...
>>
>> Shiro / Aztech (Singapore) has completely cloned the Conexant USB
>> MODEM RD02-D400 and called it their UM-3100.
>> With the errors, of course.
>>
>> I am trying my best to follow procedures here (as google tells,
>> though), so if I am not right, please feel free to hurl insults back
>> to this mailbox.
>
> Minor thing to change, we need a "Signed-off-by:" line, as per the
> instructions in the file Documentation/SubmittingPatches.
>
> Care to add that to the patch description and resend the whole thing so
> that we can apply it?
>
> thanks,
>
> greg k-h

Understood. I have added you again, this time, because Mr Oliver
Neukum's email bounced on me the last time.

This patch adds another quirky Conexant USB Modem Clone to usb cdc-acm.c

This is to be applied to latest git. (Got off the website...)

Signed-off-by: Xiao Kaijian <xiaokj@gmail.com>

--- a/drivers/usb/class/cdc-acm.c       2009-05-06 22:06:27.556488116 +0800
+++ b/drivers/usb/class/cdc-acm.c       2009-05-06 22:12:56.648401202 +0800
@@ -1375,6 +1375,13 @@ static struct usb_device_id acm_ids[] = {
       { USB_DEVICE(0x0572, 0x1324), /* Conexant USB MODEM RD02-D400 */
       .driver_info = NO_UNION_NORMAL, /* has no union descriptor */
       },
+       { USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
+        .driver_info = NO_UNION_NORMAL, /* has no union descriptor.
+                                          This is basically a clone of
+                                          Conexant USB MODEM RD02-D400.
+                                          Seems like NO_UNION_ _IS_ becoming
+                                          NORMAL... */
+        },
       { USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
       },
       { USB_DEVICE(0x0572, 0x1329), /* Hummingbird huc56s (Conexant) */
