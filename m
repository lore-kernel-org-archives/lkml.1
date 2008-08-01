Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbYHAVGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbYHAVGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758404AbYHAVF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:05:59 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:54249 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYHAVF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:05:57 -0400
Date: Fri, 01 Aug 2008 17:05:44 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Ottawa Linux Power Management Summit, July 22, 2008 - Minutes
In-reply-to: <alpine.LFD.1.10.0807260205300.24819@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Linux Power Management List <linux-pm@lists.osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.1.10.0808011704490.3011@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <alpine.LFD.1.10.0807260205300.24819@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Linux Power Management "mini-summit" was held on July 22, 2008,
immediately preceding the Ottawa Linux Symposium (OLS).

Thanks to OLS for supplying the facilities,
and thanks to Hewlett Packard for sponsoring food.

We followed the process we used in 2007.
The invitation to the meeting was open --
sent to linux-pm@lists.linux-foundation.org.
Agenda topics were nominated on the list, and
the attendees formed the agenda by consensus
at the start of the session.

Attendees
---------
Pictured (left to right):
http://userweb.kernel.org/~lenb/Linux-PM-mini-summit-2008.jpg

Magnus Damm <magnus.damm@gmail.com>
        SH clock framework
Kai Svahn <kai.svahn@nokia.com>
        Nokia n800 product line
Matt Domsch <Matt_Domsch@dell.com>
        Server Power Management, Dell CTO Office
Tim Bird <tim.bird@am.sony.com>
        CELF, Sony Embedded
Paul Mundt <lethal@linux-sh.org>
        SH Maintainer
Jarod Wilson <jwilson@redhat.com>
        Red Hat cpufreq
Dipankar Sarma <dipankar@in.ibm.com>
        IBM, Server Power Management - RCU fame
Len Brown <len.brown@intel.com>
        Intel, ACPI and Suspend Maintainer
Gautham R Shenoy <ego@in.ibm.com>
        IBM, Server Power Management
Richard Woodruff <r-woodruff2@ti.com>
        Texas Instruments, Embedded, OMAP
Alan Stern <stern@rowland.harvard.edu>
        USB Maintainer
Rafael J. Wysocki <rjw@sisk.pl>
        Linux Kernel PM - Hibernate and Suspend Maintainer
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
        IBM Server Power Management

not in photo:

Sujith Thomas <sujith.thomas@intel.com>,
        Intel Ultra-Mobile Group
Hiroyuki Machida <Hiroyuki.Mach@gmail.com>
        Sony Embedded

Linux Power Management on OMAP3
-------------------------------

Richard Woodruff (Texas Instruments) presented highlights
from his recent CELF presentation:

http://www.celinux.org/elc08_presentations/TI_OMAP3430_Linux_PM_reference.ppt

Richard enables TI processors during hardware development
via emulation and simulation.
TI's goal is to be prepared for high-level use cases at power-on.

OMAP3 is sampling today, customers have prototypes.
The OMAP3 Technical Reference Manual is now public.
http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?templateId=6123&navigationId=12667 (SWPU114I_PrelimFinalEPDF_06_10_2008.pdf)

OMAP3430 Open Source targeted development boards:
Labrador available to public ~$500 - runs android etc.
Beagle board available to public ~$150

Current efforts focused on OMAP3, which is targeted
at a broader marketplace than OMAP2.

TI 65nm, 45nm silicon leakage has increased,
so SW power management is even more critical than in OMAP2.
In particular aggressive use of software-off mode is necessary.

Linux is shipped in many commercial OMAP cell phones,
but little code flow from these products flows upstream.
So it is promising that TI is both using and
contributing to very recent upstream software.

On OMAP3, he is working with Linux kernel 2.6.24 and later.

OMAP3 runs CPUIDLE.  OMAP defines 6 idle-states,
and makes use of the Bus-Master check to disqualify
some states at run-time based on OMAP3 hardware.
However, he reports the CPUIDLE bug that if target
is avoided due to BM activity the original
target state is still accounted the time.

OMAP3 runs CONFIG_NO_HZ=y.

OMAP3 runs powertop.  1.5 sec idle periods have been reported,
longer if slab accounting is modified.

OMAP3 runs cpufreq and its ondemand governor via
an OMAP3 cpufreq driver.

OMAP3 runs Linux's new pm_qos infrastructure.
Richard thinks it was a good idea to generalize latency framework
into pm_qos.  But expects it not to have a material effect on
basic course-grained systems that the says are often
rushed to market.  Rather it should benefit mainly
highly optimized systems.

Re: resume latency requirement
Richard sees a less than ~30ms requirement for exiting off mode
to handle limited modem buffering.

