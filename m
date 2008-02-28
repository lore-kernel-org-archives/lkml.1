Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYB1Nyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYB1Nyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYB1Ny1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:54:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:21552 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYB1NyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:54:25 -0500
From: Ritesh Raj Sarraf <rrs@researchut.com>
Reply-To: Ritesh Raj Sarraf <rrs@researchut.com>
Organization: RESEARCHUT
To: Christophe Saout <christophe@saout.de>
Subject: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Thu, 28 Feb 2008 19:24:03 +0530
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
X-Face: L'e+W$sfUn_vK\|0It}WsAtt>E&abqUEWN>6_9w0jpkai8CP=.CDW}OkJ!rk!8*^7.%*3;V
 FN&rLp.}W)TyA|=}Sr'-B$|ZDu]w5(a|F>g}FqCv67uLfK6)\>T2N@?Ndx0b}=9k^*_;BAUbZ8BXLG
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5902277.Nvq2K7R16Q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802281924.03996.rrs@researchut.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5902277.Nvq2K7R16Q
Content-Type: multipart/mixed;
  boundary="Boundary-01=_7zrxHuSIpehAQc+"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_7zrxHuSIpehAQc+
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Christophe,

I noted kernel soft lockup messages on my laptop when doing a lot of I/O=20
(200GB) to a dm-crypt device. It was setup using LUKS.
The I/O never got disrupted nor anything failed. Just the messages.

Kernel: 2.6.24
Distribution: Debian Testing/Unstable
Tainted: Yes (nvidia proprietary drivers)

I've not filed a bugzilla because my kernel is a tainted kernel because of=
=20
nvidia drivers.

I'm attaching the messages. Please let me know if it stands as a candidate =
for=20
a bug report.


Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

--Boundary-01=_7zrxHuSIpehAQc+
Content-Type: text/plain;
  charset="us-ascii";
  name="kernel.bug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel.bug"

a200 EDI: 0000000a EBP: 00000000 ESP: f32bfd7c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b3c3e000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c012902d>] do_softirq+0x45/0x53
 [<c0129291>] irq_exit+0x38/0x6b
 [<c01066f2>] do_IRQ+0x5a/0x70
 [<c01048c3>] common_interrupt+0x23/0x28
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<f899237e>] crypto_cbc_encrypt+0xe4/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<c0128f6c>] EFLAGS: 00000202 CPU: 0
EIP is at __do_softirq+0x57/0xd3
EAX: c03b4860 EBX: 00000020 ECX: 00000009 EDX: 01c5c000
ESI: c036a200 EDI: 0000000a EBP: 00000000 ESP: f32bfd30
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b3c3e000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c012902d>] do_softirq+0x45/0x53
 [<c0129291>] irq_exit+0x38/0x6b
 [<c01066f2>] do_IRQ+0x5a/0x70
 [<c01048c3>] common_interrupt+0x23/0x28
 [<c01100d8>] cyrix_get_arr+0xb4/0x126
 [<c011ad36>] native_flush_tlb_single+0x3/0x4
 [<c011d0e9>] kunmap_atomic+0x60/0x94
 [<f89742d5>] blkcipher_walk_done+0x87/0x1fe [blkcipher]
 [<f89923cc>] crypto_cbc_encrypt+0x132/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac666>] EFLAGS: 00000286 CPU: 0
