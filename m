Return-Path: <linux-kernel-owner+w=401wt.eu-S935043AbXEWPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043AbXEWPSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762988AbXEWPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:18:23 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:42914 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762012AbXEWPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:18:22 -0400
Message-ID: <46545B3C.9070901@free.fr>
Date: Wed, 23 May 2007 17:18:20 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Dumping the checksums in a module
References: <464DC019.6010008@free.fr> <Pine.LNX.4.61.0705182225450.9015@yvahk01.tjqt.qr> <4652A635.8070507@free.fr> <Pine.LNX.4.61.0705222149160.4452@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705222149160.4452@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 22 2007 10:13, John Sigler wrote:
>>>> How do I list the checksums within a module?
>>>> Is there a simpler way to list all the checksums?
>>> 22:25 ichi:~ > modinfo aes
>>> srcversion:     8CB82B3A254D5A950FD0D14
>>>
>>> I think this one checksum is computed out of all functions that
>>> the module uses.
>> You've enabled MODULE_SRCVERSION_ALL which adds a checksum computed from the
>> source files used to build a given module. What I want is to list ALL the
>> checksums of the symbols included inside a given module.
>>
>> e.g. for the kernel:
> 
> for i in `nm 
> /lib/modules/2.6.18.8-ccj45-default/kernel/block/as-iosched.ko |
> grep " U " | cut -b 20-`; do
>     grep '\b'"$i"'\b' Module.symvers;
> done;
> 
> (for 32-bit, use `cut -b 12-`)

I think you didn't understand my request.

I have a *binary* kernel module that was compiled with 
CONFIG_MODVERSIONS enabled.

Thus, that binary module includes 32-bit (?) checksums for several 
kernel functions AND kernel structures.

cf. my original post:

$ hexdump -C test.ko | grep -A2 struct_
000752e0  17 98 07 0e 73 74 72 75  63 74 5f 6d 6f 64 75 6c 
|....struct_modul|
000752f0  65 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|e...............|
00075300  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|

For example, the checksum for "struct_module" seems to be 0x1798070e.

Is there a tool (from linux-module-init-tools?) to list all the 
checksums included in a binary module.

Regards.
