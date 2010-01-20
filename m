Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075Ab0ATDAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0ATDAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 22:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128Ab0ATDAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 22:00:41 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:63182 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0ATDAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 22:00:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BFWQxJmmv0BIPiIhcjMno8kOsNDpEX+hx3i+fujp4nUgx4y5bYHt1IYkkdH1F2qIRn
         mBpjFhVMGvS5vRlUrbMbYSnhyRnXUDWnI9FgTLRzj4ZzK1+TPhfsjpCtmyybXJx6b3Uv
         TS/9Vx36UMxbRHm7KqtIzbFj6B3s4dLnd9YXA=
MIME-Version: 1.0
In-Reply-To: <64bb37e1001191220u72f7af29xdc1c39f1d114bc21@mail.gmail.com>
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
	 <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>
	 <4B4A7BC7.6060106@kernel.org> <4B4A815A.60503@gmail.com>
	 <64bb37e1001161358r79ea2da0u88e9894fa5987ef1@mail.gmail.com>
	 <4B536383.7090609@gmail.com>
	 <64bb37e1001171311u21c58fbj9a13b6aaeb7b2c3f@mail.gmail.com>
	 <64bb37e1001181251y733513cdm1be9850af880ee73@mail.gmail.com>
	 <4B55130D.8070503@gmail.com>
	 <64bb37e1001191220u72f7af29xdc1c39f1d114bc21@mail.gmail.com>
