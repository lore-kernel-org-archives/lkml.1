Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbXJVWTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbXJVWTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXJVWTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:19:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34199 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXJVWTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:19:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Resume problems
Date: Tue, 23 Oct 2007 00:35:32 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org
References: <471CCC98.10101@googlemail.com>
In-Reply-To: <471CCC98.10101@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230035.32924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 22 October 2007 18:15, Gabriel C wrote:
> Hi all ,
> 
> I'm running current git + aic7xxx suspend patch from  http://bugzilla.kernel.org/show_bug.cgi?id=3062
> on a Dell Precision WorkStation 530 MT SMP box ( HT enabled ).
> 
> Suspend works fine but on resume I have some problems. 
> All CPU's but boot CPU won't come back , everything else seems fine.

Can you please try to disable HT and suspend?

> ...
> 
> Oct 22 15:02:28 lara [   49.618795] Enabling non-boot CPUs ...
> Oct 22 15:02:28 lara [   49.622211] PM: Adding info for No Bus:msr1
> Oct 22 15:02:28 lara [   49.622259] PM: Adding info for No Bus:cpu1
> Oct 22 15:02:28 lara [   49.622302] SMP alternatives: switching to SMP code
> Oct 22 15:02:28 lara [   49.623536] Booting processor 1/1 eip 3000
> Oct 22 15:02:28 lara [   54.638093] Not responding.
> Oct 22 15:02:28 lara [   54.638096] Inquiring remote APIC #1...
> Oct 22 15:02:28 lara [   54.638099] ... APIC #1 ID: failed
> Oct 22 15:02:28 lara [   54.638204] ... APIC #1 VERSION: failed
> Oct 22 15:02:28 lara [   54.638307] ... APIC #1 SPIV: failed
> Oct 22 15:02:28 lara [   54.638427] skipping cpu1, didn't come online
> Oct 22 15:02:28 lara [   54.638602] PM: Removing info for No Bus:msr1
> Oct 22 15:02:28 lara [   54.638643] PM: Removing info for No Bus:cpu1
> Oct 22 15:02:28 lara [   54.638678] Error taking CPU1 up: -5
> Oct 22 15:02:28 lara [   54.640908] PM: Adding info for No Bus:msr2
> Oct 22 15:02:28 lara [   54.640939] PM: Adding info for No Bus:cpu2
> Oct 22 15:02:28 lara [   54.640976] SMP alternatives: switching to SMP code
> Oct 22 15:02:28 lara [   54.641961] Booting processor 2/2 eip 3000
> Oct 22 15:02:28 lara [   59.656795] Not responding.
> Oct 22 15:02:28 lara [   59.656799] Inquiring remote APIC #2...
> Oct 22 15:02:28 lara [   59.656803] ... APIC #2 ID: failed
> Oct 22 15:02:28 lara [   59.656907] ... APIC #2 VERSION: failed
> Oct 22 15:02:28 lara [   59.657011] ... APIC #2 SPIV: failed
> Oct 22 15:02:28 lara [   59.657131] skipping cpu2, didn't come online
> Oct 22 15:02:28 lara [   59.657300] PM: Removing info for No Bus:msr2
> Oct 22 15:02:28 lara [   59.657343] PM: Removing info for No Bus:cpu2
> Oct 22 15:02:28 lara [   59.657379] Error taking CPU2 up: -5
> Oct 22 15:02:28 lara [   59.659605] PM: Adding info for No Bus:msr3
> Oct 22 15:02:28 lara [   59.659637] PM: Adding info for No Bus:cpu3
> Oct 22 15:02:28 lara [   59.659673] SMP alternatives: switching to SMP code
> Oct 22 15:02:28 lara [   59.660725] Booting processor 3/3 eip 3000
> Oct 22 15:02:28 lara [   64.675517] Not responding.
> Oct 22 15:02:28 lara [   64.675520] Inquiring remote APIC #3...
> Oct 22 15:02:28 lara [   64.675524] ... APIC #3 ID: failed
> Oct 22 15:02:28 lara [   64.675628] ... APIC #3 VERSION: failed
> Oct 22 15:02:28 lara [   64.675731] ... APIC #3 SPIV: failed
> Oct 22 15:02:28 lara [   64.675859] skipping cpu3, didn't come online
> Oct 22 15:02:28 lara [   64.676017] PM: Removing info for No Bus:msr3
> Oct 22 15:02:28 lara [   64.676059] PM: Removing info for No Bus:cpu3
> Oct 22 15:02:28 lara [   64.676092] Error taking CPU3 up: -5
> Oct 22 15:02:28 lara [   64.676326] evxfevnt-0079 [00] enable                : System is already in ACPI mode
> 
> ...
> 
> After I've played with a lot boot options I found out booting with ' acpi=ht ' will make the CPU's work again but now
> I have a problem on Suspend. Everything seems to just go down disks etc but the box itself is for some reason still on.
> So I've tested reboot=<> options with no luck.
> ( after waiting 5 minutes to be sure everything is really off I can just hit power button). On resume now everything is fine.
> 
> I'm not really sure what is wrong here acpi/hibernation/cpu-hotplug or a mix of all so I'm CC'ing linux-acpi as well.
> The only thing I noticed is the 'Breaking affinity for irq XX' on suspend without acpi=ht messages.
> 
> I can't even tell whatever other kernel versions are working because aic7xxx driver didn't got suspend support till now 
> ( or at least never worked here ). I know suspend worked fine on windows with that box.
> 
> There is my config and dmesg ( good and bad one ) :
> 
> 
> http://194.231.229.228/suspend/acpi=ht_working_dmesg.txt
> http://194.231.229.228/suspend/dmesg_broken_cpus_on_resume.txt
> http://194.231.229.228/suspend/config

Well, I think we have a problem with the CPU hotplug.

Can you try to offline-online CPUs (without suspending) and see if that works?

Greetings,
Rafael
