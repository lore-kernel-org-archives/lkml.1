Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYKUTJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYKUTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbYKUTJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:09:20 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:15187 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYKUTJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=G4tEeABgdQdt2ObNgtFszYulbJq3XrmhMVtKWlg1B1ufdURet4aqsznwI3P+kYJa16
         t4UKfqI0CJazga2YQHdMSUq7g59Tr+8EghD0w8lP2QUt04vIZ1PcTKodQGauCTKDbPWb
         T6ye9zetSAd72UrFLcxmhz3SsQTJM3ZaNJUq4=
Message-ID: <86802c440811211109l64a8a073n9515f1e17721114e@mail.gmail.com>
Date: Fri, 21 Nov 2008 11:09:18 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2 v3] SGI RTC: add generic timer system interrupt
Cc: "Dimitri Sivanich" <sivanich@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <4926FD58.7000406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023163041.GA14574@sgi.com> <20081119212202.GA3377@sgi.com>
	 <20081119212350.GB3377@sgi.com> <20081119212631.GC3377@sgi.com>
	 <20081120151208.f7892050.akpm@linux-foundation.org>
	 <4925F095.40107@zytor.com> <20081121171537.GA12370@sgi.com>
	 <4926FD58.7000406@zytor.com>
X-Google-Sender-Auth: 3f86506c91493a31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 10:26 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Dimitri Sivanich wrote:
>>
>> There are basically two issues with using 'normal IRQs' in cases like this:
>>
>> - Using normal IRQs would mean we would have an IRQ per cpu.  The current
>>   hard coded maximum, NR_IRQS, is 4352 (NR_VECTORS + (32 * MAX_IO_APICS)).
>>   On machines with large numbers of cpus and an irq per cpu for each desired
>>   interrupt, that's a lot of IRQs.  In addition, the GRU, will need 2 such
>>   IRQs per cpu.  On 4096 cpu systems, you've already used up more than the
>>   limit just for that.  Until some sort of infrastructure change takes place
>>   that would potentially allow this to be dynamically increased, such as
>>   Yinghai Lu's "sparse_irq aka dyn_irq v14" patch, this problem will exist.
>>
>>   Furthermore, the actual runtime limit, nr_irqs, is set to 96 by
>>   probe_nr_irqs for our configuration.  This is because that code assumes all
>>   vectors are io-apic vectors, not cpu centric vectors like the ones I'm
>>   talking about.  With the current, scheme, even on a 128 cpu system, I'm out
>>   of IRQs immediately.
>>
>> - The current infrastructure for requesting vector/IRQ combinations doesn't
>>   allow one to request an interrupt priority higher than i/o device interrupt
>>   priorities.  Clock event (high resolution timer) code should run at higher
>>   interrupt priority.
>
> Okay, so it is a hack pending us taking care of issues in the current
> code.  #1 we're obviously working on, #2 I need to think some more about
> but shouldn't be too hard to fix -- if real, it also affects other
> interrupt-driven clock sources.

should just remove probe_nr_irqs.

YH
