Return-Path: <linux-kernel-owner+w=401wt.eu-S1764483AbYD3Sor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764483AbYD3Sor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760347AbYD3SoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:44:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759434AbYD3SoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:44:08 -0400
Date: Wed, 30 Apr 2008 11:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: torvalds@linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.26-rc0
Message-Id: <20080430114348.9ffd8dfc.akpm@linux-foundation.org>
In-Reply-To: <200804301420.11696.lenb@kernel.org>
References: <200804301420.11696.lenb@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 14:20:11 -0400
Len Brown <lenb@kernel.org> wrote:

> Hi Linus,
> 
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> This batch is a proper super-set of the pull request I made a week ago.
> It will update the files shown below.
> 


I have four acpi-related reports here from 2.6.25-rcX-mmY.  Can you please check
that they were addressed?  I don't recall seeing any feedback for any of
them.

Thanks.





From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: 2.6.25-rc8-mm2 -- initcall acpi_init+0x0/0x216() returned with preemption imbalance
Date: Fri, 11 Apr 2008 15:41:17 -0400

Is this indicative of a kernel or hardware problem?

[    0.279606] ACPI: Using IOAPIC for interrupt routing
[    0.279789] initcall acpi_init+0x0/0x216() returned with preemption imbalance
[    0.330789] ACPI: PCI Root Bridge [PCI0] (0000:00)



From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, "Len Brown" <lenb@kernel.org>
Subject: Re: 2.6.25-rc5-mm1
Date: Wed, 12 Mar 2008 09:14:55 +0800

Hi, I got the following lockdep warning:
(add linux-acpi to cc)

[    0.097109] ACPI: Core revision 20070126
[    0.097282] INFO: trying to register non-static key.
[    0.097355] the code is fine but needs lockdep annotation.
[    0.097428] turning off the locking correctness validator.
[    0.097503] Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1 #3
[    0.097578]  [<c0127bf8>] ? printk+0x18/0x20
[    0.097716]  [<c014b01c>] __lock_acquire+0x40c/0x760
[    0.097822]  [<c0181ba0>] ? alloc_debug_processing+0xb0/0x140
[    0.097959]  [<c014b969>] lock_acquire+0x79/0xb0
[    0.098063]  [<c0140204>] ? down_trylock+0x14/0x40
[    0.098197]  [<c03df9e8>] _spin_lock_irqsave+0x48/0xa0
[    0.098303]  [<c0140204>] ? down_trylock+0x14/0x40
[    0.098436]  [<c0140204>] down_trylock+0x14/0x40
[    0.098540]  [<c027c7ea>] acpi_os_wait_semaphore+0x3e/0xb9
[    0.098647]  [<c029263e>] acpi_ut_acquire_mutex+0x34/0x72
[    0.098753]  [<c0289ab1>] acpi_ns_root_initialize+0x19/0x250
[    0.098859]  [<c05453e6>] acpi_initialize_subsystem+0x42/0x64
[    0.098966]  [<c0545725>] acpi_early_init+0x50/0xef
[    0.099070]  [<c052b7f6>] start_kernel+0x1e6/0x250
[    0.099175]  [<c052b1a0>] ? unknown_bootoption+0x0/0x130
[    0.099310]  [<c052b008>] __init_begin+0x8/0x10
[    0.099414]  =======================



From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com
Subject: Re: 2.6.25-rc2-mm1 (build failure)
Date: Sat, 16 Feb 2008 21:32:25 -0800
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)

On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/

When SMP=n, x86_64 build gets:

arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
(.text+0xfd7f): undefined reference to `setup_trampoline'
make[1]: *** [.tmp_vmlinux1] Error 1




From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Date: Sat, 16 Feb 2008 21:16:03 -0800
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)

On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/

ACPI is enabled, but DMI=n.

linux-2.6.25-rc2-mm1/drivers/acpi/thermal.c: In function 'acpi_thermal_init':
linux-2.6.25-rc2-mm1/drivers/acpi/thermal.c:1792: error: 'thermal_dmi_table' undeclared (first use in this function)
linux-2.6.25-rc2-mm1/drivers/acpi/thermal.c:1792: error: (Each undeclared identifier is reported only once
linux-2.6.25-rc2-mm1/drivers/acpi/thermal.c:1792: error: for each function it appears in.)
make[3]: *** [drivers/acpi/thermal.o] Error 1

