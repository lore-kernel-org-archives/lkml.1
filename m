Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYHSBgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYHSBgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYHSBgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:36:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:53903 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYHSBgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nYD798r399VbYjZi2S2sz/COGof2l7AvD1oa3rx7J0YX2LWs0khm8vKPkqjFDl4Ali
         zgNdeGNOi4HH+iJol3Rp+ukZvDrrTeJewmXw4C8w8ekaF3vxeG2ZKdFcqk+HEr8188FO
         NuHIlKa8KLCjmGwEjeVAWXciRZ7+WJWp4wHNM=
Message-ID: <86802c440808181836v7e1f12dbrf059c1be23f155dd@mail.gmail.com>
Date: Mon, 18 Aug 2008 18:36:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alok Kataria" <akataria@vmware.com>
Subject: Re: [PATCH 1/2] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'
Cc: "Alex Nixon" <alex.nixon@citrix.com>, "Ingo Molnar" <mingo@elte.hu>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48A9EBBD.5010509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A976E6.40906@citrix.com> <48A9EBBD.5010509@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 2:38 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Alex Nixon wrote:
>> From: Alex Nixon <alex.nixon@citrix.com>
>> Date: Mon, 18 Aug 2008 12:56:48 +0100
>> Subject: [PATCH] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'
>>
>> Following commit 9c3f2468d8339866d9ef6a25aae31a8909c6be0d, do_IRQ() looks up the IRQ number in the per-cpu variable vector_irq.
>>
>> This commit makes Xen initialise an identity vector_irq map for both X86_32 and X86_64.
>>
>
> Thanks Alex.
>
> Ingo, please apply.
>
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
>> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
>> ---
>>  arch/x86/xen/irq.c |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
>> index 28b85ab..bb04260 100644
>> --- a/arch/x86/xen/irq.c
>> +++ b/arch/x86/xen/irq.c
>> @@ -21,7 +21,6 @@ void xen_force_evtchn_callback(void)
>>
>>  static void __init __xen_init_IRQ(void)
>>  {
>> -#ifdef CONFIG_X86_64
>>       int i;
>>
>>       /* Create identity vector->irq map */
>> @@ -31,7 +30,6 @@ static void __init __xen_init_IRQ(void)
>>               for_each_possible_cpu(cpu)
>>                       per_cpu(vector_irq, cpu)[i] = i;
>>       }
>> -#endif       /* CONFIG_X86_64 */
>>
>>       xen_init_IRQ();
>>  }
>>


Rusty,
can you check tip/master with lguest?  wonder you need to do sth for lguest too.
we are making 32 bit support per_cpu vector like 64 bit

also alok, can you check vmi etc...

Thanks

Yinghai Lu
