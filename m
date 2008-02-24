Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYBXXfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYBXXfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 18:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYBXXfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 18:35:21 -0500
Received: from simmts12-qfe0.srvr.bell.ca ([206.47.199.141]:56466 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbYBXXfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 18:35:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAPONwUecIvME/2dsb2JhbAAIih+Hf5dY
Message-ID: <47C1FF2E.4060600@gmail.com>
Date: Sun, 24 Feb 2008 19:35:10 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080214)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       peterz@infradead.org
Subject: Re: linux-next: Tree for Feb 24
References: <20080224162309.3e67dd22.sfr@canb.auug.org.au> <47C1B52B.3080104@gmail.com> <200802242100.46474.rjw@sisk.pl>
In-Reply-To: <200802242100.46474.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 24 of February 2008, Kevin Winchester wrote:
> 
>> Today was different - I attempted to suspend and resume from the console,
>> and the machine did not come back up.  I found the following in my log -
>> any help would be appreciated.
>>
>> Feb 24 13:59:56 alekhine kernel: [  456.497875] PM: Syncing filesystems ... done.
>> Feb 24 14:00:20 alekhine kernel: [  456.507273] Freezing user space processes ... (elapsed 0.00 seconds) done.
>> Feb 24 14:00:20 alekhine kernel: [  456.510447] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>> Feb 24 14:00:20 alekhine kernel: [  456.510754] ACPI: Preparing to enter system sleep state S3
>> Feb 24 14:00:20 alekhine kernel: [  456.612370] Suspending console(s)
>> Feb 24 14:00:20 alekhine kernel: [  456.616254] sd 3:0:0:0: [sda] Synchronizing SCSI cache
>> Feb 24 14:00:20 alekhine kernel: [  456.616521] sd 3:0:0:0: [sda] Stopping disk
>> Feb 24 14:00:20 alekhine kernel: [  456.618221] ACPI: PCI interrupt for device 0000:00:11.5 disabled
>> Feb 24 14:00:20 alekhine kernel: [  456.630296] ACPI: PCI interrupt for device 0000:00:10.4 disabled
>> Feb 24 14:00:20 alekhine kernel: [  456.641085] ACPI: PCI interrupt for device 0000:00:10.3 disabled
>> Feb 24 14:00:20 alekhine kernel: [  456.651877] ACPI: PCI interrupt for device 0000:00:10.2 disabled
>> Feb 24 14:00:20 alekhine kernel: [  456.662716] ACPI: PCI interrupt for device 0000:00:10.1 disabled
>> Feb 24 14:00:20 alekhine kernel: [  456.673550] ACPI: PCI interrupt for device 0000:00:10.0 disabled
>> Feb 24 14:00:20 alekhine kernel: [  456.684385] ACPI: PCI interrupt for device 0000:00:0f.1 disabled
>> Feb 24 14:00:20 alekhine kernel: [  456.695056] ACPI: PCI interrupt for device 0000:00:0f.0 disabled
>> Feb 24 14:00:20 alekhine kernel: [  456.705856] 5 locks held by bash/2929:
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  #0:  (&buffer->mutex){--..}, at: [<c018960c>] sysfs_write_file+0x25/0xe3
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  #1:  (pm_mutex){--..}, at: [<c0138c54>] enter_state+0xea/0x100
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  #2:  (pm_sleep_rwsem){----}, at: [<c023c4b8>] device_suspend+0x25/0x251
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  #3:  (&data->update_lock#2){--..}, at: [<c029cb2b>] abituguru_suspend+0x13/0x18
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  #4:  (&vptr->lock){++..}, at: [<c0244665>] velocity_suspend+0x37/0x302
>> Feb 24 14:00:20 alekhine kernel: [  456.705856] irq event stamp: 19374
>> Feb 24 14:00:20 alekhine kernel: [  456.705856] hardirqs last  enabled at (19373): [<c0326664>] __mutex_unlock_slowpath+0xd5/0xef
>> Feb 24 14:00:20 alekhine kernel: [  456.705856] hardirqs last disabled at (19374): [<c0327bca>] _spin_lock_irqsave+0xf/0x3c
>> Feb 24 14:00:20 alekhine kernel: [  456.705856] softirqs last  enabled at (18484): [<c011e6ba>] __do_softirq+0x99/0x9e
>> Feb 24 14:00:20 alekhine kernel: [  456.705856] softirqs last disabled at (18479): [<c0104f15>] do_softirq+0x58/0xa8
>> Feb 24 14:00:20 alekhine kernel: [  456.705856] Pid: 2929, comm: bash Not tainted 2.6.25-rc2-next-20080224 #58
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c01177c7>] __schedule_bug+0x58/0x5f
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0325b43>] schedule+0x67/0x3b3
> 
> Well, could you check what's at schedule+0x67, please?

