Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbZDIGrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbZDIGrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZDIGqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:46:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:53978 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZDIGqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:46:49 -0400
Message-ID: <49DD99CD.4090201@gawab.com>
Date: Wed, 08 Apr 2009 23:46:37 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-usb@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.30-rc1: OOPS on usb disk insert
References: <49DC3094.5010607@gawab.com> <20090407223828.c9d2cb75.akpm@linux-foundation.org> 	<49DC3F1F.9040306@gawab.com> <ac3eb2510904080625m228ddc4dl611c3c5c368fab2a@mail.gmail.com>
In-Reply-To: <ac3eb2510904080625m228ddc4dl611c3c5c368fab2a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Tue, Apr 7, 2009 at 23:07, Justin Madru <jdm64@gawab.com> wrote:
>   
>> Andrew Morton wrote:
>>     
>>> On Tue, 07 Apr 2009 22:05:24 -0700 Justin Madru <jdm64@gawab.com> wrote:
>>>       
>
>   
>>>> Testing out .30-rc1 and usb devises don't work. I insert my flash disk
>>>> and get this oops.
>>>>         
>
>   
>>> The trace appears to be claiming that kernel/async.c:async_new.func is
>>> NULL.
>>>
>>> But it cannot be - it's initialised at compilation time.  Unless
>>> something scribbled on it of course.
>>>       
>
> I've seen async problems with other subsystem too, maybe caused by a
> corruption which is fixed by:
>   http://patchwork.kernel.org/patch/16776/
>
>   -static void __init acpi_battery_init_async(void *unused, ...
>   +static void acpi_battery_init_async(void *unused, ...
>
> Kay
>
>   
I've applied the following patches (to try to fix other bugs) and I no 
longer get a BUG/OOPS
although the patches might have not been the cause of the fix, but 
inserting the disk still doesn't works.

http://patchwork.kernel.org/patch/17199/
http://patchwork.kernel.org/patch/17025/
http://patchwork.kernel.org/patch/17039/

It now complains of: FAT: IO charset cp437 not found
Which I've found a work around by:

<insert flash disk>
syslog complains: FAT: IO charset cp437 not found
sudo modprobe -r nls_cp437
sudo modprobe -i nls_cp437
<remove then reinsert flash disk>
syslog complains: FAT: IO charset iso8859_1 not found
sudo modprobe -r nls_iso8859_1
sudo modprobe -i nls_iso8859_1
<insert flash disk>
profit!!

So, I have to insert the disk 3 times before it works. although after 
that it just works, until I reboot and I have to repeat the unload/load 
modules.

Justin Madru

