Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYAUMne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYAUMne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 07:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYAUMn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 07:43:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:64148 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYAUMnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:43:25 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: lockd spams syslog after upgrade from 2.6.18 to 2.6.24-rc8
Date: Mon, 21 Jan 2008 13:43:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
References: <200801210003.35734.hpj@urpla.net>
In-Reply-To: <200801210003.35734.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801211343.13832.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/FT04XYt3ILoENDJOhmaiIudSLBMYLb1A0BL0
 vj4SV0WDPAERHn7BXxlE6X33izqyh9436ZGOG4ecY/Ky3hQctF
 hsKW/7gSlhUBe9GuoEK1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. Januar 2008 schrieb Hans-Peter Jansen:
> Hi,
>
> after installation of 2.6.24-rc8 on a local server, the syslog gets
> spammed with "lockd: cannot monitor <some client>"
>
> grep 'lockd: cannot monitor' /var/log/messages | wc -l
> 136026
>
> in 20 minutes! I restarted the offending client (with 2.6.18.something)
> for mercy reasons now..
>
> Pete

I got even worser today. This server provides nfs3 mounted home directories
for a small network, but working with OpenOffice is unpossible. Loading a
file looks fine, it get displayed properly, but then it hangs, before being
able to do anything. Killing removes the process. Reverting to 
2.6.18.something on the server fixed both issues. Client and server are 
openSUSE 10.2 installations.

As it stands, 2.6.24-rc8 isn't usable for me at the moment. Let me know, if
I can provide more details for these issues.

Pete

Here's the OpenOffice call trace:

