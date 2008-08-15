Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYHOGlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYHOGlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 02:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYHOGlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 02:41:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48142 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYHOGlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 02:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pHnJhHp6Nd1rfRkPKqEMrNL/VPy3QDAEMGQxt8AENpX8+ZVdmIGyT5IAut8/993g97
         L86nWe10VSpk3oSR2mnaLiym79B6fdso8FMwJKc3pJOlIb+uGKg+TiV3j42i9jUms9fX
         HPtp6kAGAAJSIqHD9RsdSRk9RYx1cn3BuIOsM=
Message-ID: <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com>
Date: Fri, 15 Aug 2008 10:41:03 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080814183428.550709025@gmail.com>
	 <20080814184652.475361864@gmail.com>
	 <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 11:44 PM, Maciej W. Rozycki
<macro@linux-mips.org> wrote:
> On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:
>
>> @@ -962,7 +962,8 @@ void __init init_bsp_APIC(void)
>>        */
>>       apic_write(APIC_LVT0, APIC_DM_EXTINT);
>>       value = APIC_DM_NMI;
>> -     if (!lapic_is_integrated())             /* 82489DX */
>> +     /* discrete on 82489DX */
>> +     if (!lapic_is_integrated())
>>               value |= APIC_LVT_LEVEL_TRIGGER;
>>       apic_write(APIC_LVT1, value);
>>  }
>
>  Please elaborate.
>
>  Maciej
>

Hi Maciej,

don't really understand what do you mean. Do you mean it should
be a separate patch for this code snippet? Actually since we
always have lapic integrated on 64bit cpu gcc will eliminate
this check.

Cyrill