While suspend-to-RAM works on OMAP3, it isn't very useful
because device tree latency is too high.
Further, it currently resumes devices that do not
need to be resumed.

OMAP3 device drivers are smart enough to go idle
and save power by themselves w/o any global manager.

Finally, the clock framework tracks functional clocks
so power domains are powered off when possible.

CPUIDLE thresholds
they may be variable depending on P-state,
but CPUIDLE uses constant thresholds

CPUIDLE guesses wrong on interrupt-heavy workloads
doesn't choose idle-poll for 100% interrupt workload

CPUFREQ vs core/DSP dependency
Nokia wants to extend cpufreq to handle this case.
TI simply uses CPUFREQ as an input
which is overridden by the resource dependency code.

Run Time Device Power Management
--------------------------------

Last year we talked about PPM (Power Policy Manager)
and OHM (Open Hardware Manager) handling device
power policy states from user-space.
User-space would handle "dumb" devices, while
devices with "smart" drivers (eg. USB) would
autonomously recognize idle power savings opportunities
and act on their own.

Per above, Richard has abandoned the smart-user-space model
on OMAP3, favoring the smart-driver model which is necessary
to get the maximum benefit of off mode.
So TI is pushing for all devices on the SOC
to have drivers with intelligent autonomous
power management.

Snapshot Boot
-------------
Hiroyuki Machida (Sony) presented a summary of shapshot
boot, which was presented at OLS 2006.
This technique has been employed by other embedded
OSs for some time.  These devices tend to have flash drives.

shapshot boot eliminates:
        hibernate save image (re-use same image always)
        hibernate 1st kernel boot on resume
                by loading image directly from boot loader

file systems are mounted

Somebody observed that the kexec jump patches just went upstream.
However, this isn't an alternative to snapshot boot --
as it addresses the jump only, not the image load.

Runtime Power Management in the USB Subsystem
---------------------------------------------

Alan Stern (Harvard) presented a review of USB Power Management.

USB anatomy and lingo:

UHCI    original Intel implementation, dumb, requires 250ms timers
OHCI    smarter
EHCI    smarter and faster

The uhci-hcd (host controller driver) binds to the UHCI host controller.

USB "devices" hang off USB buses eg. flash drive or kbd.

However, a USB device may be split into multiple "interfaces".
eg. a kbd/mouse combination.  Thus while power management
acts on devices, there may be multiple interfaces per device
and thus multiple drivers per device.

Further, the USB host controller typically plugs into PCI on one side,
and USB bus on other appearing as 2 devices in sysfs!
So it is possible to suspend the USB part w/o suspending the PCI part.

Fortunately, most of power savings in USB is achieved
by suspending USB part anyway....

USB has 2 power states:
1. on
2. suspended (or unplugged)

Leave out (or unplugged).  It isn't really a state, even though the spec
lists it as one.

USB PM can not happen in atomic or interrupt context
b/c upstream hub involved.  Thus work queue used.

Initial USB PM Implementation:

Open = autoresume
Close = autosuspend

Worked well for USB scanner
Doesn't work for keyboard, which is always open.

Three possible suspend initiators:
1. pm-core: suspend
2. user initiated suspend request
3. suspend events from driver itself (autosuspend)

resume events may come from PM, user,
or remote device (eg use modem)

keyboards are problematic:
        suspend current is insufficient to drive caps-lock LED
	also, suspended keyboards tend to lose the first few
	keystrokes before they can be resumed.

plug-in (and un-plug) are wakeup events.
Oops, what if you unplug while suspending -- wakeup!

Autosuspend today depends on 2 parameters
1. is_used counter (open ++, close --)
2. timestamp of last device access

USB suspend latency: O(1ms)
USB resume latency: O(10ms)

sysfs interface:

/sys/.../power/autospend  = delay time
/sys/.../power/level = [on], auto, suspend

"on" is default b/c many USB devices don't
implement suspend properly.

set it to auto in HAL via whitelist
If no driver, auto will suspend device.

USB autosuspend techniques may be generic in future.

Alan prototyped auto-suspend on SCSI devices (logical units),
though should be at SCSI target level.
Need USB transport class for SCSI.

future:
an atomic API that can be be used from interrupt context.

issue:
if PCI host controller suspended and USB plugged in,
PME lost by kernel

PCI Run Time Power Management
-----------------------------

Rafael J. Wysocki (University of Warsaw) led a discussion
on Run Time power management specific to PCI.

issue:
wakeup of individual devices does not work.

existing framework is for _system_ suspend only.
Linux needs bridge driver to track dependencies of
subordinate bus etc.

PME handling for wakeup events:

