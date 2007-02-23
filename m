Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbXBWPRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbXBWPRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932591AbXBWPRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:17:23 -0500
Received: from mail.syneticon.net ([213.239.212.131]:60662 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563AbXBWPRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:17:22 -0500
Message-ID: <45DF056C.2010806@wpkg.org>
Date: Fri, 23 Feb 2007 16:17:00 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Walrond <andrew@walrond.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: (Sparc64) 2.6.20 seems to ignore initramfs
References: <200702231108.10185.andrew@walrond.org> <45DEECEE.6070108@wpkg.org> <200702231446.20929.andrew@walrond.org>
In-Reply-To: <200702231446.20929.andrew@walrond.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Walrond schrieb:
> On Friday 23 February 2007 13:32, Tomasz Chmielewski wrote:
>> Andrew Walrond schrieb:
>>> On a Sun T1000 I am trying to boot 2.6.20 using initramfs. (I use the
>>> same procedure successfully on x86_64 and itanium2 servers).
>>>
>>> The relevent silo section looks like this:
>>>
>>> image=/boot/2.6.20.image
>>>         label=2.6.20
>>>         initrd=/boot/2.6.20.initramfs
>>>         partition=2
>>>         read-only
>>>
>>> The kernel loads and boots and I see
>> (...)
>>
>>> So it knows about the initramfs, but then tries to mount a root
>>> filesystem instead...
>>>
>>> I haven't tried this (initramfs)  with earlier kernels, so I don't know
>>> whether this is a regression. Any clues about how to solve this would be
>>> greatly appreciated.
>> Does it make a difference if you embed initramfs directly in the kernel?
>>
>> CONFIG_INITRAMFS_SOURCE="/path/to/your/initramfs/directory"
> 
> Hi Tomasz. I can't tell; The combined kernel+initramfs is bigger than the 8Mb 
> silo allocates for the kernel, and it does this:
> 
> 	boot: chunky
> 	Allocated 8 Megs of memory at 0x40000000 for kernel
> 	/
> 	Fatal error: Image too large to fit in destination
> 	
> 	Fatal error: Image too large to fit in destination
> 	
> 	Error loading /boot/chunky
> 	
> 	Image not found.... try again
> 
> 
> I don't see any silo config options to increase this value in the docs.
> 
> Good idea though :)

Try to decrease the initramfs size just to know if it boots correctly.

I.e., put just a sh/bash/ash/dash binary there (probably /dev/console 
node, too), executed in init.

Then, try to start the kernel with initramfs embedded in the kernel, 
then as initrd etc. - this will show if the fault is on your side, or 
kernel's.


-- 
Tomasz Chmielewski
http://wpkg.org
