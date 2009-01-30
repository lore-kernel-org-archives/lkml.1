Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZA3II7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZA3II7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZA3IIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:08:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:28656 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZA3IIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=thJ8JnDQ3EiqlgBgbN15lTC1hbaPvhxrIxGHguOzSF8ghdMBip2YxkcEYY+gIAu4s8
         Pwo7tckDGmleef7WHyUp6+pN+PczcLuzdFV/f+ILzqJajWlAAvqvW3+5UXGX5fuYXyav
         sgU31YlAKUMogWZHCNJnVhOUMxe/VDxKJKNG8=
MIME-Version: 1.0
In-Reply-To: <74ae4f6a0901291405o6b615399vaa033abfbeac3a06@mail.gmail.com>
References: <74ae4f6a0901291402j19575c87g418bee66ba9f3519@mail.gmail.com>
	 <74ae4f6a0901291405o6b615399vaa033abfbeac3a06@mail.gmail.com>
Date: Fri, 30 Jan 2009 00:08:36 -0800
Message-ID: <86802c440901300008x7d2c465cne6c21e4c54e78c3b@mail.gmail.com>
Subject: Re: x86_64 IOAPIC
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: SUJIT V <sujit.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 2:05 PM, SUJIT V <sujit.linux@gmail.com> wrote:
> Forgot to mention that we are not using the irqbalance utility.
>
> So which part of the kernel io_apic code is doing the irq balancing
> which we see in /proc/interrupt.
>
> Thanks
>
>
> On Thu, Jan 29, 2009 at 2:02 PM, SUJIT V <sujit.linux@gmail.com> wrote:
>> Hi,
>>    We have a IBM Qauadcore 8 CPU system running x86_64 linux 2.6.23.
>> We were doing some performance test. (disk & network).
>> The eth0 IRQ is pinned to CPU0.  The aacraid interrupt has not been
>> assigned any smp affinity.
>>
>> On the system we see in (/proc/interrupts) that when the eth0
>> interrupt rate is high, the aacraid interrupt counter for CPU0 does
>> not increase as much compared to aacraid interrupts handled by other
>> CPUs .
>> This shows that IOAPIC is doing some load balancing.
>>
>> I wanted to check the code which is doing this load balancing. I
>> checked the file arch/x86_64/kernel/io_apic.c. I could not find any
>> irq balancing stuff out there.
>> I went through some archived discussions about the x86_64 ioapic irq
>> balancing. Most of the discussions were about using irqbalance
>> utility.
>>
>>
>> Could some one point me to the relevant piece of io_apic code ?

you are using logical flat mode. and target_cpus and smp_affinity are 0xff.
aka irq is broadcast to all cpus.

YH
