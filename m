Return-Path: <linux-kernel-owner+w=401wt.eu-S1760314AbZANVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314AbZANVib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZANViX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:38:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:12159 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbZANViV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:38:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=oTRswYP6gtmXK2/S/XIjZ59XzIGnLIr9BS+c07uFxsGYaf32MHq6S5ukf9V9Y5Q4uL
         QoXbqvNAjmrQm33Ia15wvMMZt3u196NGY+/a4i9yKIXRKeIqndKqr+qb9ltyZhKDWo4l
         6T2OBoFbBtMJHp95X8ME0ZVtUW1WQ3WaIn9+c=
Message-ID: <86802c440901141338m78233d09y99d79be98eea4cba@mail.gmail.com>
Date: Wed, 14 Jan 2009 13:38:20 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: make 32bit MAX_HARDIRQSS_PER_CPU to be NR_VECTORS
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114111755.GN2913@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496B9FF3.3080909@kernel.org> <20090114111755.GN2913@elte.hu>
X-Google-Sender-Auth: 56c7a7a7b3dd4342
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 3:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Impact: clean up to be same as 64bit
>>
>> 32bit is use per-cpu vector too, so don't use default NR_IRQS
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/include/asm/hardirq_32.h  |    3 +++
>>  arch/x86/include/asm/irq_vectors.h |    4 ++--
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/hardirq_32.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/hardirq_32.h
>> +++ linux-2.6/arch/x86/include/asm/hardirq_32.h
>> @@ -20,6 +20,9 @@ typedef struct {
>>
>>  DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
>>
>> +/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
>> +#define MAX_HARDIRQS_PER_CPU NR_VECTORS
>> +
>>  #define __ARCH_IRQ_STAT
>>  #define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
>
> applied to tip/x86/cleanups. Btw., isnt the irq_vectors.h bit (mentioned
> in the diffstat) missing?
>

copy and modify the patch
forget to do quilt refresh --diffstat

YH
