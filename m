Return-Path: <linux-kernel-owner+w=401wt.eu-S1759779AbYERWPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbYERWPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYERWP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:15:29 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:36580 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759570AbYERWP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:15:27 -0400
Message-ID: <4830AA79.3020203@gawab.com>
Date: Sun, 18 May 2008 15:15:21 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: lkml <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [regression bisected] HR-timers bug >=2.6.25
References: <482C8FD6.10808@gawab.com>	 <alpine.LFD.1.10.0805160909450.3255@apollo.tec.linutronix.de>	 <1210922458.7886.14.camel@twins>  <482DC3B2.3040907@gawab.com> <1210959116.6524.26.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1210959116.6524.26.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> those can be obtained by adding:
>
>   nmi_watchdog=[12]
>
> to the kernel boot parameters - it depends a bit on the hardware which
> of the two choices works best, just start with 1 and if that doesn't
> work try 2.
>
> This enabled the NMI watchdog and that will print a backtrace when it
> times out after 30 or so seconds.
I got netconsole to work, but it stops logging. Below are the last few 
lines of output:

> ACPI: device:25 is registered as cooling_device2
> input: Video Bus as 
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21/device:22/input/input4
> phy0: Selected rate control algorithm 'iwl-3945-rs'
> ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> ACPI: device:2a is registered as cooling_device3
> input: Video Bus as 
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:27/input/input5
> ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
> input: Video Bus as 
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2c/input/input6
> ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
> ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
> PCI: Setting latency timer of device 0000:00:1b.0 to 64
> ACPI: PCI interrupt for device 0000:0b:00.0 disabled
> Synaptics Touchpad, model: 1, fw: 6.2, id: 0x180b1, caps: 
> 0xa04713/0x200000
> input: SynPS/2 Synaptics TouchPad as 
> /devices/platform/i8042/serio1/input/input7
> dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> fuse init (API version 7.9)
I do get several of the following after several minuets
> trying to get vblank count for disabled pipe 0

Even when I got the screen to "fade" out, I never got anything more. I 
guess it doesn't hang the kernel. It just must be a different timing 
problem related to usplash/xorg which is exposed by the scheduler timing 
changes since around that one commit that I found by git bisect. It does 
seem to be a very weird problem.

Any ideas on how to help the xorg intel driver developers pinpoint the 
problem?

Justin

