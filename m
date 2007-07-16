Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbXGPUAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbXGPUAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761940AbXGPUAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:00:09 -0400
Received: from gw.goop.org ([64.81.55.164]:46166 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761403AbXGPUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:00:07 -0400
Message-ID: <469BCE0B.9030006@goop.org>
Date: Mon, 16 Jul 2007 12:59:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Len Brown <lenb@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 6/7] Add common orderly_poweroff()
References: <20070510235708.155502000@goop.org>	<20070511000028.446470000@goop.org> <20070716125223.249a6914.akpm@linux-foundation.org>
In-Reply-To: <20070716125223.249a6914.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 10 May 2007 16:57:14 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Various pieces of code around the kernel want to be able to trigger an
>> orderly poweroff.  This pulls them together into a single
>> implementation.
>>
>> By default the poweroff command is /sbin/poweroff, but it can be set
>> via sysctl: kernel/poweroff_cmd.  This is split at whitespace, so it
>> can include command-line arguments.
>>
>> This patch replaces four other instances of invoking either "poweroff"
>> or "shutdown -h now": one sparc64, two sbus drivers, and acpi thermal
>> management.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> Acked-by: Len Brown <lenb@kernel.org>
>> Cc: Chris Wright <chrisw@sous-sol.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Andi Kleen <ak@suse.de>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: David S. Miller <davem@davemloft.net>
>>
>> ---
>>  arch/sparc64/kernel/power.c     |   40 +-------------------------
>>  drivers/acpi/thermal.c          |   24 +---------------
>>  drivers/sbus/char/bbc_envctrl.c |    5 +--
>>  drivers/sbus/char/envctrl.c     |    7 +---
>>  include/linux/reboot.h          |    5 +++
>>  include/linux/sysctl.h          |    1 
>>  kernel/sys.c                    |   58 +++++++++++++++++++++++++++++++++++++++
>>  kernel/sysctl.c                 |   10 ++++++
>>     
>
> I'm not sure how this ended up in the x86 tree
> (ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/add-common-orderly_poweroff),
> but recent changes in arch/sparc64/kernel/power.c have broken it.
>   

I just sent the same mail to Dave - sorry, forgot to cc: you.  It's 
there because I added it as a prereq for Xen.  I'm planning on 
submitting it later today, ideally once we've sorted this out.

For reference, the patches I'm planning on submitting are:

Subject: add kstrndup
Subject: add argv_split()
Subject: usermodehelper: split setup from execution
Subject: Add common orderly_poweroff()
Subject: usermodehelper: Tidy up waiting
Subject: use elfnote.h to generate vsyscall notes.
Subject: paravirt: add an "mm" argument to alloc_pt
Subject: paravirt: add a hook for once the allocator is ready
Subject: paravirt: increase IRQ limit
Subject: paravirt: unstatic leave_mm
Subject: paravirt: unstatic smp_store_cpu_info
Subject: paravirt: make siblingmap functions visible
Subject: paravirt: export __supported_pte_mask
Subject: Allocate and free vmalloc areas
Subject: paravirt: helper to disable all IO space
Subject: Add a sched_clock paravirt_op
Subject: Add nosegneg capability to the vsyscall page notes
Subject: xen: Add Xen interface header files
Subject: xen: Core Xen implementation
Subject: xen: virtual mmu
Subject: xen: event channels
Subject: xen: time implementation
Subject: xen: configuration
Subject: xen: add pinned page flag
Subject: xen: Complete pagetable pinning
Subject: xen: ignore RW mapping of RO pages in pagetable_init
Subject: xen: Account for stolen time
Subject: xen: Implement sched_clock
Subject: xen: SMP guest support
Subject: xen: Add support for preemption
Subject: xen: lazy-mmu operations
Subject: xen: hack to prevent bad segment register reload
Subject: xen: use the hvc console infrastructure for Xen console
Subject: xen: Add 	grant table support
Subject: xen: add the Xenbus sysfs and virtual device hotplug driver
Subject: xen: add virtual block device driver.
Subject: xen: add virtual network device driver
Subject: xen: machine operations
Subject: xen: handle external requests for shutdown, reboot and sysrq
Subject: xen: Place vcpu_info structure into per-cpu memory
Subject: xen: Attempt to patch inline versions of common operations
Subject: xen: suppress abs symbol warnings for unused reloc pointers
Subject: xen: use iret directly when possible
Subject: xen: disable all non-virtual drivers

	J


