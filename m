Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYIHFH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYIHFH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 01:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYIHFHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 01:07:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:5242 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYIHFHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 01:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FVeCT94xcyjMTbnIanlp2Jt2hnOOL8DEHyVSziTv/+gGyxAMiIwy2SDfEhCKS4eO2R
         WpECHlX8mCELJltqlsIeKy4/c1xKJjlFg1Seb/WoSl7zk8xXQ5t3F5zJ5J76SmUj6Hou
         9d6G6r/iNjtMqvubG9+i2RNtRn3G6caXnTplE=
Message-ID: <86802c440809072207l74a4f51cxee7df32a392ad48d@mail.gmail.com>
Date: Sun, 7 Sep 2008 22:07:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for setup_IO_APIC_irqs
Cc: "Ingo Molnar" <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, macro@linux-mips.org
In-Reply-To: <86802c440809072138u19ac9beax183d4e69c3a895ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080904183748.950151853@gmail.com>
	 <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu>
	 <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu>
	 <20080906101533.GA7273@lenovo> <20080906131217.GA4910@elte.hu>
	 <86802c440809071724i35a1e26frb01c401bee693ad@mail.gmail.com>
	 <aa79d98a0809072120y388ecd17vf461c98dd788f983@mail.gmail.com>
	 <86802c440809072138u19ac9beax183d4e69c3a895ee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 9:38 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sun, Sep 7, 2008 at 9:20 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On Mon, Sep 8, 2008 at 4:24 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>> On Sat, Sep 6, 2008 at 6:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>>
>>>> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>>
>>>>> By changing printout form we are able to shrink code a bit.
>>>>>
>>>>> Former printout example:
>>>>>
>>>>>       init IO_APIC IRQs
>>>>>        IO-APIC (apicid-pin) 1-1, 1-2, 1-3 not connected.
>>>>>        IO-APIC (apicid-pin) 2-1, 2-2, 2-3 not connected.
>>>>>
>>>>> New printout example:
>>>>>
>>>>>       init IO_APIC IRQs
>>>>>        1-1 1-2 1-3 (apicid-pin) not connected
>>>>>        2-1 2-2 2-3 (apicid-pin) not connected
>>>>
>>>> applied to tip/irq/sparseirq - thanks Cyrill.
>>>
>>> got
>>>  0-16<7> 0-17<7> 0-18<7> 0-19<7> 0-20<7> 0-21<7> 0-22<7> 0-23<7>
>>> (apicid-pin) not connected
>>>  1-0<7> 1-1<7> 1-2<7> 1-3<7> 1-4<7> 1-5<7> 1-6<7> 1-7<7> 1-8<7> 1-9<7>
>>> 1-10<7> 1-11<7> 1-12<7> 1-13<7> 1-14<7> 1-15<7> 1-16<7> 1-17<7>
>>> 1-18<7> 1-19<7> 1-20<7> 1-21<7> 1-22<7> 1-23<7> (apicid-pin) not
>>> connected
>>>
>>> can you remove the extra <7>?
>>>
>>> YH
>>>
>>
>> Btw Yinghai, do you really have a machine with that many unconnected pins?
>
> Yes
>
> recent change in sparseirq, we only init irq [0,16) at that point. so
> pins on other io apic controller all unconnected...
>
correction: sparseirq does not change the behavoir...

ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 0-0 not connected.
IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 0-16, 0-17, 0-18, 0-19, 0-20, 0-21, 0-22, 0-23,
1-0, 1-1, 1-2, 1-3, 1-4, 1-5, 1-6, 2-0, 2-1, 2-2, 2-3, 2-4, 2-5, 2-6,
3-0, 3-1, 3-2, 3-3, 3-4, 3-5, 3-6, 3-7, 3-8, 3-9, 3-10, 3-11, 3-12,
3-13, 3-14, 3-15, 3-16, 3-17, 3-18, 3-19, 3-20, 3-21, 3-22, 3-23 not
connected.

there is some difference between using acpi or mptable...

when mpatble is used, mp_irqs is all filled after mptable is parsed.

when acpi is used, one [0-15) is filled..., later it will fill entries
when acpi add entries...mp_register_gsi/mp_config_acpi_gsi

YH
