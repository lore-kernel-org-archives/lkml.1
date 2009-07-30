Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbZG3WFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbZG3WFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZG3WFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:05:12 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:49036 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZG3WFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:05:09 -0400
Date: Thu, 30 Jul 2009 18:04:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linux Power Management List <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Montreal Linux Power Management Mini-Summit, July 13,
 2009 - Meeting Notes
In-reply-to: <alpine.LFD.2.00.0905211430220.4390@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0907301801240.17818@localhost.localdomain>
References: <alpine.LFD.2.00.0905211430220.4390@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Linux Power Management "mini-summit" was held on July 13th, 2009 -
on the first day of the Montreal Linux Symposium.

The Linux Symposium generously provided the facilities.

We repeated the process used in 2008: http://lwn.net/Articles/292447/

This year the meeting room was more accessible to the general attendees
of the Linux Symposium, so we had a fair number of "drop-ins".
25 signed in (listed below) plus a few more that came and went.
While this exceeded our cap of 20, the extra people did not hinder
our goal of focusing on a single discussion.

Attendees
---------
Len Brown - Intel - ACPI, SFI, Suspend co-Maintainer
Howard Alyne - Wind River
Pierre Phaneuf
Rafael J. Wysocki - SUSE Labs/Novell, U. Warsaw;  Hibernate and Suspend Maintainer
Per-Inge Tallberg - Ericsson
Rickard Andersson - Ericsson
Paul Mundt - Renesas - SH Maintainer
Magnus Damm - Renesas
Richard Wooodruff - Texas Instruments, OMAP
Stephen Hui - Zarlink
John Linville - Red Hat - Wireless LAN maintainer
Mark Brown - Marvell
Samuel Thibault - labri.fr
Lucas Nussbaun - inria.fr
Srinivas Sripathi - Motorola
Jason Baron - Red Hat
Aristu Rozanaski - Red Hat - RHEL6 kernel maintainer
Christopher Curtis - RipTide Software
Klaus Pedersen - Nokia
H. Peter Anvin - Intel - x86 maintainer
Ernest Szedeman - Nortel
Rick Leir - Leirtech
David Ahern - Cisco
Wending Wen - Rheinmetall
Jason Chagas - Marvell

Some of the attendees are in photos here:
http://picasaweb.google.com/lenb417/2009LinuxSymposium#

Agenda
------
	1. Review changes over the last year
	2. Survey tools, techniques, workloads
	3. Discuss upcoming work

Summary of Power Management kernel changes since last year
----------------------------------------------------------
ACPI Platform BIOS compatibility fixes
	ACPI ACPI_SCI_EN work-around
	resume memory corruption workarounds

hibernation:
	NVS memory handling
	handle overlapping memory zones

suspend/resume framework re-work (Rafael Wysocki)
	shipped suspend/resume RTC test feature
	ordering update/workaround
	simplified driver interface now available
		r8169 etc. drivers now using it
	PCI PM framework re-worked to simplify drivers
	graphics drivers better support suspend/resume
		i915 video restore, though has bugs
		ATI making progress, especially older cards
		NVIDIA - continues to trail
			no open source support for devices after 7200
power aware scheduling
	sched_mc_power_savings
	per-CPU timers fixed
clock_events_broadcast()
	bugs fixed
	(no longer needed on Westmere, which has always running LAPIC timer)
range timers shipped upstream
	eg. range timers used android to group around wireless

Intel shipped Nehalem (Core i7), which has always-running-TSC

Run Time power management is receiving some attention now.

OMAP (Richard Woodruff)
	2008 had TI releasing aggressive full-off reference code on public portals
		Customers snapshotted this code at different points
		Heavy support burden ramping variants into production
	Linux-OMAP community have been creating a cleaner version of aggressive PM
	code suitable for mainline kernel in Linux-OMAP PM branch.
		Hope of reduced burden for future kernels with mainlined code

ACPI sub-system (Len Brown)
	quality has been the focus for the last year.
	We continue to process about 300 bugs/year
	with 50-60 unresolved at any given time.

Wireless: (John Linville)
	mac-80211 is now suspend/resume aware
	IEEE-80211 has run-time power saving features
		eg. negotiate w/ access point
		starting to deploy in drivers
	beacon filtering (reduces CPU wake-ups)
	TX power upcoming in cfg-80211 API
		Nokia tablets pushing power savings

SH: (Paul Mundt)
	cpuidle integration
	using clocksources & clockevents from upstream
	can switch between timers depending on sleep states
	Hibernate & STR enabled, can test w/ RTC & kexec-jump-and-return

s390:
	added suspend/resume support

5-second boot on Atom netbook for Moblin
	async API is upstream
	Fedora Core-11 boots in 20 seconds on a notebook
		Down from 60 seconds in Fedora Core-10

PM-QOS shipped
	Documentation/power/pm_qos_interface.txt

Survey of Tools, Techniques, workloads for optimizing power management
----------------------------------------------------------------------
powertop
bootchart
bootgraph
CONFIG_POWER_TRACER=y
	LTT-lite
