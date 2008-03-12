Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYCLM0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYCLM0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYCLM0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:26:00 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:57257 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYCLMZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:25:58 -0400
Date: Wed, 12 Mar 2008 13:25:50 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: nfsv4@linux-nfs.org
Cc: linux-kernel@vger.kernel.org
Subject: Oops in NFSv4 server in 2.6.23.17
Message-ID: <20080312122550.GB8141@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 12 Mar 2008 13:25:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running NFSv4 server (nfs-utils 1.1.1) with vanila kernel 2.6.23.17.
It works while I use the server from standard ethernet lines.

However, I tried to mount the volume over GPRS network. For the first time, it
replies premission denied and the second try results in the following oops.

Anything I should try?

I guess that the last oops is induced from the first one due to some memory 
corruption.

WARNING: at lib/kref.c:33 kref_get()

Call Trace:
 [<ffffffff803a1315>] kref_get+0x35/0x40
 [<ffffffff88128f34>] :sunrpc:sunrpc_cache_lookup+0x64/0x160
 [<ffffffff881b5910>] :nfsd:svc_export_lookup+0xc0/0xd0
 [<ffffffff881b594f>] :nfsd:exp_get_by_name+0x2f/0x80
 [<ffffffff88128f34>] :sunrpc:sunrpc_cache_lookup+0x64/0x160
 [<ffffffff88127b89>] :sunrpc:cache_check+0x49/0x490
 [<ffffffff881b5fb7>] :nfsd:exp_find_key+0x57/0xc0
 [<ffffffff881b6064>] :nfsd:exp_find+0x44/0xa0
 [<ffffffff881b615e>] :nfsd:rqst_exp_find+0x9e/0xf0
 [<ffffffff881b0c45>] :nfsd:fh_verify+0x425/0x540
 [<ffffffff881bf25e>] :nfsd:nfsd4_proc_compound+0x1de/0x330
 [<ffffffff881ad271>] :nfsd:nfsd_dispatch+0xb1/0x250
 [<ffffffff8811fe91>] :sunrpc:svc_process+0x491/0x7d0
 [<ffffffff804e8032>] __down_read+0x12/0xb0
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff881ad9b0>] :nfsd:nfsd+0x1a0/0x2f0
 [<ffffffff8020d068>] child_rip+0xa/0x12
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff8020d05e>] child_rip+0x0/0x12

WARNING: at lib/kref.c:33 kref_get()

Call Trace:
 [<ffffffff803a1315>] kref_get+0x35/0x40
 [<ffffffff88128f34>] :sunrpc:sunrpc_cache_lookup+0x64/0x160
 [<ffffffff881b5910>] :nfsd:svc_export_lookup+0xc0/0xd0
 [<ffffffff881b594f>] :nfsd:exp_get_by_name+0x2f/0x80
 [<ffffffff88128f34>] :sunrpc:sunrpc_cache_lookup+0x64/0x160
 [<ffffffff88127b89>] :sunrpc:cache_check+0x49/0x490
 [<ffffffff881b5fb7>] :nfsd:exp_find_key+0x57/0xc0
 [<ffffffff881b6064>] :nfsd:exp_find+0x44/0xa0
 [<ffffffff881b615e>] :nfsd:rqst_exp_find+0x9e/0xf0
 [<ffffffff881b0c45>] :nfsd:fh_verify+0x425/0x540
 [<ffffffff881bf25e>] :nfsd:nfsd4_proc_compound+0x1de/0x330
 [<ffffffff881ad271>] :nfsd:nfsd_dispatch+0xb1/0x250
 [<ffffffff8811fe91>] :sunrpc:svc_process+0x491/0x7d0
 [<ffffffff804e8032>] __down_read+0x12/0xb0
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff881ad9b0>] :nfsd:nfsd+0x1a0/0x2f0
 [<ffffffff8020d068>] child_rip+0xa/0x12
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff8020d05e>] child_rip+0x0/0x12

WARNING: at lib/kref.c:33 kref_get()

Call Trace:
 [<ffffffff803a1315>] kref_get+0x35/0x40
 [<ffffffff88128f34>] :sunrpc:sunrpc_cache_lookup+0x64/0x160
 [<ffffffff881b5910>] :nfsd:svc_export_lookup+0xc0/0xd0
 [<ffffffff881b594f>] :nfsd:exp_get_by_name+0x2f/0x80
 [<ffffffff88128f34>] :sunrpc:sunrpc_cache_lookup+0x64/0x160
 [<ffffffff88127b89>] :sunrpc:cache_check+0x49/0x490
 [<ffffffff881b5fb7>] :nfsd:exp_find_key+0x57/0xc0
 [<ffffffff881b6064>] :nfsd:exp_find+0x44/0xa0
 [<ffffffff881b615e>] :nfsd:rqst_exp_find+0x9e/0xf0
 [<ffffffff881b0c45>] :nfsd:fh_verify+0x425/0x540
 [<ffffffff881bf25e>] :nfsd:nfsd4_proc_compound+0x1de/0x330
 [<ffffffff881ad271>] :nfsd:nfsd_dispatch+0xb1/0x250
 [<ffffffff8811fe91>] :sunrpc:svc_process+0x491/0x7d0
 [<ffffffff804e8032>] __down_read+0x12/0xb0
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff881ad9b0>] :nfsd:nfsd+0x1a0/0x2f0
 [<ffffffff8020d068>] child_rip+0xa/0x12
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff8020d05e>] child_rip+0x0/0x12

