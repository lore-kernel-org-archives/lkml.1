Return-Path: <linux-kernel-owner+w=401wt.eu-S934870AbYEUM4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870AbYEUM4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYEUM4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:56:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:15413 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbYEUM4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=soWXGvmcCVUJICtcSHKjA38e9ZGkthgNQfKpTXelvNuIfqAhCPoxjpZgtEuZfRgDub/OJiIIwU4RroFQFe4MiBcuRhvnf7GfQzZzM8avIT8ZeLEmkS96OlxnoeOT8e+W1mKMBGnFuACitokPCOovgH8zAG3qPsNqLi/KjUDFZY8=
Message-ID: <c4e36d110805210556p205424a8r857edf3409a7a263@mail.gmail.com>
Date: Wed, 21 May 2008 14:56:09 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel NULL pointer dereference
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This oops was generated while I've been playing with the  vgchange -ay command.

The previous warning were made by suspend
 WARNING: at drivers/base/power/main.c:77 device_pm_add+0x96/0x120()
Thus I'm only pasting the oops itself - looks quite wierd:
(my setup is  64bit T61 2GB  -  git commit:
8033c6e9736c29cce5f0d0abbca9a44dffb20c39 )



BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
IP: [__pollwait+78/272] __pollwait+0x4e/0x110
PGD 55634067 PUD 5c37e067 PMD 0
Oops: 0002 [1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 1
Modules linked in: tun nls_iso8859_2 nls_cp852 vfat fat mmc_block i915
drm ipt_MASQUERADE iptable_nat nf_nat bridge llc nfsd lockd nfs_acl
auth_rpcgss exportfs autofs4 sunrpc ipt_REJECT xt_tcpudp
nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables
x_tables binfmt_misc dm_mirror dm_log dm_mod uinput kvm_intel kvm arc4
snd_hda_intel ecb crypto_blkcipher snd_seq_oss snd_seq_midi_event
snd_seq cryptomgr snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm
crypto_algapi iwl3945 video thinkpad_acpi snd_timer sdhci mac80211 snd
mmc_core evdev psmouse soundcore backlight cfg80211 e1000e battery ac
usbhid rtc_cmos hid iTCO_wdt iTCO_vendor_support snd_page_alloc
led_class rtc_core serio_raw i2c_i801 i2c_core sr_mod cdrom intel_agp
output button nvram rtc_lib uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: microcode]
Pid: 4963, comm: gnome-terminal Tainted: G        W 2.6.26-rc3 #5
RIP: 0010:[__pollwait+78/272]  [__pollwait+78/272] __pollwait+0x4e/0x110
RSP: 0018:ffff8100555ebae8  EFLAGS: 00010206
RAX: ffff810000b01000 RBX: ffff810000b00000 RCX: ffff810000b00000
RDX: 0000000000000038 RSI: 0000000000000070 RDI: ffff810040d8b500
RBP: ffff8100555ebb08 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8100555ebbb8
R13: ffff810040d8b500 R14: ffff810059049bc8 R15: ffff8100555ebbb8
FS:  00007f5a491c27a0(0000) GS:ffff81007e024320(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000038 CR3: 0000000055618000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gnome-terminal (pid: 4963, threadinfo ffff8100555ea000, task
ffff8100555d0000)
Stack:  ffff8100555ebbb8 ffff8100590498d8 ffff810059049801 ffff810040d8b500
 ffff8100555ebb38 ffffffff811e4ac8 0000000000000000 ffff810040d8b500
 ffff8100590498d8 ffff8100590498f8 ffff8100555ebb78 ffffffff811e11f1
Call Trace:
 [normal_poll+88/400] normal_poll+0x58/0x190
 [tty_poll+129/144] tty_poll+0x81/0x90
 [do_sys_poll+500/1104] do_sys_poll+0x1f4/0x450
 [__pollwait+0/272] ? __pollwait+0x0/0x110
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [lockdep_sys_exit_thunk+53/103] ? lockdep_sys_exit_thunk+0x35/0x67
 [sys_poll+51/160] sys_poll+0x33/0xa0
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80


Code: f6 49 89 d4 48 8b 5a 08 83 f9 09 77 68 48 63 c1 48 6b c0 38 48
8d 54 02 18 8d 41 01 41 89 44 24 14 48 85 d2 74 34 f0 41 ff 45 28 <4c>
89 2a 4c 89 72 30 48 8d 72 08 4c 89 f7 65 48 8b 04 25 00 00
RIP  [__pollwait+78/272] __pollwait+0x4e/0x110
 RSP <ffff8100555ebae8>
CR2: 0000000000000038
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<0000000000000000>]
PGD 34bc2067 PUD 40eee067 PMD 0
Oops: 0010 [2] PREEMPT SMP DEBUG_PAGEALLOC
CPU 1
Modules linked in: tun nls_iso8859_2 nls_cp852 vfat fat mmc_block i915
drm ipt_MASQUERADE iptable_nat nf_nat bridge llc nfsd lockd nfs_acl
auth_rpcgss exportfs autofs4 sunrpc ipt_REJECT xt_tcpudp
nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables
x_tables binfmt_misc dm_mirror dm_log dm_mod uinput kvm_intel kvm arc4
snd_hda_intel ecb crypto_blkcipher snd_seq_oss snd_seq_midi_event
snd_seq cryptomgr snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm
crypto_algapi iwl3945 video thinkpad_acpi snd_timer sdhci mac80211 snd
mmc_core evdev psmouse soundcore backlight cfg80211 e1000e battery ac
usbhid rtc_cmos hid iTCO_wdt iTCO_vendor_support snd_page_alloc
led_class rtc_core serio_raw i2c_i801 i2c_core sr_mod cdrom intel_agp
output button nvram rtc_lib uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: microcode]
Pid: 11408, comm: rsyslogd Tainted: G      D W 2.6.26-rc3 #5
RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
RSP: 0018:ffff810021193c30  EFLAGS: 00010006
RAX: ffff810000b002d0 RBX: ffffffffffffffe8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff810000b002b8
RBP: ffff810021193c68 R08: ffff810000b002b8 R09: 0000000000000001
R10: ffff8100593e8000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: ffff8100716ff760 R15: 0000000000000000
FS:  0000000041bc5950(0063) GS:ffff81007e024320(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000616ff000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rsyslogd (pid: 11408, threadinfo ffff810021192000, task
ffff8100593e8000)
Stack:  ffffffff8102c51a 0000000100000000 ffff8100716ff728 0000000000000000
 0000000000000001 0000000000000286 0000000000000001 ffff810021193ca8
 ffffffff8102e8a3 0000000000000286 0000000000000000 0000000000000f7c
Call Trace:
 [__wake_up_common+90/144] ? __wake_up_common+0x5a/0x90
 [kvm:__wake_up+67/16688] __wake_up+0x43/0x70
 [n_tty_receive_buf+1618/4592] n_tty_receive_buf+0x652/0x11f0
 [tty_open+632/896] ? tty_open+0x278/0x380
 [dm_mod:unlock_kernel+54/192] ? unlock_kernel+0x36/0x70
 [chrdev_open+329/544] ? chrdev_open+0x149/0x220
 [dm_mod:add_wait_queue+34/80] ? add_wait_queue+0x22/0x50
 [dm_mod:add_wait_queue+34/80] ? add_wait_queue+0x22/0x50
 [pty_write+58/96] pty_write+0x3a/0x60
 [write_chan+867/1040] write_chan+0x363/0x410
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [tty_write+444/640] tty_write+0x1bc/0x280
 [write_chan+0/1040] ? write_chan+0x0/0x410
 [vfs_write+203/400] vfs_write+0xcb/0x190
 [sys_write+80/144] sys_write+0x50/0x90
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80


Code:  Bad RIP value.
RIP  [<0000000000000000>]
 RSP <ffff810021193c30>
CR2: 0000000000000000
---[ end trace ba14c632f0d682f2 ]---
note: rsyslogd[11408] exited with preempt_count 1
BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic():1, irqs_disabled():1
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [copy_process+1068/5328]
copy_process+0x42c/0x14d0
softirqs last  enabled at (0): [copy_process+1068/5328]
copy_process+0x42c/0x14d0
softirqs last disabled at (0): [<0000000000000000>] 0x0
Pid: 11408, comm: rsyslogd Tainted: G      D W 2.6.26-rc3 #5

Call Trace:
 [print_irqtrace_events+272/288] ? print_irqtrace_events+0x110/0x120
 [kvm:__might_sleep+236/2512] __might_sleep+0xec/0x130
 [snd_pcm:down_read+32/5184] down_read+0x20/0x70
 [acct_collect+68/496] acct_collect+0x44/0x1f0
 [do_exit+420/2224] do_exit+0x1a4/0x8b0
 [do_unblank_screen+31/368] ? do_unblank_screen+0x1f/0x170
 [oops_end+136/144] oops_end+0x88/0x90
 [do_page_fault+640/2800] do_page_fault+0x280/0xaf0
 [__up_read+130/176] ? __up_read+0x82/0xb0
 [__d_lookup+177/352] ? __d_lookup+0xb1/0x160
 [__d_lookup+215/352] ? __d_lookup+0xd7/0x160
 [error_exit+0/169] error_exit+0x0/0xa9
 [__wake_up_common+90/144] ? __wake_up_common+0x5a/0x90
 [kvm:__wake_up+67/16688] ? __wake_up+0x43/0x70
 [n_tty_receive_buf+1618/4592] ? n_tty_receive_buf+0x652/0x11f0
 [tty_open+632/896] ? tty_open+0x278/0x380
 [dm_mod:unlock_kernel+54/192] ? unlock_kernel+0x36/0x70
 [chrdev_open+329/544] ? chrdev_open+0x149/0x220
 [dm_mod:add_wait_queue+34/80] ? add_wait_queue+0x22/0x50
 [dm_mod:add_wait_queue+34/80] ? add_wait_queue+0x22/0x50
 [pty_write+58/96] ? pty_write+0x3a/0x60
 [write_chan+867/1040] ? write_chan+0x363/0x410
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [tty_write+444/640] ? tty_write+0x1bc/0x280
 [write_chan+0/1040] ? write_chan+0x0/0x410
 [vfs_write+203/400] ? vfs_write+0xcb/0x190
 [sys_write+80/144] ? sys_write+0x50/0x90
 [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0x80

SPIN IRQ ALREADY DISABLED
Pid: 11408, comm: rsyslogd Tainted: G      D W 2.6.26-rc3 #5

Call Trace:
 [dm_mirror:_spin_lock_irq+126/128] _spin_lock_irq+0x7e/0x80
 [__pagevec_lru_add_active+99/240] __pagevec_lru_add_active+0x63/0xf0
 [drain_cpu_pagevecs+133/192] drain_cpu_pagevecs+0x85/0xc0
 [lru_add_drain+26/80] lru_add_drain+0x1a/0x50
 [exit_mmap+32/320] exit_mmap+0x20/0x140
 [mmput+87/192] mmput+0x57/0xc0
 [exit_mm+155/272] exit_mm+0x9b/0x110
 [do_exit+501/2224] do_exit+0x1f5/0x8b0
 [do_unblank_screen+31/368] ? do_unblank_screen+0x1f/0x170
 [oops_end+136/144] oops_end+0x88/0x90
 [do_page_fault+640/2800] do_page_fault+0x280/0xaf0
 [__up_read+130/176] ? __up_read+0x82/0xb0
 [__d_lookup+177/352] ? __d_lookup+0xb1/0x160
 [__d_lookup+215/352] ? __d_lookup+0xd7/0x160
 [error_exit+0/169] error_exit+0x0/0xa9
 [__wake_up_common+90/144] ? __wake_up_common+0x5a/0x90
 [kvm:__wake_up+67/16688] ? __wake_up+0x43/0x70
 [n_tty_receive_buf+1618/4592] ? n_tty_receive_buf+0x652/0x11f0
 [tty_open+632/896] ? tty_open+0x278/0x380
 [dm_mod:unlock_kernel+54/192] ? unlock_kernel+0x36/0x70
 [chrdev_open+329/544] ? chrdev_open+0x149/0x220
 [dm_mod:add_wait_queue+34/80] ? add_wait_queue+0x22/0x50
 [dm_mod:add_wait_queue+34/80] ? add_wait_queue+0x22/0x50
 [pty_write+58/96] ? pty_write+0x3a/0x60
 [write_chan+867/1040] ? write_chan+0x363/0x410
 [<ffffffff81033360>] ? default_wake_function+0x0/0x10
 [tty_write+444/640] ? tty_write+0x1bc/0x280
 [write_chan+0/1040] ? write_chan+0x0/0x410
 [vfs_write+203/400] ? vfs_write+0xcb/0x190
 [sys_write+80/144] ? sys_write+0x50/0x90
 [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0x80

---[ end trace ba14c632f0d682f2 ]---



Here is the actual code: (part of the __pollwait - address 0x171e)

static struct poll_table_entry *poll_get_entry(poll_table *_p)
{
	struct poll_wqueues *p = container_of(_p, struct poll_wqueues, pt);
	struct poll_table_page *table = p->table;
    16f7:	48 8b 5a 08          	mov    0x8(%rdx),%rbx

	if (p->inline_index < N_INLINE_POLL_ENTRIES)
    16fb:	83 f9 09             	cmp    $0x9,%ecx
    16fe:	77 68                	ja     1768 <__pollwait+0x98>
		return p->inline_entries + p->inline_index++;
    1700:	48 63 c1             	movslq %ecx,%rax
    1703:	48 6b c0 38          	imul   $0x38,%rax,%rax
    1707:	48 8d 54 02 18       	lea    0x18(%rdx,%rax,1),%rdx
    170c:	8d 41 01             	lea    0x1(%rcx),%eax
    170f:	41 89 44 24 14       	mov    %eax,0x14(%r12)
/* Add a new entry */
static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
				poll_table *p)
{
	struct poll_table_entry *entry = poll_get_entry(p);
	if (!entry)
    1714:	48 85 d2             	test   %rdx,%rdx
    1717:	74 34                	je     174d <__pollwait+0x7d>
 *
 * Atomically increments @v by 1.
 */
static inline void atomic_inc(atomic_t *v)
{
	asm volatile(LOCK_PREFIX "incl %0"
    1719:	f0 41 ff 45 28       	lock incl 0x28(%r13)
		return;
	get_file(filp);
	entry->filp = filp;
    171e:	4c 89 2a             	mov    %r13,(%rdx)
	entry->wait_address = wait_address;
    1721:	4c 89 72 30          	mov    %r14,0x30(%rdx)
	init_waitqueue_entry(&entry->wait, current);
	add_wait_queue(wait_address, &entry->wait);
    1725:	48 8d 72 08          	lea    0x8(%rdx),%rsi
    1729:	4c 89 f7             	mov    %r14,%rdi

#include <asm/pda.h>

static inline struct task_struct *get_current(void)
{
	struct task_struct *t = read_pda(pcurrent);
    172c:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    1733:	00 00
# define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) DECLARE_WAIT_QUEUE_HEAD(name)
#endif
