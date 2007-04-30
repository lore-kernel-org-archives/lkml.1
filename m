Return-Path: <linux-kernel-owner+w=401wt.eu-S1946811AbXD3Uwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946811AbXD3Uwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946814AbXD3Uwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:52:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:51092 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946811AbXD3Uwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U9HfeWPHAp33nTe2Oir7C5gelTotVQd9fvj7ei6lkue0neMypCgXaNR1s1DEc+jG0JSGu8nrmDqa2sfa4c+KlWGPAe5tYtM74YYTlwpDQIMO3BfgnpfhKuJU9S1kdH6IUOZ3LVIqekGbbWOApvApgyf3mI6IYg8AdSqzPNjlgaw=
Message-ID: <a8f16e2b0704301352r56fe7db1j8931df4665d2c128@mail.gmail.com>
Date: Tue, 1 May 2007 00:52:34 +0400
From: "Dan Kruchinin" <dubalom@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 suspend bug. [kernel/kthread.c]
In-Reply-To: <200704292340.30637.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8f16e2b0704291251l69c1b02ahb9b22370bc468fa1@mail.gmail.com>
	 <200704292227.45215.rjw@sisk.pl>
	 <a8f16e2b0704291346h40519e7dp76798bedfd9e150e@mail.gmail.com>
	 <200704292340.30637.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> [Please don't drop addresses from the CC list]
>
> On Sunday, 29 April 2007 22:46, Dan Kruchinin wrote:
> > On 4/30/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > Hi,
> > >
> > > On Sunday, 29 April 2007 21:51, Dan Kruchinin wrote:
> > > > Hi all.
> > > >
> > > > There is a problem on my macbook core duo with suspend.
> > > > after suspending when i'm trying to 'wake up' my notebook, it seems
> > > > that it works, but i don't see anything at my monitor. So i have to
> > > > reboot it to continue my work.
> > >
> > > What exactly do you do to suspend?
> > >
> > > Rafael
> > >
> > >
> > > > ---
> > > > Apr 29 23:31:16 midgard kernel: [140594.900856] BUG: at
> > > > kernel/kthread.c:166 kthread_bind()
> > > > Apr 29 23:31:16 midgard kernel: [140594.900870]  [<c0142c9b>]
> > > > _cpu_down+0x16b/0x250
> > > > Apr 29 23:31:16 midgard kernel: [140594.900893]  [<c0142f80>]
> > > > disable_nonboot_cpus+0x60/0xf0
> > > > Apr 29 23:31:16 midgard kernel: [140594.900903]  [<c0147efa>]
> > > > enter_state+0x22a/0x240
> > > > Apr 29 23:31:16 midgard kernel: [140594.900913]  [<c0147fcd>]
> > > > state_store+0xbd/0xd0
> > > > Apr 29 23:31:16 midgard kernel: [140594.900920]  [<c0147f10>]
> > > > state_store+0x0/0xd0
> > > > Apr 29 23:31:16 midgard kernel: [140594.900927]  [<c01c1559>]
> > > > subsys_attr_store+0x29/0x40
> > > > Apr 29 23:31:16 midgard kernel: [140594.900937]  [<c01c1774>]
> > > > sysfs_write_file+0xd4/0x160
> > > > Apr 29 23:31:16 midgard kernel: [140594.900948]  [<c0180eb6>]
> > > > vfs_write+0xa6/0x160
> > > > Apr 29 23:31:16 midgard kernel: [140594.900958]  [<c01c16a0>]
> > > > sysfs_write_file+0x0/0x160
> > > > Apr 29 23:31:16 midgard kernel: [140594.900966]  [<c0181601>]
> > > > sys_write+0x41/0x70
> > > > Apr 29 23:31:16 midgard kernel: [140594.900974]  [<c018c70b>]
> > > > sys_dup2+0xeb/0x120
> > > > Apr 29 23:31:16 midgard kernel: [140594.900984]  [<c0104116>]
> > > > sysenter_past_esp+0x5f/0x85
> > > > Apr 29 23:31:16 midgard kernel: [140594.900999]  =======================
> > > > ---
> > > >
> > > > dmesg output:
> > > > ----
> > > > ....
> > > > Apr 29 23:31:16 midgard kernel: [140594.788697] Suspending device vtcon0
> > > > Apr 29 23:31:16 midgard kernel: [140594.788700] Suspending device platform
> > > > Apr 29 23:31:16 midgard kernel: [140594.788704] Disabling non-boot CPUs ...
> > > > Apr 29 23:31:16 midgard kernel: [140594.900464] CPU 1 is now offline
> > > > Apr 29 23:31:16 midgard kernel: [140594.900469] SMP alternatives:
> > > > switching to UP code
> > > > Apr 29 23:31:16 midgard kernel: [140594.900856] BUG: at
> > > > kernel/kthread.c:166 kthread_bind()
> > > > Apr 29 23:31:16 midgard kernel: [140594.900870]  [<c0142c9b>]
> > > > _cpu_down+0x16b/0x250
> > > > Apr 29 23:31:16 midgard kernel: [140594.900893]  [<c0142f80>]
> > > > disable_nonboot_cpus+0x60/0xf0
> > > > Apr 29 23:31:16 midgard kernel: [140594.900903]  [<c0147efa>]
> > > > enter_state+0x22a/0x240
> > > > Apr 29 23:31:16 midgard kernel: [140594.900913]  [<c0147fcd>]
> > > > state_store+0xbd/0xd0
> > > > Apr 29 23:31:16 midgard kernel: [140594.900920]  [<c0147f10>]
> > > > state_store+0x0/0xd0
> > > > Apr 29 23:31:16 midgard kernel: [140594.900927]  [<c01c1559>]
> > > > subsys_attr_store+0x29/0x40
> > > > Apr 29 23:31:16 midgard kernel: [140594.900937]  [<c01c1774>]
> > > > sysfs_write_file+0xd4/0x160
> > > > Apr 29 23:31:16 midgard kernel: [140594.900948]  [<c0180eb6>]
> > > > vfs_write+0xa6/0x160
> > > > Apr 29 23:31:16 midgard kernel: [140594.900958]  [<c01c16a0>]
> > > > sysfs_write_file+0x0/0x160
> > > > Apr 29 23:31:16 midgard kernel: [140594.900966]  [<c0181601>]
> > > > sys_write+0x41/0x70
> > > > Apr 29 23:31:16 midgard kernel: [140594.900974]  [<c018c70b>]
> > > > sys_dup2+0xeb/0x120
> > > > Apr 29 23:31:16 midgard kernel: [140594.900984]  [<c0104116>]
> > > > sysenter_past_esp+0x5f/0x85
> > > > Apr 29 23:31:16 midgard kernel: [140594.900999]  =======================
> > > > Apr 29 23:31:16 midgard kernel: [140594.902843] CPU1 is down
> > > > Apr 29 23:31:16 midgard kernel: [18014366.415769] Enabling non-boot CPUs ...
> > > > Apr 29 23:31:16 midgard kernel: [18014366.426999] SMP alternatives:
> > > > switching to SMP code
> > > > Apr 29 23:31:16 midgard kernel: [18014366.427165] Booting processor 1/1 eip 3000
> > > > Apr 29 23:31:16 midgard kernel: [18014366.436913] Initializing CPU#1
> > > > Apr 29 23:31:16 midgard kernel: [18014366.509141] Calibrating delay
> > > > using timer specific routine.. 3994.69 BogoMIPS (lpj=7989390)
> > > > Apr 29 23:31:16 midgard kernel: [18014366.509152] monitor/mwait feature present.
> > > > Apr 29 23:31:16 midgard kernel: [18014366.509156] CPU: L1 I cache:
> > > > 32K, L1 D cache: 32K
> > > > Apr 29 23:31:16 midgard kernel: [18014366.509158] CPU: L2 cache: 2048K
> > > > Apr 29 23:31:16 midgard kernel: [18014366.509160] CPU: Physical Processor ID: 0
> > > > Apr 29 23:31:16 midgard kernel: [18014366.509161] CPU: Processor Core ID: 1
> > > > Apr 29 23:31:16 midgard kernel: [18014366.509637] CPU1: Intel Genuine
> > > > Intel(R) CPU            1500  @ 2.00GHz stepping 08
> > > > Apr 29 23:31:16 midgard kernel: [18014366.509659] checking TSC
> > > > synchronization [CPU#0 -> CPU#1]:
> > > > Apr 29 23:31:16 midgard kernel: [18014366.529627] Measured 68812018716
> > > > cycles TSC warp between CPUs, turning off TSC clock.
> > > > Apr 29 23:31:16 midgard kernel: [18014366.529630] Marking TSC unstable
> > > > due to: check_tsc_sync_source failed.
> > > > Apr 29 23:31:16 midgard kernel: [18014366.529641] Time: hpet
> > > > clocksource has been installed.
> > > > Apr 29 23:31:16 midgard kernel: [18014366.530137] speedstep-centrino
> > > > with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
> > > > Apr 29 23:31:16 midgard kernel: [18014366.530139]  Use
> > > > X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
> > > > Apr 29 23:31:16 midgard kernel: [18014366.530209] CPU1 is up
> > > > Apr 29 23:31:16 midgard kernel: [18014366.614003] Clocksource tsc
> > > > unstable (delta = 4125051653052 ns)
> > > > Apr 29 23:31:16 midgard kernel: [18014366.730352] ACPI: PCI Interrupt
> > > > 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> > > > Apr 29 23:31:16 midgard kernel: [18014366.745126] ACPI: PCI Interrupt
> > > > 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
> > > > Apr 29 23:31:16 midgard kernel: [18014366.894946] ACPI: PCI Interrupt
> > > > 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895025] ACPI: PCI Interrupt
> > > > 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895039] PCI: Enabling device
> > > > 0000:00:1d.0 (0000 -> 0001)
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895042] ACPI: PCI Interrupt
> > > > 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 21
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895104] usb usb1: root hub
> > > > lost power or was reset
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895141] PCI: Enabling device
> > > > 0000:00:1d.1 (0000 -> 0001)
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895144] ACPI: PCI Interrupt
> > > > 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895204] usb usb2: root hub
> > > > lost power or was reset
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895237] PCI: Enabling device
> > > > 0000:00:1d.2 (0000 -> 0001)
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895240] ACPI: PCI Interrupt
> > > > 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895299] usb usb3: root hub
> > > > lost power or was reset
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895328] PCI: Enabling device
> > > > 0000:00:1d.3 (0000 -> 0001)
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895331] ACPI: PCI Interrupt
> > > > 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
> > > > Apr 29 23:31:16 midgard kernel: [18014366.895391] usb usb4: root hub
> > > > lost power or was reset
> > > > Apr 29 23:31:16 midgard kernel: [18014366.909854] PCI: Enabling device
> > > > 0000:00:1d.7 (0000 -> 0002)
> > > > Apr 29 23:31:16 midgard kernel: [18014366.909857] ACPI: PCI Interrupt
> > > > 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 21
> > > > Apr 29 23:31:16 midgard kernel: [18014366.910032] ACPI: PCI Interrupt
> > > > 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> > > > Apr 29 23:31:16 midgard kernel: [18014366.924871] ACPI: PCI Interrupt
> > > > 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> > > > Apr 29 23:31:16 midgard kernel: [18014366.939965] sky2 eth0: enabling interface
> > > > Apr 29 23:31:16 midgard kernel: [18014366.941763] sky2 eth0: ram buffer 48K
> > > > Apr 29 23:31:16 midgard kernel: [18014367.006976] ohci1394: fw-host0:
> > > > OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[90000000-900007ff]  Max
> > > > Packet=[2048]  IR/IT contexts=[8/8]
> > > > ...
> > > > ---
> > > >
> > > > Thanks.
> > > > Dan Kruchinin.
> > >
> >
> > echo "mem" > /sys/power/state
>
> What's the last good kernel?
>
> Rafael
>

I bought this notebook quite recently and used on it
2.6.21-rc7[-mm[1|2]] and with all this kernels memory suspend doesn't
work, but on my previous 'acer' machine it worked quite good.

Today I have tested memory suspending feature on ubuntu 2.6.17 and
vanilla 2.6.20.
It doesn't work properly too with both this kernels.

Dan Kruchinin.
