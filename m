Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXFCVfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXFCVfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXFCVfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:35:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:57224 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXFCVfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=CVMP5h2Inp279HCawf92UVm9gEwgXjR2VDKyyoqguRwSr/f2mv50XZ0HvqH2+Ept7aPK8IwIjSZTfXwm9wiM/IC7e+IqdjONQj/witc4lSq59ZlILlpm2t5HN1I6PXvd++OkalzSQy3p3g3mrxhre7pUm1fNrPgo1kXQ+4QwcoY=
Date: Sun, 3 Jun 2007 23:34:32 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] Oops with KVM-27
Message-ID: <20070603213432.GA3075@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
my kernel just exploded :)

The host is running 2.6-git-current, with KVM modules from KVM-27
package. kernel is 32bit, SMP, with PREEMPT enabled, no HIGHMEM (but I'm
using CONFIG_VMSPLIT_3G_OPT=y). The CPU is a Core2 (hence I'm using
kvm-intel).
Guest was a Fedora7 setup DVD, which died somewhere during the
installation (anaconda was already active at that point). Bad news is
that I cannot reproduce the bug :|

This is the OOPS:

kvm: emulating exchange as write
------------[ cut here ]------------
kernel BUG at /root/kvm-27/kernel/mmu.c:276!
invalid opcode: 0000 [#1]
PREEMPT SMP 
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables rtc_core rtc_lib tun kvm_intel kvm radeon drm binfmt_misc nfs button cpufreq_stats cpufreq_userspace cpufreq_powersave cpufreq_conservative cls_u32 cls_route sch_sfq sch_cbq des cbc blkcipher sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ohci1394 snd intel_agp ieee1394 parport_pc atl1 uhci_hcd ehci_hcd i2c_i801 agpgart soundcore snd_page_alloc parport e100 usbcore mii dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    0
EIP:    0060:[<f24ad9b6>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22-rc3-libata-gf285e3d3-dirty #67)
EIP is at mmu_memory_cache_alloc+0xd/0x36 [kvm]
eax: 00000000   ebx: 00000000   ecx: db19f2f4   edx: 0000002c
esi: 00000322   edi: db19e528   ebp: 00003d1d   esp: ca73fc80
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process qemu (pid: 2680, ti=ca73f000 task=cc3160f0 task.ti=ca73f000)
Stack: f24aa0e2 00000000 db19e528 f24ae1eb db19f0b4 00000000 e21458e8 b129b4a0 
       db19f0b4 00003d1d 00000018 c0000000 f24ae3ea 00000002 00000000 00000000 
       00000000 00000003 db19f0b4 00003d1d 00000003 00000003 f24ae4b6 db19f0b4 
Call Trace:
 [<f24aa0e2>] gfn_to_page+0x14/0x27 [kvm]
 [<f24ae1eb>] kvm_mmu_get_page+0x1b2/0x31c [kvm]
 [<f24ae3ea>] mmu_alloc_roots+0x95/0xf0 [kvm]
 [<f24ae4b6>] paging_new_cr3+0x21/0x48 [kvm]
 [<f24aab16>] set_cr3+0x82/0x8c [kvm]
 [<f249b51d>] handle_cr+0xf8/0x253 [kvm_intel]
 [<f249b1b5>] handle_exception+0x120/0x208 [kvm_intel]
 [<f249af6c>] vmx_vcpu_run+0x59d/0x6c6 [kvm_intel]
 [<b02f2bb6>] __mutex_lock_slowpath+0x259/0x261
 [<f2499f34>] vmx_vcpu_load+0x2a/0xcc [kvm_intel]
 [<f24ac7d1>] kvm_vcpu_ioctl+0x29a/0xcff [kvm]
 [<b0294ea5>] sock_common_recvmsg+0x3e/0x54
 [<b029396f>] sock_recvmsg+0xcf/0xe8
 [<b0293a44>] sock_sendmsg+0xbc/0xd4
 [<b0131c35>] autoremove_wake_function+0x0/0x35
 [<b0172133>] core_sys_select+0x234/0x30f
 [<b0103189>] setup_sigcontext+0x105/0x189
 [<b02f41cf>] _spin_unlock_irq+0x20/0x41
 [<b013b1ee>] trace_hardirqs_on+0x11a/0x13d
 [<b0103a56>] do_notify_resume+0x5d1/0x611
 [<b02f41da>] _spin_unlock_irq+0x2b/0x41
 [<b01039b4>] do_notify_resume+0x52f/0x611
 [<b010898b>] convert_fxsr_from_user+0x26/0xe6
 [<f24ac537>] kvm_vcpu_ioctl+0x0/0xcff [kvm]
 [<b0171007>] do_ioctl+0x1f/0x62
 [<b0171281>] vfs_ioctl+0x237/0x249
 [<b01712c6>] sys_ioctl+0x33/0x4d
 [<b0103e78>] syscall_call+0x7/0xb
 =======================
Code: 01 00 00 e8 ce ff ff ff 8d 83 ec 01 00 00 81 c3 40 02 00 00 e8 bd ff ff ff 89 d8 5b eb b8 57 89 c1 53 83 ec 04 8b 00 85 c0 75 04 <0f> 0b eb fe 48 8b 5c 81 04 89 01 89 d1 31 c0 c1 e9 02 89 df f3 
EIP: [<f24ad9b6>] mmu_memory_cache_alloc+0xd/0x36 [kvm] SS:ESP 0068:ca73fc80
note: qemu[2680] exited with preempt_count 2
BUG: sleeping function called from invalid context at /home/kronos/src/linux-2.6.git/kernel/rwsem.c:20
in_atomic():1, irqs_disabled():0
INFO: lockdep is turned off.
 [<b01348ca>] down_read+0x15/0x49
 [<b013e800>] futex_wake+0x19/0xb3
 [<b013e919>] do_futex+0x7f/0xaad
 [<b01caa47>] vsnprintf+0x450/0x48c
 [<b02f4197>] _spin_unlock_irqrestore+0x40/0x58
 [<b01218f0>] release_console_sem+0x1a0/0x1b9
 [<b0121d88>] vprintk+0x2b7/0x305
 [<b011c716>] try_to_wake_up+0x325/0x32f
 [<b013f40f>] sys_futex+0xc8/0xda
 [<b011f578>] mm_release+0x81/0x87
 [<b0122cf7>] exit_mm+0x13/0xd6
 [<b012410a>] do_exit+0x1bc/0x69b
 [<b01053f1>] die+0x1e5/0x211
 [<b0105784>] do_invalid_op+0x0/0x8a
 [<b0105805>] do_invalid_op+0x81/0x8a
 [<f24ad9b6>] mmu_memory_cache_alloc+0xd/0x36 [kvm]
 [<f24ae61f>] page_header_update_slot+0x1e/0x4b [kvm]
 [<f24ae8b5>] paging32_set_pte_common+0x269/0x2a1 [kvm]
 [<b02f4432>] error_code+0x72/0x78
 [<f24ad9b6>] mmu_memory_cache_alloc+0xd/0x36 [kvm]
 [<f24aa0e2>] gfn_to_page+0x14/0x27 [kvm]
 [<f24ae1eb>] kvm_mmu_get_page+0x1b2/0x31c [kvm]
 [<f24ae3ea>] mmu_alloc_roots+0x95/0xf0 [kvm]
 [<f24ae4b6>] paging_new_cr3+0x21/0x48 [kvm]
 [<f24aab16>] set_cr3+0x82/0x8c [kvm]
 [<f249b51d>] handle_cr+0xf8/0x253 [kvm_intel]
 [<f249b1b5>] handle_exception+0x120/0x208 [kvm_intel]
 [<f249af6c>] vmx_vcpu_run+0x59d/0x6c6 [kvm_intel]
 [<b02f2bb6>] __mutex_lock_slowpath+0x259/0x261
 [<f2499f34>] vmx_vcpu_load+0x2a/0xcc [kvm_intel]
 [<f24ac7d1>] kvm_vcpu_ioctl+0x29a/0xcff [kvm]
 [<b0294ea5>] sock_common_recvmsg+0x3e/0x54
 [<b029396f>] sock_recvmsg+0xcf/0xe8
 [<b0293a44>] sock_sendmsg+0xbc/0xd4
 [<b0131c35>] autoremove_wake_function+0x0/0x35
 [<b0172133>] core_sys_select+0x234/0x30f
 [<b0103189>] setup_sigcontext+0x105/0x189
 [<b02f41cf>] _spin_unlock_irq+0x20/0x41
 [<b013b1ee>] trace_hardirqs_on+0x11a/0x13d
 [<b0103a56>] do_notify_resume+0x5d1/0x611
 [<b02f41da>] _spin_unlock_irq+0x2b/0x41
 [<b01039b4>] do_notify_resume+0x52f/0x611
 [<b010898b>] convert_fxsr_from_user+0x26/0xe6
 [<f24ac537>] kvm_vcpu_ioctl+0x0/0xcff [kvm]
 [<b0171007>] do_ioctl+0x1f/0x62
 [<b0171281>] vfs_ioctl+0x237/0x249
 [<b01712c6>] sys_ioctl+0x33/0x4d
 [<b0103e78>] syscall_call+0x7/0xb
 =======================

Luca
-- 
Il coraggio non mi manca.
E` la paura che mi frega...