Date: Tue, 19 Jan 2010 21:00:34 -0600
Message-ID: <51f3faa71001191900y521f2be3u3a5e341f3113559@mail.gmail.com>
Subject: Re: MSI broken in libata?
From: Robert Hancock <hancockrwd@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 2:20 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Tue, Jan 19, 2010 at 3:03 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> On 01/18/2010 02:51 PM, Torsten Kaiser wrote:
>>> If I kill the drive with reading a 1GB file with dd, I get the above
>>> errors, include the one from do_IRQ.
>>> If I kill the drive with writing a 1GB file with dd, I do not get the
>>> do_IRQ error.
>>> As I tested the earlier -rcs only with writes, I didn't see it there.
>>> (Its not even in the old logs that contain the libata errors)
>>>
>>> Should I try to put some printks in arch/x86/kernel/apic/io_apic.c
>>> __assign_irq_vector() or is there a better way to look at the irq
>>> vectors?
>>
>> Might not be a bad idea. Something definitely seems to be banging on vector
>> 165. Any references to 165 in dmesg prior to that? I wonder where that is
>> coming from..
>
> I still have no clue, where that interrupt comes from, maybe these
> outputs will help:
> (complete log attached)
>
> First the PCIe bridges allocate some vectors:
> [    1.789044] pcieport 0000:00:0b.0: setting latency timer to 64
> [    1.789058]   alloc irq_desc for 24 on node 0
> [    1.789060]   alloc kstat_irqs on node 0
> [    1.789063] __assign_irq_vector:assigning irq 24 to vector 73
> [    1.794655] pcieport 0000:00:0b.0: irq 24 for MSI/MSI-X
> [    1.794968] pcieport 0000:00:0c.0: setting latency timer to 64
> [    1.794980]   alloc irq_desc for 25 on node 0
> [    1.794981]   alloc kstat_irqs on node 0
> [    1.794983] __assign_irq_vector:assigning irq 25 to vector 81
> [    1.800569] pcieport 0000:00:0c.0: irq 25 for MSI/MSI-X
> [    1.800870] pcieport 0000:00:0d.0: setting latency timer to 64
> [    1.800882]   alloc irq_desc for 26 on node 0
> [    1.800883]   alloc kstat_irqs on node 0
> [    1.800885] __assign_irq_vector:assigning irq 26 to vector 89
> [    1.806455] pcieport 0000:00:0d.0: irq 26 for MSI/MSI-X
> [    1.806766] pcieport 0000:00:0f.0: setting latency timer to 64
> [    1.806778]   alloc irq_desc for 27 on node 0
> [    1.806779]   alloc kstat_irqs on node 0
> [    1.806781] __assign_irq_vector:assigning irq 27 to vector 97
> [    1.812366] pcieport 0000:00:0f.0: irq 27 for MSI/MSI-X
> radeon allocates to vectors, is that right?
> [    1.861528] [drm] radeon kernel modesetting enabled.
> [    1.866835] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
> [    1.872598]   alloc irq_desc for 19 on node 0
> [    1.872600]   alloc kstat_irqs on node 0
> [    1.872602] __assign_irq_vector:assigning irq 19 to vector 105
> [    1.878261] radeon 0000:01:00.0: PCI INT A -> Link[LNEB] -> GSI 19
> (level, low) -> IRQ 19
> [    1.886673] radeon 0000:01:00.0: setting latency timer to 64
> [    1.888791] [drm] radeon: Initializing kernel modesetting.
> [    1.894449] [drm] register mmio base: 0xEFBF0000
> [    1.899068] [drm] register mmio size: 65536
> [    1.903947] [drm] GPU reset succeed (RBBM_STATUS=0x00000140)
> [    1.909620] [drm] Generation 2 PCI interface, using max accessible memory
> [    1.916436] [drm] radeon: VRAM 128M
> [    1.919930] [drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
> [    1.925610] [drm] radeon: GTT 512M
> [    1.929022] [drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
> [    1.934635]   alloc irq_desc for 28 on node 0
> [    1.934637]   alloc kstat_irqs on node 0
> [    1.934640] __assign_irq_vector:assigning irq 28 to vector 113
> [    1.940314] radeon 0000:01:00.0: irq 28 for MSI/MSI-X
> [    1.940522] [drm] radeon: using MSI.
> [    1.944120] [drm] radeon: irq initialized.
> Now sata_sil24 gets vector 121:
> [    2.525316] sata_sil24 0000:04:00.0: version 1.1
> [    2.525337] sata_sil24 0000:04:00.0: PCI INT A -> Link[LNEB] -> GSI
> 19 (level, low)
> -> IRQ 19
> [    2.533990]   alloc irq_desc for 29 on node 0
> [    2.533991]   alloc kstat_irqs on node 0
> [    2.533994] __assign_irq_vector:assigning irq 29 to vector 121
> [    2.539681] sata_sil24 0000:04:00.0: irq 29 for MSI/MSI-X
> [    2.539882] sata_sil24 0000:04:00.0: Using MSI
> [    2.544372] sata_sil24 0000:04:00.0: setting latency timer to 64
> sata_nv gets 3 interrupts (the MCP55 has 6 ports)
> [    2.565829] sata_nv 0000:00:05.0: version 3.5
> [    2.566114] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
> [    2.571896]   alloc irq_desc for 23 on node 0
> [    2.571898]   alloc kstat_irqs on node 0
> [    2.571900] __assign_irq_vector:assigning irq 23 to vector 129
> [    2.577583] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23
> (level, low) ->
> IRQ 23
> [    2.586099] sata_nv 0000:00:05.0: Using SWNCQ mode
> [    2.590956] sata_nv 0000:00:05.0: setting latency timer to 64
> [    2.591071] scsi2 : sata_nv
> [    2.594013] scsi3 : sata_nv
> [    2.597018] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 23
> [    2.604196] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 23
> [    2.611671] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
> [    2.617435]   alloc irq_desc for 22 on node 0
> [    2.617436]   alloc kstat_irqs on node 0
> [    2.617438] __assign_irq_vector:assigning irq 22 to vector 137
> [    2.623152] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22
> (level, low) ->
> IRQ 22
> [    2.631657] sata_nv 0000:00:05.1: Using SWNCQ mode
> [    2.636490] sata_nv 0000:00:05.1: setting latency timer to 64
> [    2.636618] scsi4 : sata_nv
> [    2.639558] scsi5 : sata_nv
> [    2.642573] ata5: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq 22
> [    2.649726] ata6: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808 irq 22
> [    2.657246] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
> [    2.663034]   alloc irq_desc for 21 on node 0
> [    2.663035]   alloc kstat_irqs on node 0
> [    2.663037] __assign_irq_vector:assigning irq 21 to vector 145
> [    2.668720] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21
> (level, low) -> IRQ 21
> [    2.677237] sata_nv 0000:00:05.2: Using SWNCQ mode
> [    2.682085] sata_nv 0000:00:05.2: setting latency timer to 64
> [    2.682204] scsi6 : sata_nv
> [    2.685148] scsi7 : sata_nv
> [    2.688149] ata7: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xac00 irq 21
> [    2.695325] ata8: SATA max UDMA/133 cmd 0xb080 ctl 0xb000 bmdma 0xac08 irq 21
> the network chips follow:
> [    2.729649] tg3.c:v3.105 (December 2, 2009)
> [    2.735339] ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 18
> [    2.742377]   alloc irq_desc for 18 on node 0
> [    2.742378]   alloc kstat_irqs on node 0
> [    2.742380] __assign_irq_vector:assigning irq 18 to vector 153
> [    2.748065] tg3 0000:03:00.0: PCI INT A -> Link[LNEA] -> GSI 18
> (level, low) -> IRQ 18
> ...
> [    2.838517] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 17
> [    2.845796]   alloc irq_desc for 17 on node 0
> [    2.845797]   alloc kstat_irqs on node 0
> [    2.845799] __assign_irq_vector:assigning irq 17 to vector 161
> [    2.851501] tg3 0000:02:00.0: PCI INT A -> Link[LNED] -> GSI 17
> (level, low) -> IRQ 17
> one for the firewrie chip:
> [    2.939495] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
> [    2.946971]   alloc irq_desc for 16 on node 0
> [    2.946972]   alloc kstat_irqs on node 0
> [    2.946974] __assign_irq_vector:assigning irq 16 to vector 169
> [    2.952677] ohci1394 0000:05:08.0: PCI INT A -> Link[LNKA] -> GSI
> 16 (level, low) -> IRQ 16
> USB:
> [    3.058354] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.066956] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 20
> [    3.074517]   alloc irq_desc for 20 on node 0
> [    3.074518]   alloc kstat_irqs on node 0
> [    3.074520] __assign_irq_vector:assigning irq 20 to vector 177
> [    3.080223] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI
> 20 (level, low) -> IRQ 20
> and the last allocation for HDA Intel:
> [    4.993274]   alloc irq_desc for 30 on node 0
> [    4.993276]   alloc kstat_irqs on node 0
> [    4.993279] __assign_irq_vector:assigning irq 30 to vector 185
> [    4.998961] HDA Intel 0000:00:06.1: irq 30 for MSI/MSI-X
> During booting the tg3's change there interrupts. Huh?
> [   19.135631]   alloc irq_desc for 31 on node 0
> [   19.135639]   alloc kstat_irqs on node 0
> [   19.135646] __assign_irq_vector:assigning irq 31 to vector 193
> [   19.135663] tg3 0000:03:00.0: irq 31 for MSI/MSI-X
> [   22.326847] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> [   22.326854] tg3: eth0: Flow control is on for TX and on for RX.
> [   23.434378]   alloc irq_desc for 32 on node 0
> [   23.434386]   alloc kstat_irqs on node 0
> [   23.434393] __assign_irq_vector:assigning irq 32 to vector 201
> [   23.434410] tg3 0000:02:00.0: irq 32 for MSI/MSI-X
> [   26.104711] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> [   26.104718] tg3: eth1: Flow control is on for TX and on for RX.
>
> Then I rerun my readtest and got the same do_IRQ error again:
> [  100.664581] do_IRQ: 0.165 No irq handler for vector (irq -1)
> [  100.664598] do_IRQ: 1.165 No irq handler for vector (irq -1)
> [  100.664619] do_IRQ: 3.165 No irq handler for vector (irq -1)
> [  100.664632] do_IRQ: 2.165 No irq handler for vector (irq -1)
> [  130.980054] ata2.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
> [  130.980065] ata2.00: failed command: READ FPDMA QUEUED
> [  130.980077] ata2.00: cmd 60/00:00:ad:9b:da/01:00:01:00:00/40 tag 0
> ncq 131072 in
> [  130.980080]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  130.980085] ata2.00: status: { DRDY }
> [  130.980090] ata2.00: failed command: READ FPDMA QUEUED
> [  130.980099] ata2.00: cmd 60/00:08:ad:9c:da/01:00:01:00:00/40 tag 1
> ncq 131072 in
> [  130.980101]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  130.980106] ata2.00: status: { DRDY }
>
> As I did not see any real relation, I disabled all unneeded drivers
> and tested again.
> This minimal kernel had the following interrupt map:
>           CPU0       CPU1       CPU2       CPU3
>  0:         36          0          0          1   IO-APIC-edge      timer
>  1:          0          0          1        152   IO-APIC-edge      i8042
>  4:          0          0          0        212   IO-APIC-edge      serial
>  7:          1          0          0          0   IO-APIC-edge
>  9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  12:          0          0          0          4   IO-APIC-edge      i8042
>  21:          0          0          0          0   IO-APIC-fasteoi   sata_nv
>  22:          0          0          0          0   IO-APIC-fasteoi   sata_nv
>  23:          0          5          4       4980   IO-APIC-fasteoi   sata_nv
>  28:          0          1          0        168   PCI-MSI-edge      sata_sil24
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC:       2147       2390       2285       2344   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:          0          0          0          0   Performance
> monitoring interrupts
> PND:          0          0          0          0   Performance pending work
> RES:       3702       3458       2094       2746   Rescheduling interrupts
> CAL:        660         33         41         26   Function call interrupts
> TLB:        484        200        448        581   TLB shootdowns
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:          1          1          1          1   Machine check polls
> ERR:          1
> MIS:          0
>
> Output of the __assign_irq:
> 4x PCIe bridge:
> [    1.759016] __assign_irq_vector:assigning irq 24 to vector 73
> [    1.764928] __assign_irq_vector:assigning irq 25 to vector 81
> [    1.770827] __assign_irq_vector:assigning irq 26 to vector 89
> [    1.776720] __assign_irq_vector:assigning irq 27 to vector 97
> sata_sil24 first gets 19:
> [    1.856245] __assign_irq_vector:assigning irq 19 to vector 105
> then switches to MSI-28:
> [    1.870768] __assign_irq_vector:assigning irq 28 to vector 113
> 3 normal interrupts for sata_nv:
> [    1.908504] __assign_irq_vector:assigning irq 23 to vector 121
> [    1.953848] __assign_irq_vector:assigning irq 22 to vector 129
> [    1.999155] __assign_irq_vector:assigning irq 21 to vector 137
>
> Writing failed again without a message, but the read test showed:
> [   85.695745] do_IRQ: 0.165 No irq handler for vector (irq -1)
> [   85.695763] do_IRQ: 1.165 No irq handler for vector (irq -1)
> [   85.695785] do_IRQ: 3.165 No irq handler for vector (irq -1)
> [   85.695800] do_IRQ: 2.165 No irq handler for vector (irq -1)
> Same vector in this error, but sata_sil24 had MSI irq 28 instead of 29!
> And the vector allocations where not even near 165!

Hmm.. Can you send the output of lspci -vv with MSI in use?
