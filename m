Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZALSVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZALSVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZALSUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:20:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:40772 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbZALSUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:20:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,253,1231142400"; 
   d="scan'208";a="480995149"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>, Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 12 Jan 2009 10:17:30 -0800
Subject: RE: [git pull] x86 fixes
Thread-Topic: [git pull] x86 fixes
Thread-Index: Acl0DBd9CwI8W4MkTXqzHiPx/e1vSQA1RMDw
Message-ID: <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com>
References: <20090111143951.GA6666@elte.hu>
 <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com>
In-Reply-To: <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Torsten Kaiser
>Sent: Sunday, January 11, 2009 8:45 AM
>To: Ingo Molnar
>Cc: Linus Torvalds; linux-kernel@vger.kernel.org; Andrew 
>Morton; Thomas Gleixner; H. Peter Anvin
>Subject: Re: [git pull] x86 fixes
>
>On Sun, Jan 11, 2009 at 3:39 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> Linus,
>>
>> Please pull the latest x86-fixes-for-linus git tree from:
>>
>>   
>git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>.git x86-fixes-for-linus
>>
>> out-of-topic modifications in x86-fixes-for-linus:
>> --------------------------------------------------
>> include/asm-generic/pgtable.h      # e104ba3: x86 PAT: 
>change track_pfn_vma_new
>> mm/memory.c                        # e104ba3: x86 PAT: 
>change track_pfn_vma_new
>>                                   # e61304a: x86 PAT: remove 
>PFNMAP type on tr
>>
>>  Thanks,
>>
>>        Ingo
>>
>> ------------------>
>> Andi Kleen (2):
>>      x86: hpet: allow force enable on ICH10 HPET
>>      x86: avoid theoretical vmalloc fault loop
>>
>> Jaswinder Singh Rajput (1):
>>      x86: fix mpparse.c build error on latest git
>>
>> Kyle McMartin (1):
>>      x86, mtrr: fix types used in userspace exported header
>>
>> Suresh Siddha (1):
>>      x86, pat: fix reserve_memtype() for legacy 1MB range
>>
>> venkatesh.pallipadi@intel.com (6):
>>      x86 PAT: remove PFNMAP type on track_pfn_vma_new() error
>>      x86 PAT: consolidate old memtype new memtype check into 
>a function
>>      x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
>>      x86 PAT: return compatible mapping to remap_pfn_range callers
>>      x86 PAT: ioremap_wc should take resource_size_t parameter
>>      x86 PAT: remove CPA WARN_ON for zero pte
>
>Something is (very) wrong with one(?) of these patches.
>
>After upgrading from 2.6.28 to 2.6.29-rc1 I lost direct rendering.
>Each time I tried to start a program that uses DRM I get this in the
>syslog and the programm falls back to mesa software rendering:
>Jan 11 13:32:31 treogen [   77.167977] X:3280 map pfn expected mapping
>type uncached-min
>us for e0000000-e7ff8000, got write-combining
>Jan 11 13:32:31 treogen [   77.173620] X:3280 freeing invalid memtype
>e0000000-e7ff8000
>Jan 11 13:34:51 treogen [  217.861668] glxinfo:3492 map pfn expected
>mapping type uncach
>ed-minus for e0000000-e7ff8000, got write-combining
>Jan 11 13:34:51 treogen [  217.867220] glxinfo:3492 freeing invalid
>memtype e0000000-e7f
>f8000
>Jan 11 13:35:23 treogen [  249.771043] glxinfo:3494 map pfn expected
>mapping type uncach
>ed-minus for e0000000-e7ff8000, got write-combining
>Jan 11 13:35:23 treogen [  249.776589] glxinfo:3494 freeing invalid
>memtype e0000000-e7f
>f8000
>
>Otherwise 2.6.29-rc1 worked for me. Even booting with 'fastboot' did
>not result in any problems, but it did cut the in-kernel-time down
>from ~12 sec to ~6 sec.
>
>Hoping to fix this memtype problem I applied the patch from the pull
>request to 29-rc1 and rebooted. Now the system completely locks up
>when X is trying to start.
>Via serial console I got this Oops:
>[   79.500149] BUG: unable to handle kernel NULL pointer dereference
>at 0000000000000003
>[   79.509240] IP: [<0000000000000003>] 0x3
>[   79.510002] PGD 0
>[   79.510002] Oops: 0010 [#1] SMP
>[   79.510002] last sysfs file:
>/sys/devices/pci0000:00/0000:00:0f.0/0000:01:00.0/enable
>[   79.510002] CPU 0
>[   79.510002] Modules linked in: w83792d tuner tea5767 tda8290
>tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
>tvaudio msp3400 bttv ir_common v4l2_common videodev v4l1_compat
>v4l2_compat_ioctl32 usbhid videobuf_dma_sg videobuf_core hid btcx_risc
>tveeprom sg pata_amd
>[   79.510002] Pid: 0, comm: swapper Not tainted 2.6.29-rc1 #2
>[   79.510002] RIP: 0010:[<0000000000000003>]  [<0000000000000003>] 0x3
>[   79.510002] RSP: 0018:ffffffff809a8b18  EFLAGS: 00010002
>[   79.510002] RAX: 0000000000000001 RBX: ffffffff00000000 
>RCX: 0000000000000000
>[   79.510002] RDX: 0000000000000001 RSI: 0000000000000000 
>RDI: ffffffff809a8ca8
>[   79.510002] RBP: ffffffff809a8b18 R08: 0000000000000001 
>R09: 0000000000000100
>[   79.510002] R10: ffffffff8026af40 R11: 00000000000068d8 
>R12: 0000000000000000
>[   79.510002] R13: ffff88007e4fd700 R14: ffff880028018d00 
>R15: ffffffff809a8aa8
>[   79.510002] FS:  00007ff217e406f0(0000) GS:ffffffff809b1040(0000)
>knlGS:0000000000000000
>[   79.510002] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>[   79.510002] CR2: 0000000000000003 CR3: 0000000000201000 
>CR4: 00000000000006e0
>[   79.510002] DR0: 0000000000000000 DR1: 0000000000000000 
>DR2: 0000000000000000
>[   79.510002] DR3: 0000000000000000 DR6: 00000000ffff4ff0 
>DR7: 0000000000000400
>[   79.510002] Process swapper (pid: 0, threadinfo ffffffff8087e000,
>task ffffffff807de360)
>[   79.510002] Stack:
>[   79.510002]  ffffffff809a8b68 ffffffff802389d7 0000000000000000
>ffffffff809a8b60
>[   79.510002]  0000000000000082 ffffffff8022a7a8 0000000000000000
>0000000000000001
>[   79.510002]  0000000000000060 ffffffff807de360 ffffffff809a8b78
>ffffffff80238b7d
>[   79.510002] Call Trace:
>[   79.510002] Call Trace:
>[   79.510002]  <IRQ> <0> [<ffffffff802389d7>] 
>try_to_wake_up+0x137/0x2d0
>[   79.510002]  [<ffffffff8022a7a8>] ? do_page_fault+0x368/0x970
>[   79.510002]  [<ffffffff80238b7d>] default_wake_function+0xd/0x10
>[   79.510002]  [<ffffffff8025a751>] autoremove_wake_function+0x11/0x40
>[   79.510002]  [<ffffffff804cc70f>] ? ata_scsi_qc_complete+0x1df/0x4c0
>[   79.510002]  [<ffffffff8065d1ef>] ? 
>_spin_unlock_irqrestore+0x2f/0x40
>[   79.510002]  [<ffffffff8026b02c>] ?
>generic_smp_call_function_interrupt+0xec/0x100
>[   79.510002]  [<ffffffff8065cddd>] ? 
>trace_hardirqs_off_thunk+0x3a/0x6c
>[   79.510002]  [<ffffffff8026af40>] ?
>generic_smp_call_function_interrupt+0x0/0x100
>[   79.510002]  [<ffffffff8026b02c>] ?
>generic_smp_call_function_interrupt+0xec/0x100
>[   79.510002]  [<ffffffff8065d54f>] ? page_fault+0x1f/0x30
>[   79.510002]  [<ffffffff8026b02c>] ?
>generic_smp_call_function_interrupt+0xec/0x100
>[   79.510002]  [<ffffffff8026af40>] ?
>generic_smp_call_function_interrupt+0x0/0x100
>[   79.510002]  [<ffffffff8024402c>] ? warn_slowpath+0x4c/0x130
>[   79.510002]  [<ffffffff804b8f85>] ? scsi_next_command+0x45/0x60
>[   79.510002]  [<ffffffff804b9bd6>] ? scsi_io_completion+0x376/0x4e0
>[   79.510002]  [<ffffffff804b2f6c>] ? scsi_finish_command+0xac/0xe0
>[   79.510002]  [<ffffffff804b9e08>] ? scsi_softirq_done+0xb8/0x140
>[   79.510002]  [<ffffffff8025d360>] ? __remove_hrtimer+0x40/0xa0
>[   79.510002]  [<ffffffff8026b02c>] ?
>generic_smp_call_function_interrupt+0xec/0x100
>[   79.510002]  [<ffffffff8021e54f>] ? 
>smp_call_function_interrupt+0x1f/0x30
>[   79.510002]  [<ffffffff8020c863>] ? 
>call_function_interrupt+0x13/0x20
>[   79.510002]  <EOI> <0>Code:  Bad RIP value.
>[   79.510002] RIP  [<0000000000000003>] 0x3
>[   79.510002]  RSP <ffffffff809a8b18>
>[   79.510002] CR2: 0000000000000003
>[   79.510002] ---[ end trace 99e686e29f771a49 ]---
>[   79.510002] Kernel panic - not syncing: Fatal exception in interrupt
>[   79.510002] ------------[ cut here ]------------
>
>last sysfs file: 
>/sys/devices/pci0000:00/0000:00:0f.0/0000:01:00.0/enable
>
>lspci -t:
>-[0000:00]-+-00.0
>           [snip]
>           +-0f.0-[0000:01]--+-00.0
>           |                 \-00.1
>lspci:
>00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express 
>bridge (rev a3)
>01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60
>[Radeon X300 (PCIE)]
>01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
>
>Userspace is xorg-server-1.5.3 with mesa-7.3_rc1 and 
>xf86-video-ati-6.9.0.
>With 2.6.28 this combination works for accelerated direct rendering.
>PAT was enabled on 2.6.28 and both vanilla 2.6.29-rc1 and the 
>patched -rc1.
>
>Just ask, if you need more information, or if you have a patch to try.
>

Torsten,

I don't seem to be able to reproduce this failure on my test systems..
What distribution are you using here? Can you send me the kernel config that you used.

Thanks,
Venki
