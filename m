Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbZIHThV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbZIHThV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZIHThU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:37:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58543 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbZIHThT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:37:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Bennee <kernel-hacker@bennee.com>
Subject: Re: Machine resumes straight after suspend to RAM (or disk)
Date: Tue, 8 Sep 2009 21:38:15 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <b2cdc9f30909081157r3087f707ve3a0cff77f46941a@mail.gmail.com>
In-Reply-To: <b2cdc9f30909081157r3087f707ve3a0cff77f46941a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909082138.15312.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 September 2009, Alex Bennee wrote:
> Hi,
> 
> I thought I'd enable suspend and resume on my desktop machine so I
> could save myself some time in the morning when I restart the machine.
> The machine is fairly standard Intel Core Duo based system (lspci
> attached). However when I execute pm-suspend (or Gentoo's own
> hibernate-script) the system does suspend but resumes immediately. To
> add insult to injury the ethernet doesn't come back properly and needs
> a reboot to reset it.
> 
> I've played about a little with the ACPI debug stuff but it's easy to
> overflow the dmesg buffer. The relevant section around the
> suspend/resume looks like:
> 
> [ 1025.178019] Disabling non-boot CPUs ...
> [ 1025.182071] kvm: disabling virtualization on CPU1
> [ 1025.227729] CPU 1 is now offline
> [ 1025.227731] SMP alternatives: switching to UP code
> [ 1025.232627] CPU0 attaching NULL sched-domain.
> [ 1025.232630] CPU1 attaching NULL sched-domain.
> [ 1025.232634] CPU0 attaching NULL sched-domain.
> [ 1025.232771] CPU1 is down
> [ 1025.233264] acpi_suspend_enter acpi_state=3
> [ 1025.233276] evgpeblk-0144 [ffff8800b70d8000] [05] ev_walk_gpe_list
>     : ----Entry
> [ 1025.233286] evgpeblk-0178 [ffff8800b70d8000] [05] ev_walk_gpe_list
>     : ----Exit- AE_OK
> [ 1025.233290] evgpeblk-0144 [ffff8800b70d8000] [05] ev_walk_gpe_list
>     : ----Entry
> [ 1025.233299] evgpeblk-0178 [ffff8800b70d8000] [05] ev_walk_gpe_list
>     : ----Exit- AE_OK
> [ 1025.233303] evgpeblk-0144 [ffff8800b70d8000] [05] ev_walk_gpe_list
>     : ----Entry
> [ 1025.233311] evgpeblk-0178 [ffff8800b70d8000] [05] ev_walk_gpe_list
>     : ----Exit- AE_OK
> [ 1025.233315] evgpeblk-0144 [ffff8800b70d8000] [05] ev_walk_gpe_list
>     : ----Entry
> [ 1025.233319] evgpeblk-0178 [ffff8800b70d8000] [05] ev_walk_gpe_list
>     : ----Exit- AE_OK
> [ 1025.233319] evxfevnt-0074 [ffff8800b70d8000] [05] enable
>     : ----Entry
> [ 1025.233319] evxfevnt-0086 [ffff8800b70d8000] [05] enable
>     : System is already in ACPI mode
> [ 1025.233319] evxfevnt-0101 [ffff8800b70d8000] [05] enable
>     : ----Exit- AE_OK
> [ 1025.233319] evxfevnt-0397 [ffff8800b70d8000] [05] clear_event
>     : ----Entry
> [ 1025.233319] evxfevnt-0413 [ffff8800b70d8000] [05] clear_event
>     : ----Exit- AE_OK
> [ 1025.233319] evxfevnt-0831 [ffff8800b70d8000] [05] disable_all_gpes
>     : ----Entry
> [ 1025.233319] evgpeblk-0144 [ffff8800b70d8000] [07] ev_walk_gpe_list
>     : ----Entry
> [ 1025.233319] evgpeblk-0178 [ffff8800b70d8000] [07] ev_walk_gpe_list
>     : ----Exit- AE_OK
> [ 1025.233319] evgpeblk-0144 [ffff8800b70d8000] [07] ev_walk_gpe_list
>     : ----Entry
> [ 1025.233319] evgpeblk-0178 [ffff8800b70d8000] [07] ev_walk_gpe_list
>     : ----Exit- AE_OK
> [ 1025.233319] evxfevnt-0841 [ffff8800b70d8000] [05] disable_all_gpes
>     : ----Exit- AE_OK
> [ 1025.233319] Back to C!
> [ 1025.233319] CPU0: Thermal LVT vector (0xfa) already installed
> [ 1025.233319] Enabling non-boot CPUs ...
> [ 1025.233319] SMP alternatives: switching to SMP code
> [ 1025.237548] Booting processor 1 APIC 0x1 ip 0x6000
> [ 1025.232536] Initializing CPU#1
> [ 1025.232536] Calibrating delay using timer specific routine..
> 4245.78 BogoMIPS (lpj=8491564)
> 
> Unfortunately the ACPI stuff is all Greek to me. If anyone wants
> additional debug information then please let me know.
> 
> So any ideas?

What's in /proc/acpi/wakeup after a clean boot?

Rafael
