Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYIYRHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYIYRHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYIYRHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:07:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:24916 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYIYRHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VkfUvCBITuW1NKh5spLYQ5ItvA76gtg6m5BG26xbx0tPIw2UrAzg3/jNKSnpDjU1N3
         8xJQhPIc4CE+PFi8JBkiVxfZyOSOmq00aHbf0X6brX9H9SODXskb4CQvqRg16O04bUk5
         PpIHIvWtpRp2OfWxBusdS/HWcmoCOLvvJEuyw=
Message-ID: <86802c440809251007n71738552n88b8ebfc7ecd017f@mail.gmail.com>
Date: Thu, 25 Sep 2008 10:07:17 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Len Brown" <lenb@kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <200809250900.24736.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
	 <200809250900.24736.bjorn.helgaas@hp.com>
X-Google-Sender-Auth: b10142263ac56c70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 8:00 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Thursday 25 September 2008 12:13:43 am Yinghai Lu wrote:
>> v2: fix hpet compiling
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> ---
>>  arch/x86/kernel/hpet.c    |    3 +++
>>  arch/x86/kernel/io_apic.c |    7 +++++++
>>  2 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
>> index 422c577..686505a 100644
>> --- a/arch/x86/kernel/hpet.c
>> +++ b/arch/x86/kernel/hpet.c
>> @@ -467,6 +467,9 @@ static int hpet_setup_irq(struct hpet_dev *dev)
>>       irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
>>       enable_irq(dev->irq);
>>
>> +     printk(KERN_DEBUG "hpet: %s is using irq %#x aka %d for MSI\n",
>> +                      dev->name, dev->irq, dev->irq);
>> +
>
> Why do we want to print the irq as hex?  Do we do that anywhere else?
> I think we should pick one format and stick with it, and I think
> decimal is the logical choice because it's the most common.

when sparseirq is enabled, irq for msi will be bus_nr/dev/func + 12bits.
so show it as hex is more straight. but we can not use hex in
/proc/interrupts --ABI want decimal.

just try to print out...in log, so user could get some idea that who
is using it...

YH
