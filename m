Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZHLWU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZHLWU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZHLWU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:20:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60196 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbZHLWUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:20:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: hibernate causes nobody cared on acpi irq
Date: Thu, 13 Aug 2009 00:21:34 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "Brown, Len" <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
References: <4A833CAD.5050209@gmail.com>
In-Reply-To: <4A833CAD.5050209@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908130021.34378.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Jiri Slaby wrote:
> Hi,

Hi,

> with current mmotm I get this while trying to hibernate from a system in
> qemu:

Does it trigger with the "core" test:

# echo core > /sys/power/pm_test
# echo disk > /sys/power/state

> PM: Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.00 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.03 seconds) done.
> PM: Preallocating image memory... done (allocated 7986 pages)
> PM: Allocated 31944 kbytes in 0.01 seconds (3194.40 MB/s)
> ACPI: Preparing to enter system sleep state S4
> PM: Saving platform NVS memory
> Disabling non-boot CPUs ...
> Cannot set affinity for irq 0
> CPU 1 is now offline
> SMP alternatives: switching to UP code
> CPU1 is down
> PM: Creating hibernation image:
> PM: Need to copy 7687 pages
> PM: Hibernation image created (7687 pages copied)
> Enabling non-boot CPUs ...
> SMP alternatives: switching to SMP code
> Booting processor 1 APIC 0x1 ip 0x6000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 5985.37 BogoMIPS
> (lpj=11970749)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 2048K
> mce: CPU supports 32 MCE banks
> CPU1: Intel QEMU Virtual CPU version 0.10.50 stepping 03
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Switched to high resolution mode on CPU 1
> CPU1 is up
> ACPI: Waking up from system sleep state S4
> irq 9: nobody cared (try booting with the "irqpoll" option)
> Pid: 497, comm: sh Tainted: G        W  2.6.31-rc5-mm1_64 #668
> Call Trace:
>  <IRQ>  [<ffffffff810815c6>] __report_bad_irq+0x26/0xa0
>  [<ffffffff810817d0>] note_interrupt+0x190/0x1d0
>  [<ffffffff81197e49>] ? acpi_irq+0x11/0x2c
>  [<ffffffff81081e17>] handle_fasteoi_irq+0xb7/0xe0
>  [<ffffffff8100e80d>] handle_irq+0x1d/0x30
>  [<ffffffff8100dd37>] do_IRQ+0x67/0xe0
>  [<ffffffff8100c813>] ret_from_intr+0x0/0xa
>  [<ffffffff8104543f>] ? __do_softirq+0x5f/0x130
>  [<ffffffff8102449d>] ? ack_apic_level+0x7d/0x1e0
>  [<ffffffff8100cf9c>] ? call_softirq+0x1c/0x30
>  [<ffffffff8100e7bd>] ? do_softirq+0x4d/0x80
>  [<ffffffff8104520d>] ? irq_exit+0x7d/0x90
>  [<ffffffff8100dd40>] ? do_IRQ+0x70/0xe0
>  [<ffffffff8100c813>] ? ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff81429c08>] ? _spin_unlock_irqrestore+0x8/0x10
>  [<ffffffff810830a3>] ? resume_device_irqs+0x73/0x90
>  [<ffffffff8123fb31>] ? dpm_resume_noirq+0xb1/0xc0
>  [<ffffffff8106edaa>] ? hibernation_snapshot+0x12a/0x230
>  [<ffffffff8106ef84>] ? hibernate+0xd4/0x1a0
>  [<ffffffff8106d88c>] ? state_store+0xec/0x100
>  [<ffffffff81168987>] ? kobj_attr_store+0x17/0x20
>  [<ffffffff81119190>] ? sysfs_write_file+0xe0/0x160
>  [<ffffffff810c1648>] ? vfs_write+0xb8/0x1a0
>  [<ffffffff8142c5a5>] ? do_page_fault+0x185/0x350
>  [<ffffffff810c1f4c>] ? sys_write+0x4c/0x80
>  [<ffffffff810cf1c0>] ? sys_fcntl+0x150/0x410
>  [<ffffffff8100beeb>] ? system_call_fastpath+0x16/0x1b
> handlers:
> [<ffffffff81197e38>] (acpi_irq+0x0/0x2c)
> Disabling IRQ #9
> 
> I use this hunk to prevent bh enablement btw.:
> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index c1f64e6..bc5368d 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -80,17 +80,15 @@ void load_debug_registers(void)
>         unsigned long flags;
>         struct task_struct *tsk = current;
> 
> -       spin_lock_bh(&hw_breakpoint_lock);
> +       spin_lock_irqsave(&hw_breakpoint_lock, flags);
> 
>         /* Prevent IPIs for new kernel breakpoint updates */
> -       local_irq_save(flags);
>         arch_update_kernel_hw_breakpoint(NULL);
> -       local_irq_restore(flags);
> 
>         if (test_tsk_thread_flag(tsk, TIF_DEBUG))
>                 arch_install_thread_hw_breakpoint(tsk);
> 
> -       spin_unlock_bh(&hw_breakpoint_lock);
> +       spin_unlock_irqrestore(&hw_breakpoint_lock, flags);
>  }
> 
>  /*

Rafael
