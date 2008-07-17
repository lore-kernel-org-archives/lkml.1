Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbYGQU7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbYGQU7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbYGQU66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:58:58 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:1822 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbYGQU65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KvMUEYegtPdbOG6GJHTpKYUHxmlIX3t5nWGQwcktU2ei+Ywj/9MC5jBOXbzXlMtG9p
         CKd323Id3Wx5deUGYEhk3zeD3q8lCyWMEXnHAg87e5GyT3cnXrNBi/9x13lJ3nha0MS4
         TNo4/p0dZoZRO3I8zWnwef8RAAyJCbQ9jBzhU=
Message-ID: <19f34abd0807171358p3c5a44f9i91ab23d3f5e9671f@mail.gmail.com>
Date: Thu, 17 Jul 2008 22:58:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: v2.6.26-rc9: ACPI PCI irq routing on NUMA? + early_ioremap trouble
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, venkatesh.pallipadi@intel.com,
       "Huang Ying" <ying.huang@intel.com>, "Andi Kleen" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <200807171245.31641.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807060647k54490088uf8859d8a1646fd41@mail.gmail.com>
	 <200807171245.31641.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 8:45 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Sunday 06 July 2008 07:47:19 am Vegard Nossum wrote:
>> I have produced a config which doesn't boot correctly on either of my
>> computers with v2.6.26-rc9.
>>
>> The first problem is with my laptop, which hangs on boot, see
>> screenshot (sorry for the bad quality, I was in a hurry):
>> http://folk.uio.no/vegardno/linux/DSCF3026.JPG
>>
>> I figured there's something wrong with ACPI PCI irq routing as I'm
>> missing a message that shows up in my usual configs:
>>
>> calling  ide_scan_pcibus+0x0/0xf0
>> ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
>>     --- HERE: ---
>> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
>>     ----
>> ICH8M: not 100% native mode: will probe irqs later
>>
>> ...and as can be seen in the screenshot, ide-cd "lost interrupt".
>> Unfortunately, I don't have a serial line on this machine, so it's
>> hard to get the full log. (Maybe I can try netconsole, it seems to be
>> up by the time this happens.)
>
> If you could get netconsole working and collect the complete
> console log from both the working config and the broken one,
> that would help a lot.

Hah, I actually managed to get netconsole working. This is the log
that fails (v2.6.26):

http://folk.uio.no/vegardno/linux/numa-netconsole.txt

I think this looks really interesting:

[    0.093562] ExtINT not setup in hardware but reported by MP table
[    0.093854] ENABLING IO-APIC IRQs
[    0.094244] ..TIMER: vector=0x31 apic1=-1 pin1=2 apic2=-1 pin2=0
[    0.094985] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.094985] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.094985] ..... (found pin 0) ...<7>APIC error on CPU0: 00(80)
[    0.094985]  failed.
[    0.094985] ...trying to set up timer as Virtual Wire IRQ...<7>APIC
error on CPU0: 80(80)
[    0.105761]  works.

This error would be:
           7: Illegal register address

Looks like APIC was misconfigured, which might explain IRQ routing weirdness?

Will try to provide the booting one later. Now zZz...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
