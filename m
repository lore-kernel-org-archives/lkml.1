Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZETIDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZETIDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZETIDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:03:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:13659 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZETIDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VOrZs0iM60Ome8O7pSt5rvuy7ytuGK/YDJVpYOIrWEgYktIjyNKWTza36KJZWF/fVQ
         lvCEKlBB31hdk0DHZ2eQLWnbdHySUxuyrdhAhY7P/htfpJbXaAoy7fZkmMDoGQFbFhGN
         LfDtyjXSD5DGcKy4iYH26v7jPQPGPu55feKEc=
MIME-Version: 1.0
In-Reply-To: <20090520075829.GD23959@elte.hu>
References: <4A1393CD.7080604@kernel.org> <20090520075829.GD23959@elte.hu>
Date: Wed, 20 May 2009 01:03:14 -0700
Message-ID: <86802c440905200103o5905e997weec5da0fd0a86c41@mail.gmail.com>
Subject: Re: [PATCH] x86: don't map io_apic two times.
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 12:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> mp_register_ioapic() already map it.
>>
>> [ Impact: don't map io apic address again ]
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/apic/io_apic.c |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
>> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
>> @@ -4162,7 +4162,12 @@ fake_ioapic_page:
>>                               alloc_bootmem_pages(PAGE_SIZE);
>>                       ioapic_phys = __pa(ioapic_phys);
>>               }
>> -             set_fixmap_nocache(idx, ioapic_phys);
>> +             /*
>> +              * when acpi ioapic is used, mp_register_ioapic() map
>> +              * ioapic_phys already
>> +              */
>> +             if (!acpi_ioapic)
>> +                     set_fixmap_nocache(idx, ioapic_phys);
>
> The change is correct, but i'm not sure we want to do this - the
> acpi_ioapic flag might change its meaning (and then break this code
> subtly) and this is bootup code so doing the mapping twice should be
> no issue.
>
> If it were some expensive initialization i'd agree, but here it's
> really just a couple of instructions and an INVLPG.
>
> Hm?

ok, please drop it.

YH
