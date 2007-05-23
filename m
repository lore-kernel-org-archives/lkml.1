Return-Path: <linux-kernel-owner+w=401wt.eu-S1763317AbXEWHPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763317AbXEWHPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbXEWHP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:15:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:48481 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbXEWHPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VkkCDmIlztVDqZfq5RoZvSk6UmuLd472f4cP28qtzFGBnqR9QKlR8SRpw4WsjXCpJPOpBp39TRaKn+FNWe2QOKkEnyAjrJ2lpsAGMysQHql/zUJDaWvvQ/jfkowoIpZKTE4wsvnckmJbmm7ZZHDfqQ4Mykn+pK4BR84DpQ7EZFg=
Subject: Re: [patch 00/69] -stable review
From: Romano Giannetti <romano.giannetti@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070521212522.GL3429@sequoia.sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
	 <4652070D.3090509@redhat.com>
	 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	 <20070521212522.GL3429@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 09:15:18 +0200
Message-Id: <1179904518.7043.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resent, using gmail)

On Mon, 2007-05-21 at 14:25 -0700, Chris Wright wrote: 
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > On Mon, 21 May 2007, Chuck Ebbert wrote:
> > > 
> > > What happened to:
> > > 
> > > "Fix ACPI suspend / device suspend ordering problem"
> > > 52ade9b3b97fd3bea42842a056fe0786c28d0555
> > 
> > I would suggest waiting on problem reports for that one a bit longer.
> 
> It's queued for the next 21.y stable, to give it a little more time.
> 

It's an useful patch for me. Without it, my sony vaio pcg-fx701 was very
erratic in resume (kernel 2.6.21.1; it works well with the .17 ubuntu
kernel). With this patch, I have done 7 cycles flawlessly. Even the
out-of-tree rtl8180 wireless driver [1] works ok across resumes. 

