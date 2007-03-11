Return-Path: <linux-kernel-owner+w=401wt.eu-S933986AbXCKSlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbXCKSlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 14:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933987AbXCKSlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 14:41:04 -0400
Received: from www17.your-server.de ([213.133.104.17]:3793 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986AbXCKSlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 14:41:02 -0400
Message-ID: <45F44C60.10201@m3y3r.de>
Date: Sun, 11 Mar 2007 19:37:20 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: SwSusp to disk doesn't work - Try 2
References: <45F44599.3060508@m3y3r.de> <200703111926.20183.rjw@sisk.pl>
In-Reply-To: <200703111926.20183.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
>
> Could you please put some printk()s in kernel/cpu.c:_cpu_up() to see where
> it gets stuck?  I bet one of the notifiers goes to sleep (cpufreq, maybe).
>   
Here we go (ok. i forgot __FUNCTION__ ...):

Mar 11 19:31:33 [kernel] ac ACPI0003:00: freeze
Mar 11 19:31:33 [kernel] acpi device:00: freeze
Mar 11 19:31:33 [kernel] processor ACPI0007:01: freeze
Mar 11 19:31:33 [kernel] processor ACPI0007:00: freeze
Mar 11 19:31:33 [kernel] button button_power:00: freeze
Mar 11 19:31:33 [kernel] acpi acpi_system:00: freeze
Mar 11 19:31:33 [kernel] Disabling non-boot CPUs ...
Mar 11 19:31:33 [kernel] kvm: disabling virtualization on CPU1
Mar 11 19:31:33 [kernel] CPU 1 is now offline
Mar 11 19:31:33 [kernel] SMP alternatives: switching to UP code
Mar 11 19:31:33 [kernel] PM: Removing info for No Bus:cpu1
Mar 11 19:31:33 [kernel] PM: Removing info for No Bus:msr1
Mar 11 19:31:33 [kernel] CPU1 is down
Mar 11 19:31:33 [kernel] swsusp debug: Waiting for 5 seconds.
Mar 11 19:31:33 [kernel] Enabling non-boot CPUs ...
Mar 11 19:31:33 [kernel] <NULL>: before notifier CPU_UP_PREPARE.

Hung here.

Mar 11 19:31:33 [kernel] <NULL>: after notifier CPU_UP_PREPARE.
Mar 11 19:31:33 [kernel] SMP alternatives: switching to SMP code
Mar 11 19:31:33 [kernel] Booting processor 1/1 eip 3000
Mar 11 19:31:33 [kernel] CPU 1 irqstacks, hard=c0388000 soft=c0386000
Mar 11 19:31:33 [kernel] Initializing CPU#1
Mar 11 19:31:33 [kernel] Calibrating delay using timer specific 
routine.. 3663.72 BogoMIPS (lpj=6103555)
Mar 11 19:31:33 [kernel] CPU: After generic identify, caps: bfe9fbff 
00100000 00000000 00000000 0000c1a9 00000000 00000000
Mar 11 19:31:33 [kernel] monitor/mwait feature present.
Mar 11 19:31:33 [kernel] CPU: L1 I cache: 32K, L1 D cache: 32K
Mar 11 19:31:33 [kernel] CPU: L2 cache: 2048K
Mar 11 19:31:33 [kernel] CPU: Physical Processor ID: 0
Mar 11 19:31:33 [kernel] CPU: Processor Core ID: 1
Mar 11 19:31:33 [kernel] CPU: After all inits, caps: bfe9fbff 00100000 
00000000 00002940 0000c1a9 00000000 00000000
Mar 11 19:31:33 [kernel] CPU1: Intel Genuine Intel(R) CPU           
T2400  @ 1.83GHz stepping 08
Mar 11 19:31:33 [kernel] <NULL>: after __cpu_up
Mar 11 19:31:33 [kernel] <NULL>: before notifier CPU_ONLINE.
Mar 11 19:31:33 [kernel] kvm: enabling virtualization on CPU1
Mar 11 19:31:33 [kernel] Switched to high resolution mode on CPU 1
Mar 11 19:31:33 [kernel] PM: Adding info for No Bus:cpu1
Mar 11 19:31:33 [kernel] PM: Adding info for No Bus:msr1
Mar 11 19:31:33 [kernel] <NULL>: after notifier CPU_ONLINE.
Mar 11 19:31:33 [kernel] CPU1 is up
Mar 11 19:31:33 [kernel] acpi acpi_system:00: resuming
Mar 11 19:31:33 [kernel] button button_power:00: resuming
Mar 11 19:31:33 [kernel] processor ACPI0007:00: resuming
Mar 11 19:31:33 [kernel] processor ACPI0007:01: resuming