Is this how I would do this?  I tried schedule+0x67, but it just showed me the beginning of profile_hit.

(gdb) l *(schedule+0x66)
0xc0325b42 is in schedule (kernel/sched.c:3836).
3831		 * Test if we are atomic. Since do_exit() needs to call into
3832		 * schedule() atomically, we ignore that path for now.
3833		 * Otherwise, whine if we are scheduling when we should not be.
3834		 */
3835		if (unlikely(in_atomic_preempt_off()) && unlikely(!prev->exit_state))
3836			__schedule_bug(prev);
3837	
3838		profile_hit(SCHED_PROFILING, __builtin_return_address(0));
3839	
3840		schedstat_inc(this_rq(), sched_count);

It appears that we are scheduling when we should not be...


> 
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0121c39>] ? __mod_timer+0x8d/0x98
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0326043>] schedule_timeout+0x73/0x91
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c012185c>] ? process_timeout+0x0/0xa
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0326075>] schedule_timeout_uninterruptible+0x14/0x16
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0121c54>] msleep+0x10/0x16
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c01e0e51>] pci_set_power_state+0x17f/0x200
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0244917>] velocity_suspend+0x2e9/0x302
> 
> velocity_suspend() seems to be at fault.

(gdb) l *(velocity_suspend+0x37)
0xc0244665 is in velocity_suspend (drivers/net/via-velocity.c:3399).
3394		if(!netif_running(vptr->dev))
3395			return 0;
3396	
3397		netif_device_detach(vptr->dev);
3398	
3399		spin_lock_irqsave(&vptr->lock, flags);
3400		pci_save_state(pdev);
3401	#ifdef ETHTOOL_GWOL
3402		if (vptr->flags & VELOCITY_FLAGS_WOL_ENABLED) {
3403			velocity_get_ip(vptr);
(gdb) 
3404			velocity_save_context(vptr, &vptr->context);
3405			velocity_shutdown(vptr);
3406			velocity_set_wol(vptr);
3407			pci_enable_wake(pdev, PCI_D3hot, 1);
3408			pci_set_power_state(pdev, PCI_D3hot);
3409		} else {
3410			velocity_save_context(vptr, &vptr->context);
3411			velocity_shutdown(vptr);
3412			pci_disable_device(pdev);
3413			pci_set_power_state(pdev, pci_choose_state(pdev, state));
(gdb) 
3414		}
3415	#else
3416		pci_set_power_state(pdev, pci_choose_state(pdev, state));
3417	#endif
3418		spin_unlock_irqrestore(&vptr->lock, flags);
3419		return 0;
3420	}

