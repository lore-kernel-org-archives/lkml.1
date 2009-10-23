Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZJWU5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZJWU5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZJWU5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:57:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:48663 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZJWU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:57:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RyG1QRjpjY86A7a5wMO8esglEUgJlBkD5JOHrD4CNKjst+3VIpUAd6IAWGtRs4uj+n
         7r2EfLctiBQc+2Is4NF0cYsLpUsUz9djT8huperQUHWeOiYHRRUd5M4FQwDh7+FZ4fUa
         z+WyqbGPLK5e/1rQvmfEiS6x09zhDnHiyiSpo=
Message-ID: <4AE218A5.5070008@gmail.com>
Date: Sat, 24 Oct 2009 00:57:09 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ike Panhc <ike.pan@canonical.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexandre Rostovtsev <tetromino@gmail.com>,
       Corentin CHARY <corentincj@iksaif.net>
Subject: Re: [Resend] [PATCH] ACPI: New driver for Lenovo SL laptops
References: <1253805163-12493-1-git-send-email-ike.pan@canonical.com> <1256325108-22626-1-git-send-email-ike.pan@canonical.com> <4AE20560.5020908@gmail.com> <4AE20AA2.2090201@canonical.com>
In-Reply-To: <4AE20AA2.2090201@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ike,

I'm sorry to say this, bit it looks like your design is seriously 
flowed. Not any ACPI device should
require interception of EC query events.

You should register device for HID "ATK0101" and get all notifications 
there, as it is done for
for ASUS ATK0100 hot key driver (drivers/platform/x86/asus-laptop.c), 
and I would guess,
that driver for ASUS ATK0101 hot key driver may be either an extension 
to ATK0100 driver
or based on it, if new device does not share any events.
This would be real solution, and not a hack for a single notebook/BIOS 
version.
 From the DSDT it is obvious that _Q numbers are not permanent and could 
change even
with the next BIOS revision.

You may also contact current maintainer of asus-laptop driver, Corentin 
Chary, as he might help you with design.

Regards,
Alex.

Ike Panhc пишет:
> Hi Alex,
>
> The attachment is the acpidump.
>
> I register for EC query events because it is an event source of hotkey
> press
>
> Alexey Starikovskiy wrote:
>   
>> Hi,
>>
>> Could you please post acpidump from this machine, I would like to
>> understand,
>> why you need to register for EC query events.
>>
>> Thanks,
>> Alex.
>>
>>     
>
>   