performance counters for energy coming
OMAP uses on-board instrumentation
suspend/resume debug I/F
Power meters:
O(100) Watts Up Pro; O(600) Extech; O(1000) Yokogawa
O(600) HP/Agilent 34401A
OMAP: measure per-power-plane w/ lab instruments
500mA vs uA range difficult to measure w/ precision
	multi-channel DAC - each channel calibrated to range

Workloads for measuring power:

handheld: no standard workloads
	however device vendors have internal benchmarks
	#1 idle
	#2 specific workloads
	#3 combination use-case

SpecPower benchmark for servers (only)

Energy Star for client computers
	idle only
	requires STR to be enabled by default
	Energy Star Server spec coming
	Future Energy Star wants to use energy benchmark
BAPCO
	MobileMark 2007 for Windows
	Apple joined, so expect something new to work also on Apple
	No Linux Distro representation
EEMBC
	released something or other...
BLTK (Battery Life Toolkit) for Linux
	http://www.lesswatts.org/projects/bltk/
	could use refresh
	could use handheld new workloads

Future plans for the PM development, kernel side
-------------------------------------------------
cpuidle C-states generalized to be platform idle states...
	platform driver can hide platform hooks into CPU power states

Runtime PM for Platform Devices.
	2.6.32 framework plan simmering
	SH running on top of prototype now
		context save/restore for power off power domain

	platform devices
		SH specific - Magnus
	IO devices
		eg PCI, USB - Alan Stern

	clock framework (started in ARM, now common on embedded)
		includes ref-counts/clock
		architecture specific implementation
		x86/ACPI system doesn't expose clock dependencies
			so unclear benefit to that arch

Run-time PM of I/O devices, from the PCI POV mostly
	ability to put device into D1/D2 (~200us) /D3 (10ms)

	wakeup: PCIe #PME plug-event via root port
	(PCI #PME is less well specified)

ACPI 4.0 adds D3hot
	Q: has an effect on _SD3?

Hibernate/suspend:

Axiom: we need more people fixing suspend/resume bugs

Suspend2 aka "Tux on Ice"
	Spring 2009 patch set to replace hibernate w/ TOI was
	deemed impractical by upstream community, which prefers
	an incremental approach.

	Since, Nigel has sent specific patches to Rafael along
	the lines of gradual cherry-picking that upstream needs.

	First example is patch to compress hibernation image
	which Rafael thinks can be integrated.

	TOI is able to save larger hibernate images due to
	how it manages memory.  This is a nice benefit and
	we'd like to see if we can do it upstream.

	patch review bandwidth limited
	
	1. image compression
	2. image saving performance
		currently very slow
	3. ability to use multiple devices to save images
		including multiple swaps, and regular files
	4. break the half-of-memory image limitation
	5. Image encryption (solution for keys is an issue)

	It would be great to have Nigel supporting upstream hibernate.

	TOI supports snapshot boot via "kiosk mode"

Hibernate & kexec
	kexec-jump is upstream (i386, SH, no x86_64)
		simplifies memory management of the "jumped to" code
		unclear if any other advantages.

kexec-crash-dump is useful
	can make an oops "look less scary" and be automatic

STR performance
	eliminate console switch
	async device resume

android submitted "auto-suspend" patches
	compromise between low-level and high-level suspend invocation policy.

cpuidle vs auto-suspend
	suspend is more "draconian", it stops timers etc for you.
	platform drivers in cpuidle can get to same place.

Android
	OHA -Open Handset Alliance
		controls android license(s)
		Android = access to app-store
Moblin
	shall support Android applications

OMAP & SH specifics

	UIO - user space codec etc. have no concept of PM
		could use clock framework extension
		(clock framework is accessible via debugfs if necessary)
	interrupt coalescing
	deferred I/O to LCD
		delay until regular (infrequent) update interval
		use x-damage API to track change to visible screen

SH running cpufreq on top of clock framework
	cpufreq has notifiers, clock framework does not

lightweight CPU hotplug
	IBM proposed "idle throttling" approach using scheduler
	Intel is proposing simple "forced idle" RT thread
	PeterZ likes neither implementation, but
	favors the IBM approach in the long term.

	SH SMP wants to run Itron on some cores...
	low latency transition is important

Memory Power Management
	Nokia project w/ U. in Brazil
		more pain than gain in memory offline prototype
	"partial RAM self refresh"

	page tables for kernel memory would allow
		moving kernel physical memory

	memory off-line incompatible with high-performance interleaving

	using NUMA node to segment memory allows tracking
		unused memory
	anti-fragmentation went upstream last year

	consensus: online/offline
		node granularity only

ACPI 4.0 was published
	Error Reporting extensions
	processor aggregator device (forced idle to save power)
	D3hot
	generalized fan support
	thermal extensions
	IPMI op-region

	Len will do a Linux ACPI 4.0 presentation this Fall

virtualization power management
	PM is still an after-though in the VMM space
		they have bigger problems

	KVM gets everything in Linux for free
		but could benefit from more info from the guests

	Xen gets to re-invent/port/re-implement everything in Linux

	VMMS have an easier time moving physical pages
		and thus doing memory power management

