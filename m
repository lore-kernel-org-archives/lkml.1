Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbYFNTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbYFNTkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 15:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYFNTkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 15:40:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55326 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbYFNTkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 15:40:04 -0400
Message-ID: <48541E7B.7020002@zytor.com>
Date: Sat, 14 Jun 2008 12:39:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup reloated_initrd
References: <200806132005.45836.yhlu.kernel@gmail.com>	 <200806132007.03576.yhlu.kernel@gmail.com>	 <485410E8.5050904@zytor.com> <86802c440806141227iab8ef42r413ce1aca241d997@mail.gmail.com>
In-Reply-To: <86802c440806141227iab8ef42r413ce1aca241d997@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>>
>>> Index: linux-2.6/arch/x86/kernel/setup_32.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/setup_32.c
>>> +++ linux-2.6/arch/x86/kernel/setup_32.c
>>> @@ -585,6 +585,9 @@ static void __init relocate_initrd(void)
>>>        printk(KERN_INFO "Copied RAMDISK from %016llx - %016llx to %08llx -
>>> %08llx\n",
>>>                ramdisk_image, ramdisk_image + ramdisk_size - 1,
>>>                ramdisk_here, ramdisk_here + ramdisk_size - 1);
>>> +
>>> +       /* need to free that, otherwise init highmem will reserve it again
>>> */
>>> +       free_early(ramdisk_image, ramdisk_image+ramdisk_size);
>>>  }
>>>
>> I'm somewhat confused by this... you realize that the old location and the
>> new location of the initrd will overlap, right?
> 
> Ying Huang add page_is_reserved_early check in
> add_one_highpage_init(), so reserve_early high address will be
> reserved when in init high. that is not wanted old initrd in high
> region we will lose some ram
> 

Yes, but I think the above will free part of the active area if the 
areas overlap.

	-hpa
