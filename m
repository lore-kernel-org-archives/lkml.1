Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYEaA4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYEaA4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYEaA42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:56:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:37369 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbYEaA4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vq+GNZvtm1h2mKUeWknOSJKKyG359mHtzBTqmMle0glqsUPhyh63I4ueJkmtAizyZiBEQrk5hl3dqXSXL9Idw48BRASK76AaAGA1YX2ilocYtkdz29m5YOeQyH4GNMUGU3FNSz+2ySwwRD3liEr0XH8IUk566nVfbJJ3kxcfTRQ=
Message-ID: <86802c440805301756m65bd717bxc973d77b3c585735@mail.gmail.com>
Date: Fri, 30 May 2008 17:56:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Kevin Winchester" <kjwinchester@gmail.com>
Subject: Re: [PATCH] x86: fix pointer type warning in arch/x86/mm/init_64.c:early_memtest
Cc: "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <48409D2D.4020207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212106475-3297-1-git-send-email-kjwinchester@gmail.com>
	 <48409D2D.4020207@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 5:34 PM, Kevin Winchester
<kjwinchester@gmail.com> wrote:
> Kevin Winchester wrote:
>>
>> Changed the call to find_e820_area_size to pass u64 instead of unsigned
>> long.
>>
>> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
>> ---
>>  arch/x86/mm/init_64.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 83ab7f9..94f73c2 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -515,7 +515,7 @@ early_param("memtest", parse_memtest);
>>   static void __init early_memtest(unsigned long start, unsigned long end)
>>  {
>> -       unsigned long t_start, t_size;
>> +       u64 t_start, t_size;
>>        unsigned pattern;
>>          if (!memtest_pattern)
>> @@ -534,7 +534,7 @@ static void __init early_memtest(unsigned long start,
>> unsigned long end)
>>                        if (t_start + t_size > end)
>>                                t_size = end - t_start;
>>  -                       printk(KERN_CONT "\n  %016lx - %016lx pattern
>> %d",
>> +                       printk(KERN_CONT "\n  %016llx - %016llx pattern
>> %d",
>>                                t_start, t_start + t_size, pattern);
>>                          memtest(t_start, t_size, pattern);
>
> I still see this warning on next-20080530 - so I expanded the CC list a
> little.  Did I do this patch right?

i had one in local too.

Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
