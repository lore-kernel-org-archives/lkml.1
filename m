Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbZHXOuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbZHXOuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZHXOuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:50:21 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38271 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZHXOuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j990keXSWwtO9bp2teqtciWtnDno+9GQjoYx24ZpL0oAU7ekINHrN8BiEFHg/PK15N
         NEybfLnIQbae/6sWA9XJRCm1EHJUzjt2pqrNBjFq+I4+RUnumqvUx/Ecw6UYZraFq8yu
         CagJYsMBmbpDf++CXgrfoAPcUa9nEFE5XexbE=
MIME-Version: 1.0
In-Reply-To: <1251124609.2359.25.camel@dhcp231-106.rdu.redhat.com>
References: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>
	 <4A8EFFB2.4040100@suse.de>
	 <1250886352.2168.83.camel@dhcp231-106.rdu.redhat.com>
	 <4A8F1081.3020803@suse.de>
	 <1251124609.2359.25.camel@dhcp231-106.rdu.redhat.com>
Date: Mon, 24 Aug 2009 16:50:08 +0200
Message-ID: <19f34abd0908240750q454a684fy9aaf4a1cb596c4ce@mail.gmail.com>
Subject: Re: BUG: scheduling while atomic in acpi_ps_complete_op
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, len.brown@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/24 Eric Paris <eparis@redhat.com>:
> On Sat, 2009-08-22 at 01:24 +0400, Alexey Starikovskiy wrote:
>> Eric Paris пишет:
>> > On Sat, 2009-08-22 at 00:12 +0400, Alexey Starikovskiy wrote:
>> >> Hi,
>> >> This should be handled by abe1dfab60e1839d115930286cb421f5a5b193f3.
>> >
>> > And yet I'm getting it from linux-next today.
>> >
>> > So you are apparently failing the in_atomic_preempt_off() test but
>> > succeeding in your !irqs_disabled() test.
>> >
>> > Something isn't right since I'm hitting it hundreds of times on boot.
>> >
>> > -Eric
>> >
>> Ok, let's see if replacing irqs_disabled() to
>> in_atomic_preempt_off() helps...
>
> It does stop my slew of warnings.  Not sure it completely fixes my
> problems though....
>
> [    1.897021] ... counter mask:            0000000700000003^M
> [    1.906821] ACPI: Core revision 20090625^M
> [   10.000008] INFO: RCU detected CPU 0 stall (t=10000 jiffies)^M
> [   10.000008] sending NMI to all CPUs:^M
> [   21.907580] Setting APIC routing to flat^M
> [   21.973314] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1^M
> [   21.985260] CPU0: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07^M
> [   21.992017] kmemcheck: Limiting number of CPUs to 1.^M
> [   21.993065] kmemcheck: Initialized^M
> [   22.750118] Brought up 1 CPUs^M
> [   22.751069] Total of 1 processors activated (5333.45 BogoMIPS).^M
> [   23.493639] khelper used greatest stack depth: 4848 bytes left^M
> [   24.999193] Booting paravirtualized kernel on bare hardware^M
> [   25.265364] Time: 17:50:52  Date: 08/21/09^M
> [   25.616191] NET: Registered protocol family 16^M
> [   27.765113] ACPI: bus type pci registered^M
> [   28.795307] PCI: Using configuration type 1 for base access^M
> [   61.793279] bio: create slab <bio-0> at 0^M
> [   95.285367] ACPI: BIOS _OSI(Linux) query ignored^M
> [  102.628227] ACPI: Interpreter enabled^M
> [  102.630134] ACPI: (supports S0 S1 S5)^M
> [  102.823225] ACPI: Using IOAPIC for interrupt routing^M
> [  142.365090] ACPI: No dock devices found.^M
> [  156.864036] ACPI: PCI Root Bridge [PCI0] (0000:00)^M
> [  157.460654] pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI^M
> [  157.463937] pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB^M
> [  157.644036] pci 0000:00:11.0: transparent bridge^M
> [  193.009036] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.^M
> [  193.938036] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 14 15)^M
> [  194.864036] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 14 15)^M
> [  195.780036] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.^M
>
> Something took 20 seconds between "ACPI: Core revision 20090625" and
> "Setting APIC routing to flat"
>
> This is a linux-next kernel, on vmware-server, with kmemcheck enabled.
> Disabling kmemcheck seems to make all of this go away.  If not the ACPI
> guys who should I be talking to?
>
> A little bit later I finally see backtraces from NMIs because of RCU
> stalls.  Anyone have ideas here?
>
> [  213.168161] INFO: RCU detected CPU 0 stall (t=10004 jiffies)^M

So this is probably just the intrinsic slowness of kmemcheck that
causes the the big delays and RCU stalls. It shouldn't cause any other
badness, as far as I understood, the 10000 jiffies limit is just a
heuristic. Maybe we need to adjust it when kmemcheck is enabled.

I'm more confused about the change you had to with
irqs_disabled()/in_atomic_preempt_off().


Vegard