So velocity_suspend calls spin_lock_irqsave, and then pci_set_power_state which msleep()s.  Is that the root problem here? (I've added Ingo & Peter to the CC list since they may have some comments on the scheduler/lockdep parts of the trace).

> 
> At the moment I have to take care of some more urgent things, I'll have a look
> at it tomorrow.
> 
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0133854>] ? mark_held_locks+0x4e/0x66
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0326664>] ? __mutex_unlock_slowpath+0xd5/0xef
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c01339dd>] ? trace_hardirqs_on+0xe5/0x120
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c01e249e>] pci_device_suspend+0x1b/0x4b
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c023c625>] device_suspend+0x192/0x251
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0138a7a>] suspend_devices_and_enter+0x3d/0xe0
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0138c1c>] enter_state+0xb2/0x100
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0138cfe>] state_store+0x94/0xac
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0138c6a>] ? state_store+0x0/0xac
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c01d50c5>] kobj_attr_store+0x1a/0x22
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c018969f>] sysfs_write_file+0xb8/0xe3
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c01895e7>] ? sysfs_write_file+0x0/0xe3
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c01597d7>] vfs_write+0x88/0xf8
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0159c6e>] sys_write+0x3b/0x60
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  [<c0102bfa>] sysenter_past_esp+0x5f/0xa5
>> Feb 24 14:00:20 alekhine kernel: [  456.705856]  =======================
>> Feb 24 14:00:20 alekhine kernel: [  456.716732] 
>> Feb 24 14:00:20 alekhine kernel: [  456.716732] =================================
>> Feb 24 14:00:20 alekhine kernel: [  456.716732] [ INFO: inconsistent lock state ]
>> Feb 24 14:00:20 alekhine kernel: [  456.716732] 2.6.25-rc2-next-20080224 #58
>> Feb 24 14:00:20 alekhine kernel: [  456.716732] ---------------------------------
>> Feb 24 14:00:20 alekhine kernel: [  456.716732] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
>> Feb 24 14:00:20 alekhine kernel: [  456.716732] bash/2929 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> Feb 24 14:00:20 alekhine kernel: [  456.716732]  (&vptr->lock){++..}, at: [<c0244665>] velocity_suspend+0x37/0x302
>> Feb 24 14:00:20 alekhine kernel: [  456.716732] {in-hardirq-W} state was registered at:
>> Feb 24 14:00:20 alekhine kernel: [  456.716732]   [<c013416b>] __lock_acquire+0x3ac/0xb43
>> Feb 24 14:00:20 alekhine kernel: [  456.716732]   [<c0134963>] lock_acquire+0x61/0x7d
>> Feb 24 14:00:20 alekhine kernel: [  456.716732]   [<c0243940>] velocity_intr+0x24/0x579
>> Feb 24 14:00:20 alekhine kernel: [  456.716732]   [<c03279fb>] _spin_lock+0x23/0x32
>> Feb 24 14:00:20 alekhine kernel: [  456.716732]   [<c0243940>] velocity_intr+0x24/0x579
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]   [<c0243940>] velocity_intr+0x24/0x579
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]   [<c02ca5e1>] snd_via8233_interrupt+0xdc/0xe7
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]   [<c013a884>] handle_fasteoi_irq+0x95/0xab
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]   [<c01398b3>] handle_IRQ_event+0x1a/0x46
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]   [<c013a88d>] handle_fasteoi_irq+0x9e/0xab
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]   [<c013a7ef>] handle_fasteoi_irq+0x0/0xab
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]   [<c0105010>] do_IRQ+0xab/0xd4
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]   [<ffffffff>] 0xffffffff
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] irq event stamp: 19374
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] hardirqs last  enabled at (19373): [<c0326664>] __mutex_unlock_slowpath+0xd5/0xef
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] hardirqs last disabled at (19374): [<c0327bca>] _spin_lock_irqsave+0xf/0x3c
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] softirqs last  enabled at (18484): [<c011e6ba>] __do_softirq+0x99/0x9e
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] softirqs last disabled at (18479): [<c0104f15>] do_softirq+0x58/0xa8
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] 
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] other info that might help us debug this:
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] 5 locks held by bash/2929:
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  #0:  (&buffer->mutex){--..}, at: [<c018960c>] sysfs_write_file+0x25/0xe3
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  #1:  (pm_mutex){--..}, at: [<c0138c54>] enter_state+0xea/0x100
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  #2:  (pm_sleep_rwsem){----}, at: [<c023c4b8>] device_suspend+0x25/0x251
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  #3:  (&data->update_lock#2){--..}, at: [<c029cb2b>] abituguru_suspend+0x13/0x18
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  #4:  (&vptr->lock){++..}, at: [<c0244665>] velocity_suspend+0x37/0x302
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] 
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] stack backtrace:
>> Feb 24 14:00:20 alekhine kernel: [  456.716733] Pid: 2929, comm: bash Not tainted 2.6.25-rc2-next-20080224 #58
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0132d3b>] print_usage_bug+0x10d/0x11a
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c013361f>] mark_lock+0x1f1/0x3d8
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0133854>] mark_held_locks+0x4e/0x66
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0327ec3>] ? _spin_unlock_irq+0x22/0x42
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c01339c7>] trace_hardirqs_on+0xcf/0x120
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0327ec3>] _spin_unlock_irq+0x22/0x42
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0117322>] finish_task_switch+0x46/0x7d
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c01172dc>] ? finish_task_switch+0x0/0x7d
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0325e39>] schedule+0x35d/0x3b3
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0121c39>] ? __mod_timer+0x8d/0x98
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0326043>] schedule_timeout+0x73/0x91
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c012185c>] ? process_timeout+0x0/0xa
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0326075>] schedule_timeout_uninterruptible+0x14/0x16
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0121c54>] msleep+0x10/0x16
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c01e0e51>] pci_set_power_state+0x17f/0x200
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0244917>] velocity_suspend+0x2e9/0x302
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0133854>] ? mark_held_locks+0x4e/0x66
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0326664>] ? __mutex_unlock_slowpath+0xd5/0xef
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c01339dd>] ? trace_hardirqs_on+0xe5/0x120
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c01e249e>] pci_device_suspend+0x1b/0x4b
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c023c625>] device_suspend+0x192/0x251
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0138a7a>] suspend_devices_and_enter+0x3d/0xe0
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0138c1c>] enter_state+0xb2/0x100
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0138cfe>] state_store+0x94/0xac
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0138c6a>] ? state_store+0x0/0xac
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c01d50c5>] kobj_attr_store+0x1a/0x22
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c018969f>] sysfs_write_file+0xb8/0xe3
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c01895e7>] ? sysfs_write_file+0x0/0xe3
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c01597d7>] vfs_write+0x88/0xf8
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0159c6e>] sys_write+0x3b/0x60
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  [<c0102bfa>] sysenter_past_esp+0x5f/0xa5
>> Feb 24 14:00:20 alekhine kernel: [  456.716733]  =======================
>> Feb 24 14:00:20 alekhine kernel: [  456.729170] Intel machine check architecture supported.
>> Feb 24 14:00:20 alekhine kernel: [  456.729170] Intel machine check reporting enabled on CPU#0.
>> Feb 24 14:00:20 alekhine kernel: [  456.733181] Velocity is AUTO mode
>> Feb 24 14:00:20 alekhine kernel: [  456.733182] ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
>> Feb 24 14:00:20 alekhine kernel: [  456.733184] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
>> Feb 24 14:00:20 alekhine kernel: [  456.733185] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
>> Feb 24 14:00:20 alekhine kernel: [  456.733185] usb usb2: root hub lost power or was reset
>> Feb 24 14:00:20 alekhine kernel: [  456.744080] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
>> Feb 24 14:00:20 alekhine kernel: [  456.744080] usb usb3: root hub lost power or was reset
>> Feb 24 14:00:20 alekhine kernel: [  456.754997] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
>> Feb 24 14:00:20 alekhine kernel: [  456.754997] usb usb4: root hub lost power or was reset
>> Feb 24 14:00:20 alekhine kernel: [  456.765914] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
>> Feb 24 14:00:20 alekhine kernel: [  456.765914] usb usb5: root hub lost power or was reset
>> Feb 24 14:00:20 alekhine kernel: [  456.776818] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
>> Feb 24 14:00:20 alekhine kernel: [  456.787745] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
>> Feb 24 14:00:20 alekhine kernel: [  456.789881] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
>> Feb 24 14:00:20 alekhine kernel: [  456.789961] sd 3:0:0:0: [sda] Starting disk
>> Feb 24 14:00:20 alekhine kernel: [  457.031803] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
>> Feb 24 14:00:20 alekhine kernel: [  457.031803] ata3.01: ACPI cmd ef/03:42:00:00:00:b0 filtered out
>> Feb 24 14:00:20 alekhine kernel: [  457.185224] ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
>> Feb 24 14:00:20 alekhine kernel: [  457.185224] ata3.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
>> Feb 24 14:00:20 alekhine kernel: [  457.340841] ata3.00: configured for UDMA/33
>> Feb 24 14:00:20 alekhine kernel: [  457.528347] ata3.01: configured for UDMA/33
>> Feb 24 14:00:20 alekhine kernel: [  460.975795] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
>> Feb 24 14:00:20 alekhine kernel: [  460.975795] ata4.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
>> Feb 24 14:00:20 alekhine kernel: [  460.978040] ata4.00: configured for UDMA/100
>> Feb 24 14:00:20 alekhine kernel: [  460.981191] sd 3:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
>> Feb 24 14:00:20 alekhine kernel: [  460.981191] sd 3:0:0:0: [sda] Write Protect is off
>> Feb 24 14:00:20 alekhine kernel: [  460.981191] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> Feb 24 14:00:20 alekhine kernel: [  461.524370] Restarting tasks ... <6>usb 2-1: USB disconnect, address 2
>> Feb 24 14:00:20 alekhine kernel: [  461.569374] done.
>> Feb 24 14:00:21 alekhine kernel: [  461.755858] usb 2-1: new low speed USB device using uhci_hcd and address 4
>> Feb 24 14:00:21 alekhine kernel: [  461.915256] usb 2-1: configuration #1 chosen from 1 choice
>> Feb 24 14:00:21 alekhine kernel: [  461.955599] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.0/input/input5
>> Feb 24 14:00:21 alekhine kernel: [  461.979344] input: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:10.0-1
>> Feb 24 14:00:21 alekhine kernel: [  461.979553] usb 2-2: USB disconnect, address 3
>> Feb 24 14:00:21 alekhine kernel: [  462.236114] usb 2-2: new low speed USB device using uhci_hcd and address 5
>> Feb 24 14:00:21 alekhine kernel: [  462.405538] usb 2-2: configuration #1 chosen from 1 choice
>> Feb 24 14:00:21 alekhine kernel: [  462.439929] input: Microsoft Microsoft® Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input6
>> Feb 24 14:00:21 alekhine kernel: [  462.463834] input: USB HID v1.11 Keyboard [Microsoft Microsoft® Digital Media Pro Keyboard] on usb-0000:00:10.0-2
>> Feb 24 14:00:21 alekhine kernel: [  462.492181] input: Microsoft Microsoft® Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.1/input/input7
>> Feb 24 14:00:21 alekhine kernel: [  462.517592] input: USB HID v1.11 Device [Microsoft Microsoft® Digital Media Pro Keyboard] on usb-0000:00:10.0-2