general protection fault: 0000 [1] SMP 
CPU 0 
Modules linked in: des cbc blkcipher nfsd exportfs rpcsec_gss_krb5 auth_rpcgss nfs lockd nfs_acl sunrpc ipv6 dm_snapshot dm_mirror loop dm_round_robin dm_multipath dm_mod ata_piix ata_generic thermal mptfc libata processor scsi_transport_fc ehci_hcd e1000 evdev serio_raw psmouse uhci_hcd i2c_i801 i2c_core
Pid: 2863, comm: nfsd Not tainted 2.6.23.17 #1
RIP: 0010:[<ffffffff8819b113>]  [<ffffffff8819b113>] :auth_rpcgss:gss_get_mic+0x3/0x10
RSP: 0018:ffff81025c1d1c78  EFLAGS: 00010286
RAX: 762aba3d00000004 RBX: ffff81025b19f240 RCX: ffff81025c05c000
RDX: ffff81025c1d1cd0 RSI: ffff81025c1d1c80 RDI: ffff81025effa600
RBP: ffff81025c05c014 R08: 0000000000000000 R09: 0000000000000004
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81025effa600
R13: ffff81025b596000 R14: ffff81025c05c018 R15: ffff81025b596130
FS:  00002b540c07b6d0(0000) GS:ffffffff805fe000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fffa57e00e8 CR3: 000000025bb40000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process nfsd (pid: 2863, threadinfo ffff81025c1d0000, task ffff81025fe0c0c0)
Stack:  ffffffff8819c175 ffff81025c1d1cec 0000000000000004 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 0000000400000004
 0000000000000000 ffff81025c1d1cec 0000000000000004 ffff81025effa600
Call Trace:
 [<ffffffff8819c175>] :auth_rpcgss:gss_write_verf+0xa5/0x130
 [<ffffffff8819d408>] :auth_rpcgss:svcauth_gss_accept+0x8b8/0xc30
 [<ffffffff88120c7f>] :sunrpc:svc_sock_enqueue+0x19f/0x340
 [<ffffffff88122531>] :sunrpc:svc_tcp_recvfrom+0x81/0x980
 [<ffffffff80242250>] del_timer_sync+0x10/0x20
 [<ffffffff804e7057>] schedule_timeout+0x67/0xd0
 [<ffffffff80242060>] process_timeout+0x0/0x10
 [<ffffffff804e704a>] schedule_timeout+0x5a/0xd0
 [<ffffffff8811fd78>] :sunrpc:svc_process+0x378/0x7d0
 [<ffffffff80231d60>] default_wake_function+0x0/0x10
 [<ffffffff804e8032>] __down_read+0x12/0xb0
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff881ad9b0>] :nfsd:nfsd+0x1a0/0x2f0
 [<ffffffff8020d068>] child_rip+0xa/0x12
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff881ad810>] :nfsd:nfsd+0x0/0x2f0
 [<ffffffff8020d05e>] child_rip+0x0/0x12


Code: 48 8b 40 30 4c 8b 58 08 41 ff e3 66 90 48 8b 07 48 8b 40 30 
RIP  [<ffffffff8819b113>] :auth_rpcgss:gss_get_mic+0x3/0x10
 RSP <ffff81025c1d1c78>


kernel: invalid opcode: 0000 [2] SMP 
CPU 1 
Modules linked in: des cbc blkcipher nfsd exportfs rpcsec_gss_krb5 auth_rpcgss nfs lockd nfs_acl sunrpc ipv6 dm_snapshot dm_mirror loop dm_round_robin dm_multipath dm_mod ata_piix serio_raw mptfc psmouse scsi_transport_fc evdev ata_generic libata i2c_i801 e1000 i2c_core ehci_hcd uhci_hcd thermal processor
Pid: 2748, comm: multipathd Tainted: G      D 2.6.23.17 #1
RIP: 0010:[<ffffffff80291e9d>]  [<ffffffff80291e9d>] cache_alloc_refill+0x1ad/0x540
RSP: 0018:ffff810259aafe68  EFLAGS: 00010046
RAX: ffff81025e494040 RBX: 0000000000000020 RCX: 000000000000001c
RDX: ffff81025e494040 RSI: 000000000000000f RDI: ffff81025e810040
RBP: ffff81025fc6ec00 R08: ffff81025e810070 R09: 0000000000000000
R10: 0000000000159849 R11: 0000000000000000 R12: ffff81025fc00680
R13: ffff81025fc023c0 R14: 0000000000000000 R15: ffff81025fc0d000
FS:  0000000040061960(0063) GS:ffff81025fc6ce40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002ba20d8f4e30 CR3: 0000000259b10000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process multipathd (pid: 2748, threadinfo ffff810259aae000, task ffff81025fd06040)
Stack:  000000d000000010 ffffffff80291d6a 000000d0000080d0 ffff810259b19000
 0000000000000296 00000000000080d0 ffff81025fc00680 00007fff9d909298
 0000000040060e10 ffffffff80291cd2 0000000040062000 ffff810259b19000
Call Trace:
 [<ffffffff80291d6a>] cache_alloc_refill+0x7a/0x540
 [<ffffffff80291cd2>] kmem_cache_alloc+0x82/0xa0
 [<ffffffff8029bcf6>] do_execve+0x46/0x230
 [<ffffffff8020ae44>] sys_execve+0x44/0xb0
 [<ffffffff8020c617>] stub_execve+0x67/0xb0


Code: 0f 0b eb fe 49 8b 45 10 49 8d 55 10 48 89 78 08 48 89 07 48 
 RSP <ffff810259aafe68>


-- 
Luká¹ Hejtmánek
