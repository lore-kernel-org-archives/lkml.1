Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbXCKSXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbXCKSXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933971AbXCKSXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 14:23:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40540 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933970AbXCKSXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 14:23:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: SwSusp to disk doesn't work - Try 2
Date: Sun, 11 Mar 2007 19:26:19 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <45F44599.3060508@m3y3r.de>
In-Reply-To: <45F44599.3060508@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111926.20183.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 March 2007 19:08, Thomas Meyer wrote:
> Suspend to disk doesn't work on my laptop.
> 
> The suspend seems to hang while enabling the non-boot cpus again.
> 
> with platform = "test" and state = "disk" i get this:
> "
> [cut]
> acpi device:02: freeze
> video video:00: freeze
> acpi device:01: freeze
> acpi PNP0C02:00: freeze
> pci_root PNP0A08:00: freeze
> button PNP0C0E:00: freeze
> button PNP0C0C:00: freeze
> acpi APP0002:00: freeze
> button PNP0C0D:00: freeze
> ac ACPI0003:00: freeze
> acpi device:00: freeze
> processor ACPI0007:01: freeze
> processor ACPI0007:00: freeze
> button button_power:00: freeze
> acpi acpi_system:00: freeze
> Disabling non-boot CPUs ...
> CPU 1 is now offline
> SMP alternatives: switching to UP code
> PM: Removing info for No Bus:cpu1
> PM: Removing info for No Bus:msr1
> CPU1 is down
> swsusp debug: Waiting for 5 seconds.
> Enabling non-boot CPUs ...
> 
> ----> Here the process hangs. But a fortunate coincidence showed me that 
> an acpi event continues the process (pressing the power off button a few 
> times... (2x - 4x)  ).

Hm, interesting.

> SMP alternatives: switching to SMP code
> Booting processor 1/1 eip 3000
> CPU 1 irqstacks, hard=c0389000 soft=c0387000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 3663.73 BogoMIPS 
> (lpj=6103576)
> CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 
> 0000c1a9 00000000 00000000
> monitor/mwait feature present.
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 2048K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 
> 00000000 00000000
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#1.
> CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
> PM: Adding info for No Bus:cpu1
> PM: Adding info for No Bus:msr1
> CPU1 is up
> acpi acpi_system:00: resuming
> button button_power:00: resuming
> processor ACPI0007:00: resuming
> processor ACPI0007:01: resuming
> acpi device:00: resuming
> ac ACPI0003:00: resuming
> button PNP0C0D:00: resuming
> acpi APP0002:00: resuming
> button PNP0C0C:00: resuming
> button PNP0C0E:00: resuming
> pci_root PNP0A08:00: resuming
> "
> 
> Any ideas?

Could you please put some printk()s in kernel/cpu.c:_cpu_up() to see where
it gets stuck?  I bet one of the notifiers goes to sleep (cpufreq, maybe).

Greetings,
Rafael
-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