The only problem is that there is an gaping delay of 60 seconds (more or
less) on resume. I have the syslog trace copied below; could be a timer
problem? Is it known? (It is scaring because the laptop seems dead
during this time. I'm not and expert, but it seems here:

[    1.617972] pcmcia: registering new device pcmcia1.0 
[   61.612517] PM: Writing back config space on device 0000:00:[...]

...and time do not advance.

Romano 

[1] http://rtl-wifi.sourceforge.net/wiki/Main_Page

May 22 17:55:28 localhost kernel: [    0.565042] Back to C!
May 22 17:55:28 localhost kernel: [    0.566588] Applying VIA southbridge workaround.
May 22 17:55:28 localhost kernel: [    0.566598] PCI: Disabling Via external APIC routing
May 22 17:55:28 localhost kernel: [    0.595156] PM: Writing back config space on device 0000:00:00.0 at offset 1 (was 2100006, writing b2100006)
May 22 17:55:28 localhost kernel: [    0.595181] PM: Writing back config space on device 0000:00:01.0 at offset 9 (was fff0, writing 40004000)
May 22 17:55:28 localhost kernel: [    0.595207] PCI: Setting latency timer of device 0000:00:01.0 to 64
May 22 17:55:28 localhost kernel: [    0.605346] ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
May 22 17:55:28 localhost kernel: [    0.605355] PCI: Setting latency timer of device 0000:00:07.2 to 64
May 22 17:55:28 localhost kernel: [    0.605395] usb usb1: root hub lost power or was reset
May 22 17:55:28 localhost kernel: [    0.616334] ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
May 22 17:55:28 localhost kernel: [    0.616342] PCI: Setting latency timer of device 0000:00:07.3 to 64
May 22 17:55:28 localhost kernel: [    0.616379] usb usb2: root hub lost power or was reset
May 22 17:55:28 localhost kernel: [    0.629345] ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
May 22 17:55:28 localhost kernel: [    0.629356] PCI: Setting latency timer of device 0000:00:07.5 to 64
May 22 17:55:28 localhost kernel: [    1.617815] pccard: PCMCIA card inserted into slot 1
May 22 17:55:28 localhost kernel: [    1.617972] pcmcia: registering new device pcmcia1.0
May 22 17:55:28 localhost kernel: [   61.612517] PM: Writing back config space on device 0000:00:0e.0 at offset 3 (was 8, writing 4008)
May 22 17:55:28 localhost kernel: [   61.612526] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was 2100012, writing 2100016)
May 22 17:55:28 localhost kernel: [   61.663580] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[9]  MMIO=[e8004000-e80047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
May 22 17:55:28 localhost kernel: [   61.666769] PM: Writing back config space on device 0000:00:10.0 at offset 5 (was 0, writing e8004800)
May 22 17:55:28 localhost kernel: [   61.666777] PM: Writing back config space on device 0000:00:10.0 at offset 4 (was 1, writing 1801)
May 22 17:55:28 localhost kernel: [   61.666785] PM: Writing back config space on device 0000:00:10.0 at offset 1 (was 2900000, writing 2900003)
May 22 17:55:28 localhost kernel: [   61.668452] pnp: Device 00:08 activated.
May 22 17:55:28 localhost kernel: [   61.668484] pnp: Failed to activate device 00:0a.
May 22 17:55:28 localhost kernel: [   61.668501] pnp: Failed to activate device 00:0b.
May 22 17:55:28 localhost kernel: [   62.713961]  usbdev1.2_ep00: PM: resume from 0, parent 1-2 still 2
May 22 17:55:28 localhost kernel: [   62.713968] usbhid 1-2:1.0: PM: resume from 2, parent 1-2 still 2
May 22 17:55:28 localhost kernel: [   62.713972]  usbdev1.2_ep81: PM: resume from 0, parent 1-2:1.0 still 2
May 22 17:55:28 localhost kernel: [   62.713977]  usbdev1.2: PM: resume from 0, parent 1-2 still 2
May 22 17:55:28 localhost kernel: [   62.714451] Restarting tasks ... done.
May 22 17:55:28 localhost kernel: [   62.799267] pcmcia: request for exclusive IRQ could not be fulfilled.
May 22 17:55:28 localhost kernel: [   62.799279] pcmcia: the driver needs updating to supported shared IRQ lines.
May 22 17:55:28 localhost kernel: [   62.842007] eth0: 3Com 3c589, io 0x300, irq 3, hw_addr 00:00:86:1A:4E:A8
May 22 17:55:28 localhost kernel: [   62.842019]   8K FIFO split 5:3 Rx:Tx, auto xcvr
May 22 17:55:28 localhost kernel: [   62.843128] pcmcia: registering new device pcmcia1.1
May 22 17:55:28 localhost kernel: [   62.843327] pcmcia: request for exclusive IRQ could not be fulfilled.
May 22 17:55:28 localhost kernel: [   62.843331] pcmcia: the driver needs updating to supported shared IRQ lines.
May 22 17:55:28 localhost kernel: [   62.883453] usb 1-2: USB disconnect, address 2
May 22 17:55:28 localhost firmware_helper[6082]: main: error loading '/lib/firmware/3CXEM556.cis' for device '/class/firmware/1.0' with driver '(unknown)'
May 22 17:55:28 localhost kernel: [   62.898934] 1.1: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
May 22 17:55:28 localhost gnome-power-manager: (romano) Resuming computer
May 22 17:55:29 localhost kernel: [   63.122753] usb 1-2: new low speed USB device using uhci_hcd and address 3
May 22 17:55:29 localhost kernel: [   63.266890] usb 1-2: configuration #1 chosen from 1 choice
May 22 17:55:29 localhost kernel: [   63.283145] input: HID 062a:0001 as /class/input/input8
May 22 17:55:29 localhost kernel: [   63.283254] input: USB HID v1.10 Mouse [HID 062a:0001] on usb-0000:00:07.2-2
May 22 17:55:31 localhost kernel: [   65.443554] tsdev (compaq touchscreen emulation) is scheduled for removal.
May 22 17:55:31 localhost kernel: [   65.443560] See Documentation/feature-removal-schedule.txt for details.
May 22 17:55:32 localhost kernel: [   66.383183] 8139too Fast Ethernet driver 0.9.28
May 22 17:55:32 localhost kernel: [   66.384536] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
May 22 17:55:32 localhost kernel: [   66.385555] eth0: RealTek RTL8139 at 0xe0bae800, 08:00:46:6e:93:a8, IRQ 10
May 22 17:55:32 localhost kernel: [   66.385562] eth0:  Identified 8139 chip type 'RTL-8139C'
May 22 17:55:33 localhost kernel: [   67.631633] input: Power Button (FF) as /class/input/input9
May 22 17:55:33 localhost kernel: [   67.631865] ACPI: Power Button (FF) [PWRF]
May 22 17:55:33 localhost kernel: [   67.632345] input: Sleep Button (CM) as /class/input/input10
May 22 17:55:33 localhost kernel: [   67.642920] ACPI: Sleep Button (CM) [SBTN]
May 22 17:55:33 localhost kernel: [   67.643101] input: Lid Switch as /class/input/input11
May 22 17:55:33 localhost kernel: [   67.643130] ACPI: Lid Switch [LID]
May 22 17:55:33 localhost kernel: [   68.336279] ACPI: Thermal Zone [THRM] (51 C)
May 22 17:55:34 localhost kernel: [   68.494424] ACPI: AC Adapter [ACAD] (on-line)
May 22 17:55:34 localhost kernel: [   68.853089] ACPI: Battery Slot [BAT1] (battery present)
May 22 17:55:34 localhost kernel: [   68.857492] ACPI: Battery Slot [BAT2] (battery absent)
May 22 17:55:34 localhost anacron[6386]: Anacron 2.3 started on 2007-05-22
May 22 17:55:34 localhost anacron[6386]: Normal exit (0 jobs run)


