Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYCMUPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYCMUPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYCMUPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:15:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:36697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYCMUPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:15:08 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: ACPI lockdep warning on boot, 2.6.25-rc5
Date: Thu, 13 Mar 2008 16:14:32 -0400
User-Agent: KMail/1.9.9
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <E1JZOGd-00057d-BU@pomaz-ex.szeredi.hu> <200803122301.17356.rjw@sisk.pl>
In-Reply-To: <200803122301.17356.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131614.33386.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Rafael J. Wysocki wrote:
> On Wednesday, 12 of March 2008, Miklos Szeredi wrote:
> > I don't know whether this is a problem in reality or not, but it does
> > interfere with debugging the rest of the kernel, since this turns off
> > lockdep at boottime.
> 
> Well, I think Venki should see it (CCed).
> 
> Thanks,
> Rafael
> 
>  
> > [    0.592488] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> > [    0.593038] ------------[ cut here ]------------
> > [    0.593267] WARNING: at kernel/lockdep.c:2035 trace_hardirqs_on+0xa0/0x115()
> > [    0.593596] Modules linked in:
> > [    0.593756] Pid: 0, comm: swapper Not tainted 2.6.25-rc5 #8
> > [    0.594017] 
> > [    0.594017] Call Trace:
> > [    0.594216]  [<ffffffff80231663>] warn_on_slowpath+0x58/0x6b
> > [    0.594495]  [<ffffffff80495966>] ? _spin_unlock_irqrestore+0x38/0x47
> > [    0.594809]  [<ffffffff80329a86>] ? acpi_os_release_lock+0x9/0xb
> > [    0.595103]  [<ffffffff80337840>] ? acpi_set_register+0x161/0x173
> > [    0.595401]  [<ffffffff8034c8d4>] ? acpi_processor_idle+0x1de/0x546
> > [    0.595706]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > [    0.595970]  [<ffffffff8024fc0e>] trace_hardirqs_on+0xa0/0x115
> > [    0.596049]  [<ffffffff8034c6f6>] ? acpi_processor_idle+0x0/0x546
> > [    0.596346]  [<ffffffff8034c8d4>] acpi_processor_idle+0x1de/0x546
> > [    0.596642]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > [    0.596912]  [<ffffffff8034c6f6>] ? acpi_processor_idle+0x0/0x546
> > [    0.597209]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > [    0.597472]  [<ffffffff8020a355>] cpu_idle+0xa7/0xd1
> > [    0.597717]  [<ffffffff80485fa1>] rest_init+0x55/0x57
> > [    0.597957]  [<ffffffff8062fb49>] start_kernel+0x29d/0x2a8
> > [    0.598215]  [<ffffffff8062f1da>] _sinittext+0x1da/0x1e1
> > [    0.598464] 
> > [    0.598546] ---[ end trace 778e504de7e3b1e3 ]---

Venki,

this reproduces in my t61 using Miklos' config (though i had to increase
the logbuff to catch it)

-Len

ACPI: SSDT 7D6E1B32, 02C4 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 7D6E1E7B, 085E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
kobject: 'cooling_device0' (ffff81007d195bf0): kobject_add_internal: parent: 'thermal', set: 'devices'
kobject: 'cooling_device0' (ffff81007d195bf0): kobject_uevent_env
kobject: 'cooling_device0' (ffff81007d195bf0): fill_kobj_path: path = '/class/thermal/cooling_device0'
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2035 trace_hardirqs_on+0xa0/0x115()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.25-rc5 #19

Call Trace:
 [<ffffffff80231687>] warn_on_slowpath+0x58/0x6b
 [<ffffffff80211d32>] ? native_sched_clock+0x50/0x6d
 [<ffffffff80329df3>] ? acpi_os_release_lock+0x9/0xb
 [<ffffffff8024e314>] ? lock_release_holdtime+0x45/0x4a
 [<ffffffff804964fd>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80329df3>] ? acpi_os_release_lock+0x9/0xb
 [<ffffffff80337c1f>] ? acpi_set_register+0x161/0x173
 [<ffffffff8034ccd4>] ? acpi_processor_idle+0x1f0/0x564
 [<ffffffff802501df>] trace_hardirqs_on+0xa0/0x115
 [<ffffffff8034cae4>] ? acpi_processor_idle+0x0/0x564
 [<ffffffff8034ccd4>] acpi_processor_idle+0x1f0/0x564
 [<ffffffff8034cae4>] ? acpi_processor_idle+0x0/0x564
 [<ffffffff8020a2f9>] cpu_idle+0xa4/0xce
 [<ffffffff804868f1>] rest_init+0x55/0x57
 [<ffffffff80635b3f>] start_kernel+0x29d/0x2a8
 [<ffffffff806351da>] _sinittext+0x1da/0x1e1

---[ end trace 778e504de7e3b1e3 ]---
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7D6E1A6A, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 7D6E1DF6, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
