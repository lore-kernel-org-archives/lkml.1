Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbYHHWbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbYHHWbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764748AbYHHWaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:30:39 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:1805 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764695AbYHHWah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S9t1lUQpN9U/XnotyegrZ3zREd2pGb/Z5MG7+bCvrWO7rtY1n4fMK8kFRdcpQwSymK
         igv43CyOTFaDYEqp91pVwxWbKSQFQcgzD/+trj/qS6f2UksAfvof2dDY5gM9nQQvPOwx
         1U/fnzEFOhnPZsNPGoXRLejjCAb91e4I8uKh0=
Message-ID: <86802c440808081530o6c07c3bbl1a52f7a267dc2936@mail.gmail.com>
Date: Fri, 8 Aug 2008 15:30:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/42] dyn_array/nr_irqs/sparse_irq support v5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <489CC7E2.7040209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	 <489CC246.5000202@zytor.com>
	 <86802c440808081514w3a7ea1d6hda2442e7bf6729a4@mail.gmail.com>
	 <489CC7E2.7040209@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 3:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>>>
>>> So I'm still clearly missing something about this... if we need sparse
>>> IRQs
>>> in the first place (which we do), what's the point of the dyn_array?
>>
>> x86_64: support CONFIG_HAVE_SPARSE_IRQ and CONFIG_DYN_ARRAY
>> x86_32: support CONFIG_DYN_ARRAY
>>
>> some arches could use dyn_array with probing nr_irqs and it could be
>> 32 and much less than 224.
>> some could have that like 512. and those arch may not need to mess up
>> with sparse_irq at first point.
>> but still could get some flexibilty about that array size.
>>
>
> As an x86 maintainer, I definitely do not want x86-64 and x86-32 to diverge
> unless there is an extremely strong reason to.
>
> Other architectures may speak for themselves, but why not just support
> sparse IRQs on x86-32 *and* -64 and skip the dyn_array variant?

after we merged io_apic_32.c into io_apic_64.c.
also I want to kill irq balance in io_apic_32.c, but no one say
anything about it.

also dyn_array could have other user in addition to nr_irqs.
i will dig it out like NR_CPUS/nr_cpu_ids related array. and Mike
tried to put every thing to PER_CPU instead of array, maybe some case
array would be effient than that. that make dyn_array some usage.

YH
