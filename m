Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYFNWIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYFNWIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 18:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYFNWIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 18:08:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:5423 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbYFNWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 18:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Va/LhbGv3023KtrX0qPWPySSH7mWGPgdINcnzxGuhW8wC/fe0GbwPvwsd2p6Zi9vAX
         SJ9mh1q4VImUfAd2QKZub8NIH6FG7+yV+giyQSSbwq4mziebU9fo5vA5Q3ZmhNbQrYP9
         yMog8waN4vhpag/U1j/pllgCwCAUNDFevD/Ks=
Message-ID: <86802c440806141508i542cc69fy964250b9f226865b@mail.gmail.com>
Date: Sat, 14 Jun 2008 15:08:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: cleanup reloated_initrd
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <48541E7B.7020002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806132005.45836.yhlu.kernel@gmail.com>
	 <200806132007.03576.yhlu.kernel@gmail.com>
	 <485410E8.5050904@zytor.com>
	 <86802c440806141227iab8ef42r413ce1aca241d997@mail.gmail.com>
	 <48541E7B.7020002@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 12:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>>>
>>>> Index: linux-2.6/arch/x86/kernel/setup_32.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/arch/x86/kernel/setup_32.c
>>>> +++ linux-2.6/arch/x86/kernel/setup_32.c
>>>> @@ -585,6 +585,9 @@ static void __init relocate_initrd(void)
>>>>       printk(KERN_INFO "Copied RAMDISK from %016llx - %016llx to %08llx
>>>> -
>>>> %08llx\n",
>>>>               ramdisk_image, ramdisk_image + ramdisk_size - 1,
>>>>               ramdisk_here, ramdisk_here + ramdisk_size - 1);
>>>> +
>>>> +       /* need to free that, otherwise init highmem will reserve it
>>>> again
>>>> */
>>>> +       free_early(ramdisk_image, ramdisk_image+ramdisk_size);
>>>>  }
>>>>
>>> I'm somewhat confused by this... you realize that the old location and
>>> the
>>> new location of the initrd will overlap, right?
>>
>> Ying Huang add page_is_reserved_early check in
>> add_one_highpage_init(), so reserve_early high address will be
>> reserved when in init high. that is not wanted old initrd in high
>> region we will lose some ram
>>
>
> Yes, but I think the above will free part of the active area if the areas
> overlap.

overlap parts below max_low_pfn is freed with free_bootmem

and free_early only remove that entry in early_res array. and at that
time, we already called
early_res_to_bootmem.

so it is safe.

YH