Sometimes an ACPI GPE fires on the PME,
and it appears to be system specific.

bus/power/state ACPI needed to track bus power states.

device/power/state file
non-standard
useful for experiments
no agreement on bus and device class syntax for file contents.

We should restore a read-only bus-specific sysfs state file to USB and to PCI
Otherwise, even for smart devices, it is difficult or impossible for
user-space to even observe the device power state.

Memory power management
-----------------------

We discussed the challenges to memory power management
on servers.  Specifically, power-friendly interleaving
and the inability to migrate/free pages used by the kernel.

HSuperH may benefit soonest here b/c
not stopped by interleaving issue.
NUMA memory node for accounting.

Paul Mundt, using on SH
needs to be dynamic b/c cores turned on/off dynamically.

This is a common requirement between embedded and server platform
Consensus was to work on a common framework for page
placement based on frequency of reference.

Physical address to memory module (DIMM) information needs to be
exported by the platform to get started on any memory PM techniques.
Currently there is no information about fine grain memory topology
except for NUMA systems at node level.


Server Power Management
-----------------------
Dipankar Sarma (IBM) and Vaidyanathan Srinivasan
presented some observations on scheduling and C-states
on multi-socket servers.

"CPU consolidation" -- the strategy of grouping a
partially idle workload on fewer sockets to allow
the other sockets to go totally idle.

CPU hot plug
        ~1sec resume deemed large & heavyweight

CPUIDLE & PM_QOS & irq_balance & sched_mc
can conflict are system-wide on a big SMP,
this can waste power.

Specifically PM_QOS is system-wide and in the long run we may
want to have different policies for different sets of CPUs in
an SMP server.

PM QoS infrastructure needs to be granular.

Richard mentioned that timer and tick coalescing help in embedded
platforms. It may help on server and vitalized environments also.

logical CPU numbers are (physically) arbitrary,
yet irqbalance uses them.  Thus, it chooses
arbitrary physical processors for IRQ targets.
Hence irqbalance can work against sched_mc_power_savings
consolidation.

workloads to show this problem:

ebizzy (Val Henson) hacked to show issues.
kernbench
make -j2 on quad cores

sched_mc_power_savings=1 helps (Thank you Suresh)

see power vs performance RFC on lkml

per-task power nice deemed too high overhead for many tasks,
per-system seems realistic and sufficient.

sched_mc_power_savings=N

what if Asymmetric MP?

sched-mc=0 load balancer spread all
sched-mc=1 pull into fewest packages

if 3 jobs on dual socket dual core

wakeup biasing -- helps consolidate for low utilization

add_timer_on() used by ondemand
makes it difficult to pick up and move timers

queued_delayed_work_on() -- same problem.
Can't do power savings when these are used.

JAVA vs power
not "well behaved" -- lots of locking chatter
but JAVA is fact of life on web servers.
Java applications by nature generate a lot of wakeups. We need to
look at JVM and java apps from this angle and see if something
can be done to reduce those.

Accounting vs CPUFREQ
---------------------

Two issues:
1. charge back
        wall-clock vs cycle count
2. capacity planning & workload management

need better granularity than jiffies
(sys/tasks/utime)
need APERF/MPERF average to qualify idle time
ideally need data per task

Powerpc has scaled accounting infrastructure via task stats
        should we hook tools/utilities to it?
        videy proposed patch for x86 to behave like power

The APERF/MPERF based scaled chargeback accounting patch is
in lkml - http://lkml.org/lkml/2008/5/26/154.

No easy solution for the CPU capacity accounting - this will
require more thinking.

powertop/tools discussion
-------------------------

Tim Bird asked if powertop was useful for embedded and
if other tools were useful.  Richard is finding powertop
useful on OMAP3 (and Richard also showed some very powerful
tracing tools to see where time goes).  We brainstormed
on ways to make powertop even more useful.

show stats per core?
ability to dig into problem application code?
Decided to take this discussion to IRC #powertop

powertop 1.11 seems to mis-behave when AC is removed --
the ACPI battery estimate decays and becomes huge
after a few minutes, before going away.

Virtualization PM implications
------------------------------

hosted virtualization model (KVM, UML) get power management for free
hypervisor virtualization model (Xen) gets to re-implement Linux

Xen on NUMA box -- what info to export to guest?
sched_mc capability for Xen?

hard binding of guests to HW in use today

ie. same situation as last year.

The hard binding should change to dynamic binding for power in future.

suspend driver API update
-------------------------

Rafael J. Wysocki (University of Warsaw) described
the changes in driver callbacks for suspend.

They support a multi-pass suspend sequence, and split
callbacks w/ parameters into simpler callbacks w/o
parameters.


