Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYFNT1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYFNT1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 15:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYFNT1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 15:27:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:61193 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYFNT1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 15:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZmSlDI83prF4eFeL/xLZQrSsR+hF3scwFc+RLZzgedi+VAr5QpcHmT57EmHHVFB2u7
         nMPQbeqNWTygwF2Czz1sLTjC2fKCE4RpeuCRCriyS5lnOdyfnyVIK4Cc1trnhyv28M1u
         1g/iGLo64yFzfjEogxkk4bONSgiyfbYV1L7l8=
Message-ID: <86802c440806141227iab8ef42r413ce1aca241d997@mail.gmail.com>
Date: Sat, 14 Jun 2008 12:27:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: cleanup reloated_initrd
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <485410E8.5050904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806132005.45836.yhlu.kernel@gmail.com>
	 <200806132007.03576.yhlu.kernel@gmail.com>
	 <485410E8.5050904@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 11:41 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> 1. move that before zone_sizes_init ...
>> 2. add free_early for one old one, otherwise it will be be reserved again
>> when
>>   init highmem.
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> Index: linux-2.6/arch/x86/kernel/setup_32.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/setup_32.c
>> +++ linux-2.6/arch/x86/kernel/setup_32.c
>> @@ -585,6 +585,9 @@ static void __init relocate_initrd(void)
>>        printk(KERN_INFO "Copied RAMDISK from %016llx - %016llx to %08llx -
>> %08llx\n",
>>                ramdisk_image, ramdisk_image + ramdisk_size - 1,
>>                ramdisk_here, ramdisk_here + ramdisk_size - 1);
>> +
>> +       /* need to free that, otherwise init highmem will reserve it again
>> */
>> +       free_early(ramdisk_image, ramdisk_image+ramdisk_size);
>>  }
>>
>
> I'm somewhat confused by this... you realize that the old location and the
> new location of the initrd will overlap, right?

Ying Huang add page_is_reserved_early check in
add_one_highpage_init(), so reserve_early high address will be
reserved when in init high. that is not wanted old initrd in high
region we will lose some ram

Also I have produced another patch to make init high to use
early_node_map aka active regions. and will sort it out.

anyway, remove that from early_res is some cleanup.

YH