EIP is at aes_enc_blk+0x666/0xb6c [aes_i586]
EAX: 2605adab EBX: b84a5bae ECX: 04fa11f8 EDX: 000000f8
ESI: b3d37092 EDI: 8c24d4a9 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b3c3e000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Can't stop Rx DMA.
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<c02bda19>] EFLAGS: 00000292 CPU: 0
EIP is at _spin_unlock_irqrestore+0xa/0x13
EAX: 00000292 EBX: f6eff300 ECX: 00000292 EDX: 00000200
ESI: f6eff314 EDI: 00000292 EBP: f6f9fffc ESP: f32bfcc4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b4e7d000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f991b6f6>] os_release_sema+0x3b/0x5a [nvidia]
 [<f98793bf>] _nv003771rm+0x9/0x12 [nvidia]
 [<f987b1e9>] _nv002876rm+0x8f/0x99 [nvidia]
 [<f987fdee>] rm_isr_bh+0x77/0xa2 [nvidia]
 [<f9918ad1>] nv_kern_isr_bh+0x73/0x79 [nvidia]
 [<c01293e3>] tasklet_action+0x58/0xb8
 [<c0128f7b>] __do_softirq+0x66/0xd3
 [<c012902d>] do_softirq+0x45/0x53
 [<c0129291>] irq_exit+0x38/0x6b
 [<c01066f2>] do_IRQ+0x5a/0x70
 [<c01292ac>] irq_exit+0x53/0x6b
 [<c0115e6c>] smp_apic_timer_interrupt+0x71/0x7d
 [<c01048c3>] common_interrupt+0x23/0x28
 [<c01d007b>] cap_syslog+0x1d/0x20
 [<f89ac4d6>] aes_enc_blk+0x4d6/0xb6c [aes_i586]
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f899203f>] EFLAGS: 00000286 CPU: 0
EIP is at xor_128+0x10/0x17 [cbc]
EAX: f32bfe80 EBX: 00000010 ECX: dc801d88 EDX: fffb7200
ESI: f5fa0340 EDI: f8901114 EBP: fffb7200 ESP: f32bfdf4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b4e7d000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f899237e>] crypto_cbc_encrypt+0xe4/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac783>] EFLAGS: 00000202 CPU: 0
EIP is at aes_enc_blk+0x783/0xb6c [aes_i586]
EAX: 81754e72 EBX: 51bcfa68 ECX: 000000d0 EDX: 0000008b
ESI: cbd409ea EDI: 45dc1dbb EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b4e7d000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<c0128f6c>] EFLAGS: 00000202 CPU: 0
EIP is at __do_softirq+0x57/0xd3
EAX: c03b4860 EBX: 00000020 ECX: 00000009 EDX: 01c5c000
ESI: c036a200 EDI: 0000000a EBP: 00000000 ESP: f32bfd54
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b4e7d000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c012902d>] do_softirq+0x45/0x53
 [<c0129291>] irq_exit+0x38/0x6b
 [<c01066f2>] do_IRQ+0x5a/0x70
 [<c01292ac>] irq_exit+0x53/0x6b
 [<c01066f2>] do_IRQ+0x5a/0x70
 [<c01048c3>] common_interrupt+0x23/0x28
 [<c01d007b>] cap_syslog+0x1d/0x20
 [<f89ac3b1>] aes_enc_blk+0x3b1/0xb6c [aes_i586]
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac590>] EFLAGS: 00000202 CPU: 0
EIP is at aes_enc_blk+0x590/0xb6c [aes_i586]
EAX: 000000c8 EBX: bf1ada9f ECX: 8a4a7f71 EDX: 000000fd
ESI: 2bb72c79 EDI: c22842b9 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b4e7d000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Can't stop Rx DMA.
wlan0_rename: Initial auth_alg=0
wlan0_rename: authenticate with AP 00:16:b6:a5:e7:1c
wlan0_rename: RX authentication from 00:16:b6:a5:e7:1c (alg=0 transaction=2 status=0)
wlan0_rename: authenticated
wlan0_rename: associate with AP 00:16:b6:a5:e7:1c
wlan0_rename: RX ReassocResp from 00:16:b6:a5:e7:1c (capab=0x411 status=0 aid=1)
wlan0_rename: associated
wlan0_rename: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 burst=0
wlan0_rename: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 burst=0
wlan0_rename: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
wlan0_rename: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
ADDRCONF(NETDEV_CHANGE): wlan0_rename: link becomes ready
wlan0_rename: deauthenticate(reason=3)
ADDRCONF(NETDEV_UP): wlan0_rename: link is not ready
BUG: soft lockup - CPU#1 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac575>] EFLAGS: 00000207 CPU: 1
EIP is at aes_enc_blk+0x575/0xb6c [aes_i586]
EAX: 00002cd1 EBX: fbfb97b0 ECX: 529e504e EDX: 000000a4
ESI: 00e87e9a EDI: f5e85f79 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080fcf18 CR3: 332cf000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac957>] EFLAGS: 00000282 CPU: 0
EIP is at aes_enc_blk+0x957/0xb6c [aes_i586]
EAX: 23678e89 EBX: f1c85eec ECX: 7c69a25c EDX: 0000005c
ESI: b61fba3a EDI: 59230267 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7ee7ed4 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#1 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac9a0>] EFLAGS: 00000282 CPU: 1
EIP is at aes_enc_blk+0x9a0/0xb6c [aes_i586]
EAX: a3e4820a EBX: 835f477f ECX: 0000003e EDX: 000000b8
ESI: d4e9965a EDI: a3dce360 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f02000 CR3: 25df4000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#1 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac3cb>] EFLAGS: 00000206 CPU: 1
EIP is at aes_enc_blk+0x3cb/0xb6c [aes_i586]
EAX: 00000088 EBX: 3f2b4328 ECX: 4ad5ff0f EDX: 00000009
ESI: d5ca35ba EDI: a3755a93 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f02000 CR3: 25df4000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<c0175502>] EFLAGS: 00000206 CPU: 0
EIP is at kmem_cache_alloc+0x55/0x84
EAX: 00000206 EBX: f33a0070 ECX: f7c812c0 EDX: f7c8c600
ESI: f7c812c0 EDI: 00000206 EBP: 00011200 ESP: f32bfd80
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 0840d8dc CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c015ce79>] mempool_alloc+0x1c/0xba
 [<c011cfbd>] kmap_atomic_prot+0x9c/0xcb
 [<c01d6537>] get_request+0x153/0x2c9
 [<f897439d>] blkcipher_walk_done+0x14f/0x1fe [blkcipher]
 [<c01d6eb3>] get_request_wait+0x26/0x175
 [<c01dd83d>] cfq_allow_merge+0x33/0x5a
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<c01d3291>] elv_iosched_allow_merge+0x21/0x25
 [<c01d42f8>] elv_merge+0x59/0x1b1
 [<c01d8193>] __make_request+0x44f/0x4ff
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<c01d577e>] generic_make_request+0x3b3/0x3e1
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fea5b>] kcryptd_do_crypt+0x23e/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
usb 1-1: USB disconnect, address 18
usb 1-1: new high speed USB device using ehci_hcd and address 19
usb 1-1: configuration #1 chosen from 1 choice
scsi10 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 19
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 10:0:0:0: Direct-Access     WD       1600BEV External 1.04 PQ: 0 ANSI: 4
sd 10:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
sd 10:0:0:0: [sdc] Write Protect is off
sd 10:0:0:0: [sdc] Mode Sense: 21 00 00 00
sd 10:0:0:0: [sdc] Assuming drive cache: write through
sd 10:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
sd 10:0:0:0: [sdc] Write Protect is off
sd 10:0:0:0: [sdc] Mode Sense: 21 00 00 00
sd 10:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1
sd 10:0:0:0: [sdc] Attached SCSI disk
sd 10:0:0:0: Attached scsi generic sg3 type 0
SELinux: initialized (dev sdc1, type vfat), uses genfs_contexts
usb 1-1: USB disconnect, address 19
usb 1-1: new high speed USB device using ehci_hcd and address 20
usb 1-1: configuration #1 chosen from 1 choice
scsi11 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 20
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 11:0:0:0: Direct-Access     ST912082 2A               0811 PQ: 0 ANSI: 0
sd 11:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 MB)
sd 11:0:0:0: [sdc] Test WP failed, assume Write Enabled
sd 11:0:0:0: [sdc] Assuming drive cache: write through
sd 11:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 MB)
sd 11:0:0:0: [sdc] Test WP failed, assume Write Enabled
sd 11:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1 sdc2 sdc3
sd 11:0:0:0: [sdc] Attached SCSI disk
sd 11:0:0:0: Attached scsi generic sg3 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdc1, type ext3), uses xattr
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac7d4>] EFLAGS: 00000282 CPU: 0
EIP is at aes_enc_blk+0x7d4/0xb6c [aes_i586]
EAX: edc4b146 EBX: d596de83 ECX: 0000c8f1 EDX: 000000f4
ESI: 45a60374 EDI: 9dd50ec9 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b4434000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac82e>] EFLAGS: 00000282 CPU: 0
EIP is at aes_enc_blk+0x82e/0xb6c [aes_i586]
EAX: b067668e EBX: 04ac9072 ECX: deee0d83 EDX: 0000008e
ESI: 3214ce69 EDI: 04b1f0a0 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b4434000 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f8974726>] EFLAGS: 00000282 CPU: 0
EIP is at blkcipher_walk_first+0x4/0x179 [blkcipher]
EAX: f32bfea4 EBX: f518f000 ECX: 00000010 EDX: f32bfe20
ESI: f5fa0340 EDI: f8901114 EBP: f32bfe20 ESP: f32bfdec
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 0843d7c0 CR3: 1ff64000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89922d4>] crypto_cbc_encrypt+0x3a/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac8e9>] EFLAGS: 00000286 CPU: 0
EIP is at aes_enc_blk+0x8e9/0xb6c [aes_i586]
EAX: 1505dcbd EBX: a16c8192 ECX: a82d7918 EDX: 0000000c
ESI: f3a37640 EDI: c501a21d EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 08441250 CR3: 333ed000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac950>] EFLAGS: 00000202 CPU: 0
EIP is at aes_enc_blk+0x950/0xb6c [aes_i586]
EAX: 2248b187 EBX: 6e6cb3db ECX: cc1ff777 EDX: 00000077
ESI: 5672a35f EDI: 7e5053b9 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 08499b40 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89ac673>] EFLAGS: 00000202 CPU: 0
EIP is at aes_enc_blk+0x673/0xb6c [aes_i586]
EAX: 41890ece EBX: 86b32555 ECX: 000082f5 EDX: 000000da
ESI: 2da6097a EDI: c7b00061 EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f0e000 CR3: 1ff70000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89923ac>] EFLAGS: 00000203 CPU: 0
EIP is at crypto_cbc_encrypt+0x112/0x146 [cbc]
EAX: 00000001 EBX: 00000010 ECX: fffffff0 EDX: 000000ab
ESI: f5e912d0 EDI: f32bfe90 EBP: c6ca72c0 ESP: f32bfdf8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f8e78 CR3: 309fc000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]

Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89aca3e>] EFLAGS: 00000206 CPU: 0
EIP is at aes_enc_blk+0xa3e/0xb6c [aes_i586]
EAX: 00000082 EBX: a6054c84 ECX: 432211c3 EDX: 00000087
ESI: be022a17 EDI: 3fac9aaf EBP: f518f030 ESP: f32bfdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f8e78 CR3: 1ff70000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89ad702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f899238d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f899202f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================

--Boundary-01=_7zrxHuSIpehAQc+--

--nextPart5902277.Nvq2K7R16Q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHxrz74Rhi6gTxMLwRAsdcAJsHz/rkzI9UgxpCUrWeGvvZKy9YfACfStUP
qPghAge3SSR1ccogsHmN7vI=
=SXqL
-----END PGP SIGNATURE-----

--nextPart5902277.Nvq2K7R16Q--