Jan 21 12:34:26 xrated kernel: soffice.bin   S D18AB017     0 18589      1         18590 16736 (NOTLB)
Jan 21 12:34:26 xrated kernel:        d6065e80 00200086 d6d643a8 d18ab017 c01700ee d6065e50 00000007 e7b6d230 
Jan 21 12:34:26 xrated kernel:        b175be00 000080cb 00000000 00000000 e7b6d360 c34126e0 b7580900 00000000 
Jan 21 12:34:26 xrated kernel:        00200082 f1a4bf44 f1a4bf1c 00000000 d6065e5c c0119b87 00000000 b6b2be6c 
Jan 21 12:34:26 xrated kernel: Call Trace:
Jan 21 12:34:26 xrated kernel:  [<c01700ee>] do_lookup+0x4f/0x135
Jan 21 12:34:26 xrated kernel:  [<c0119b87>] __wake_up_common+0x2f/0x53
Jan 21 12:34:26 xrated kernel:  [<c02a60f5>] schedule_timeout+0x13/0x98
Jan 21 12:34:26 xrated kernel:  [<c013535e>] get_futex_key+0x40/0xee
Jan 21 12:34:26 xrated kernel:  [<c0162d6b>] vfs_statfs+0x47/0x5f
Jan 21 12:34:26 xrated kernel:  [<c0132772>] add_wait_queue+0x12/0x30
Jan 21 12:34:26 xrated kernel:  [<c0136394>] do_futex+0x1b4/0xafb
Jan 21 12:34:26 xrated kernel:  [<c01bfc16>] _atomic_dec_and_lock+0x2a/0x44
Jan 21 12:34:26 xrated kernel:  [<c017c523>] mntput_no_expire+0x11/0x6a
Jan 21 12:34:26 xrated kernel:  [<c0163e6f>] sys_statfs64+0x75/0x80
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c0136dc8>] sys_futex+0xed/0x100
Jan 21 12:34:26 xrated kernel:  [<c01022f0>] sys_clone+0x36/0x3b
Jan 21 12:34:26 xrated kernel:  [<c0103e47>] syscall_call+0x7/0xb
Jan 21 12:34:26 xrated kernel: soffice.bin   S 000080CA     0 18590      1         18591 18589 (NOTLB)
Jan 21 12:34:26 xrated kernel:        d6f4fe80 00000086 37910500 000080ca 00000086 c011b185 00000001 e7b6ccb0 
Jan 21 12:34:26 xrated kernel:        37ce0e00 000080ca 00000000 00000001 e7b6cde0 c341a6e0 00000000 00000000 
Jan 21 12:34:26 xrated kernel:        00000000 c0178d7a 00000000 d643b670 00000000 d6f4fe5a 0000000a c02c77aa 
Jan 21 12:34:26 xrated kernel: Call Trace:
Jan 21 12:34:26 xrated kernel:  [<c011b185>] try_to_wake_up+0x365/0x36f
Jan 21 12:34:26 xrated kernel:  [<c0178d7a>] dput+0x22/0x123
Jan 21 12:34:26 xrated kernel:  [<c02a615b>] schedule_timeout+0x79/0x98
Jan 21 12:34:26 xrated kernel:  [<c013535e>] get_futex_key+0x40/0xee
Jan 21 12:34:26 xrated kernel:  [<c01357d3>] futex_wake+0xa9/0xb3
Jan 21 12:34:26 xrated kernel:  [<c012933e>] process_timeout+0x0/0x5
Jan 21 12:34:26 xrated kernel:  [<c0136394>] do_futex+0x1b4/0xafb
Jan 21 12:34:26 xrated kernel:  [<c01242c3>] sys_exit_group+0x0/0xd
Jan 21 12:34:26 xrated kernel:  [<c012c37b>] get_signal_to_deliver+0x395/0x3bc
Jan 21 12:34:26 xrated kernel:  [<c0103526>] do_notify_resume+0x76/0x5ee
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c0136dc8>] sys_futex+0xed/0x100
Jan 21 12:34:26 xrated kernel:  [<c0103e47>] syscall_call+0x7/0xb
Jan 21 12:34:26 xrated kernel: soffice.bin   S C3652C70     0 18591      1         18593 18590 (NOTLB)
Jan 21 12:34:26 xrated kernel:        e9307e54 00000086 c36f5680 c3652c70 00e438d0 c02b35a0 00000001 c3652c70 
Jan 21 12:34:26 xrated kernel:        38ff3b00 000080ca 00000000 00000001 c3652da0 c341a6e0 00000000 00000000 
Jan 21 12:34:26 xrated kernel:        c011b185 00000001 c3652c70 00000163 00000000 c25ded20 00000000 c25ded20 
Jan 21 12:34:26 xrated kernel: Call Trace:
Jan 21 12:34:26 xrated kernel:  [<c011b185>] try_to_wake_up+0x365/0x36f
Jan 21 12:34:26 xrated kernel:  [<c02a60f5>] schedule_timeout+0x13/0x98
Jan 21 12:34:26 xrated kernel:  [<c0187996>] inotify_d_instantiate+0x41/0x67
Jan 21 12:34:26 xrated kernel:  [<c0178c83>] d_alloc+0x142/0x18f
Jan 21 12:34:26 xrated kernel:  [<c0132678>] prepare_to_wait_exclusive+0x12/0x4b
Jan 21 12:34:26 xrated kernel:  [<c02521b1>] skb_recv_datagram+0x130/0x1af
Jan 21 12:34:26 xrated kernel:  [<c01325aa>] autoremove_wake_function+0x0/0x35
Jan 21 12:34:26 xrated kernel:  [<c02a2b4b>] unix_accept+0x4f/0xd6
Jan 21 12:34:26 xrated kernel:  [<c024c6de>] sys_accept+0xf6/0x1c8
Jan 21 12:34:26 xrated kernel:  [<c024c886>] sys_socketcall+0xd6/0x261
Jan 21 12:34:26 xrated kernel:  [<c0103e47>] syscall_call+0x7/0xb
Jan 21 12:34:26 xrated kernel: soffice.bin   S 00000000     0 18593      1         18598 18591 (NOTLB)
Jan 21 12:34:26 xrated kernel:        d631dbfc 00200086 00000000 00000000 00000000 00000000 00000001 f50736b0 
Jan 21 12:34:26 xrated kernel:        596c0300 000080ca 00000000 00000001 f50737e0 c341a6e0 00000000 00000000 
Jan 21 12:34:26 xrated kernel:        d631dd84 d631dd80 00000163 80000000 00000000 00000000 c29ed240 00000256 
Jan 21 12:34:26 xrated kernel: Call Trace:
Jan 21 12:34:26 xrated kernel:  [<c02a60f5>] schedule_timeout+0x13/0x98
Jan 21 12:34:26 xrated kernel:  [<c0132709>] remove_wait_queue+0xc/0x34
Jan 21 12:34:26 xrated kernel:  [<c0132772>] add_wait_queue+0x12/0x30
Jan 21 12:34:26 xrated kernel:  [<c02a160c>] unix_poll+0x14/0x7b
Jan 21 12:34:26 xrated kernel:  [<c0174d5c>] do_sys_poll+0x26a/0x33f
Jan 21 12:34:26 xrated kernel:  [<c0175787>] __pollwait+0x0/0xb2
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c010193c>] send_IPI_mask+0x0/0x15
Jan 21 12:34:26 xrated kernel:  [<c0112d01>] smp_send_reschedule+0x90/0x97
Jan 21 12:34:26 xrated kernel:  [<c010193c>] send_IPI_mask+0x0/0x15
Jan 21 12:34:26 xrated kernel:  [<c0112d01>] smp_send_reschedule+0x90/0x97
Jan 21 12:34:26 xrated kernel:  [<c011b185>] try_to_wake_up+0x365/0x36f
Jan 21 12:34:26 xrated kernel:  [<c02a3c08>] unix_write_space+0x12/0x71
Jan 21 12:34:26 xrated kernel:  [<c024eb4a>] sock_wfree+0x21/0x36
Jan 21 12:34:26 xrated kernel:  [<c02502f4>] __kfree_skb+0x9e/0xed
Jan 21 12:34:26 xrated kernel:  [<c02a26b0>] unix_stream_recvmsg+0x38e/0x4af
Jan 21 12:34:26 xrated kernel:  [<c024d5ee>] sock_alloc_send_skb+0x68/0x198
Jan 21 12:34:26 xrated kernel:  [<c024aa2f>] do_sock_read+0xb7/0xbf
Jan 21 12:34:26 xrated kernel:  [<c024b0a8>] sock_aio_read+0x5e/0x6a
Jan 21 12:34:26 xrated kernel:  [<c0164559>] do_sync_read+0xc1/0xfb
Jan 21 12:34:26 xrated kernel:  [<c01325aa>] autoremove_wake_function+0x0/0x35
Jan 21 12:34:26 xrated kernel:  [<c0164f66>] vfs_read+0x11e/0x15d
Jan 21 12:34:26 xrated kernel:  [<c0174e66>] sys_poll+0x35/0x38
Jan 21 12:34:26 xrated kernel:  [<c0103e47>] syscall_call+0x7/0xb
Jan 21 12:34:26 xrated kernel: soffice.bin   S 00000000     0 18598      1         18599 18593 (NOTLB)
Jan 21 12:34:26 xrated kernel:        f5145e80 00200086 00000000 00000000 f5145eb0 d39c6040 0000000a d643ab70 
Jan 21 12:34:26 xrated kernel:        e5e97a00 000080cb 00000000 00000001 d643aca0 c341a6e0 00000000 00000000 
Jan 21 12:34:26 xrated kernel:        00000000 00000000 00000000 00000008 00000008 0000489d 000003e8 000008ae 
Jan 21 12:34:26 xrated kernel: Call Trace:
Jan 21 12:34:26 xrated kernel:  [<c024aa2f>] do_sock_read+0xb7/0xbf
Jan 21 12:34:26 xrated kernel:  [<c02a60f5>] schedule_timeout+0x13/0x98
Jan 21 12:34:26 xrated kernel:  [<c013535e>] get_futex_key+0x40/0xee
Jan 21 12:34:26 xrated kernel:  [<c0132772>] add_wait_queue+0x12/0x30
Jan 21 12:34:26 xrated kernel:  [<c0136394>] do_futex+0x1b4/0xafb
Jan 21 12:34:26 xrated kernel:  [<c0164559>] do_sync_read+0xc1/0xfb
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c0136dc8>] sys_futex+0xed/0x100
Jan 21 12:34:26 xrated kernel:  [<c0103e47>] syscall_call+0x7/0xb
Jan 21 12:34:26 xrated kernel: soffice.bin   S 00000000     0 18599      1         18603 18598 (NOTLB)
Jan 21 12:34:26 xrated kernel:        f4581e80 00200086 00000001 00000000 00000001 c01722df 0000000a f3130e70 
Jan 21 12:34:26 xrated kernel:        f4f0b000 000080cf 00000000 00000001 f3130fa0 c341a6e0 00000000 00000000 
Jan 21 12:34:26 xrated kernel:        00000044 00000000 000200d2 00000010 00000000 00000000 0c000000 00000012 
Jan 21 12:34:26 xrated kernel: Call Trace:
Jan 21 12:34:26 xrated kernel:  [<c01722df>] __link_path_walk+0xc4d/0xd1e
Jan 21 12:34:26 xrated kernel:  [<c02a615b>] schedule_timeout+0x79/0x98
Jan 21 12:34:26 xrated kernel:  [<c013535e>] get_futex_key+0x40/0xee
Jan 21 12:34:26 xrated kernel:  [<c01357d3>] futex_wake+0xa9/0xb3
Jan 21 12:34:26 xrated kernel:  [<c012933e>] process_timeout+0x0/0x5
Jan 21 12:34:26 xrated kernel:  [<c0136394>] do_futex+0x1b4/0xafb
Jan 21 12:34:26 xrated kernel:  [<c0119fe2>] __wake_up_sync+0x31/0x4b
Jan 21 12:34:26 xrated kernel:  [<c0119b18>] deactivate_task+0x19/0x23
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c0124243>] do_exit+0x787/0x791
Jan 21 12:34:26 xrated kernel:  [<c0136dc8>] sys_futex+0xed/0x100
Jan 21 12:34:26 xrated kernel:  [<c0103e47>] syscall_call+0x7/0xb
Jan 21 12:34:26 xrated kernel: soffice.bin   S 000080CB     0 18603      1         18604 18599 (NOTLB)
Jan 21 12:34:26 xrated kernel:        f1a4be80 00200086 b138b500 000080cb 00200086 c011b185 00000006 d643b670 
Jan 21 12:34:26 xrated kernel:        b175be00 000080cb 00000000 00000000 d643b7a0 c34126e0 00000000 00000000 
Jan 21 12:34:26 xrated kernel:        00000000 00000000 ffffffda c01363fc 00000000 00000000 00000000 00000000 
Jan 21 12:34:26 xrated kernel: Call Trace:
Jan 21 12:34:26 xrated kernel:  [<c011b185>] try_to_wake_up+0x365/0x36f
Jan 21 12:34:26 xrated kernel:  [<c01363fc>] do_futex+0x21c/0xafb
Jan 21 12:34:26 xrated kernel:  [<c02a60f5>] schedule_timeout+0x13/0x98
Jan 21 12:34:26 xrated kernel:  [<c013535e>] get_futex_key+0x40/0xee
Jan 21 12:34:26 xrated kernel:  [<c01357d3>] futex_wake+0xa9/0xb3
Jan 21 12:34:26 xrated kernel:  [<c01354b6>] unqueue_me+0x83/0x8b
Jan 21 12:34:26 xrated kernel:  [<c0132772>] add_wait_queue+0x12/0x30
Jan 21 12:34:26 xrated kernel:  [<c0136394>] do_futex+0x1b4/0xafb
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c0134f2d>] down_read+0x8/0x11
Jan 21 12:34:26 xrated kernel:  [<c0136dc8>] sys_futex+0xed/0x100
Jan 21 12:34:26 xrated kernel:  [<c0103e47>] syscall_call+0x7/0xb
Jan 21 12:34:26 xrated kernel: soffice.bin   S 0000005D     0 18604      1               18603 (NOTLB)
Jan 21 12:34:26 xrated kernel:        f642be80 00200086 c01c3125 0000005d 00000000 0000000a 00000006 d643a5f0 
Jan 21 12:34:26 xrated kernel:        b1b2c700 000080cb 003d0900 00000000 d643a720 c34126e0 003d0900 00000000 
Jan 21 12:34:26 xrated kernel:        00000000 00000000 00000000 00000000 00000000 d44899d8 c35b0f5c f7018c80 
Jan 21 12:34:26 xrated kernel: Call Trace:
Jan 21 12:34:26 xrated kernel:  [<c01c3125>] vsnprintf+0x44f/0x48b
Jan 21 12:34:26 xrated kernel:  [<c02a60f5>] schedule_timeout+0x13/0x98
Jan 21 12:34:26 xrated kernel:  [<c013535e>] get_futex_key+0x40/0xee
Jan 21 12:34:26 xrated kernel:  [<c0132772>] add_wait_queue+0x12/0x30
Jan 21 12:34:26 xrated kernel:  [<c0136394>] do_futex+0x1b4/0xafb
Jan 21 12:34:26 xrated kernel:  [<f9abcd77>] nfs_sync_mapping+0x4b/0x5c [nfs]
Jan 21 12:34:26 xrated kernel:  [<f9abb78d>] do_unlk+0x4f/0x56 [nfs]
Jan 21 12:34:26 xrated kernel:  [<f9abb996>] nfs_lock+0xe9/0x118 [nfs]
Jan 21 12:34:26 xrated kernel:  [<c0164559>] do_sync_read+0xc1/0xfb
Jan 21 12:34:26 xrated kernel:  [<c011b18f>] default_wake_function+0x0/0xc
Jan 21 12:34:26 xrated kernel:  [<c01bfc16>] _atomic_dec_and_lock+0x2a/0x44
Jan 21 12:34:26 xrated kernel:  [<c0178da2>] dput+0x4a/0x123
Jan 21 12:34:26 xrated kernel:  [<c0136dc8>] sys_futex+0xed/0x100
Jan 21 12:34:26 xrated kernel:  [<c0162f83>] filp_close+0x52/0x59
Jan 21 12:34:26 xrated kernel:  [<c0103e47>] syscall_call+0x7/0xb
