Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbXHQLzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbXHQLzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 07:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbXHQLzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 07:55:25 -0400
Received: from pat.uio.no ([129.240.10.15]:59821 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849AbXHQLzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 07:55:23 -0400
Subject: Re: [2.6.23-rc3] NFSv4 client oops
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46C37958.7000401@garzik.org>
References: <46C37958.7000401@garzik.org>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 07:55:18 -0400
Message-Id: <1187351718.7490.38.camel@gaula.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-1.2, required=12.0, autolearn=disabled, AWL=-1.250)
X-UiO-Scanned: A671FD9D4B6EF81BADDFED073DFE5C837689265D
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: -11 maxlevel 200 minaction 2 bait 0 mail/h: 1686 total 3307739 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 18:08 -0400, Jeff Garzik wrote:
> While upgrading nfs-utils on my NFSv4 file server (F7 x86-64 
> 2.6.23-rc3), I got an oops on the NFSv4 client (FC6 x86-64 2.6.23-rc3), 
> and communications stopped.
> 
> I rebooted the client, and everything was fine again.  Then, on the 
> server, I removed an extra nfs-utils package left over from FC6, causing 
> the nfs daemons to be restarted.  Another oops.
> 
> So it seems like whatever Fedora does during an nfs-utils upgrade __on 
> the server__ is causing a remote oops __on the client__.
> 
> NFSv4 client kernel config also attached.
> 
> Never seen this problem before, but then again, never did a remote OS 
> upgrade of the fileserver while running NFSv4 before.
> 
> 	Jeff
> 
> 
> plain text document attachment (log.txt)
> Aug 15 15:44:23 core kernel: nfs: server pretzel not responding, timed out
> Aug 15 15:44:23 core last message repeated 8 times
> Aug 15 15:44:23 core kernel: ------------[ cut here ]------------
> Aug 15 15:44:23 core kernel: kernel BUG at fs/nfs/nfs4xdr.c:1040!
> Aug 15 15:44:23 core kernel: invalid opcode: 0000 [1] SMP 
> Aug 15 15:44:23 core kernel: CPU 0 
> Aug 15 15:44:23 core kernel: Modules linked in: nfs lockd sunrpc af_packet ipv6 cpufreq_ondemand acpi_cpufreq battery floppy nvram sg snd_hda_intel ata_generic snd_pcm_oss snd_mixer_oss snd_pcm i2c_i801 snd_page_alloc e1000 firewire_ohci ata_piix i2c_core sr_mod cdrom sata_sil ahci libata sd_mod scsi_mod ext3 jbd ehci_hcd uhci_hcd
> Aug 15 15:44:23 core kernel: Pid: 16353, comm: 10.10.10.1-recl Not tainted 2.6.23-rc3 #1
> Aug 15 15:44:23 core kernel: RIP: 0010:[<ffffffff88240980>]  [<ffffffff88240980>] :nfs:encode_open+0x1c0/0x330
> Aug 15 15:44:23 core kernel: RSP: 0018:ffff8100467c5c60  EFLAGS: 00010202
> Aug 15 15:44:23 core kernel: RAX: ffff81000f89b8b8 RBX: 00000000697a6f6d RCX: ffff81000f89b8b8
> Aug 15 15:44:23 core kernel: RDX: 0000000000000004 RSI: 0000000000000004 RDI: ffff8100467c5c80
> Aug 15 15:44:23 core kernel: RBP: ffff8100467c5c80 R08: ffff81000f89bc30 R09: ffff81000f89b83f
> Aug 15 15:44:23 core kernel: R10: 0000000000000001 R11: ffffffff881e79e0 R12: ffff81003cbd1808
> Aug 15 15:44:23 core kernel: R13: ffff81000f89b860 R14: ffff81005fc984e0 R15: ffffffff88240af0
> Aug 15 15:44:23 core kernel: FS:  0000000000000000(0000) GS:ffffffff8052a000(0000) knlGS:0000000000000000
> Aug 15 15:44:23 core kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> Aug 15 15:44:23 core kernel: CR2: 00002adb9e51a030 CR3: 000000007ea7e000 CR4: 00000000000006e0
> Aug 15 15:44:23 core kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Aug 15 15:44:23 core kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Aug 15 15:44:23 core kernel: Process 10.10.10.1-recl (pid: 16353, threadinfo ffff8100467c4000, task ffff8100038ce780)
> Aug 15 15:44:23 core kernel: Stack:  ffff81004aeb6a40 ffff81003cbd1808 ffff81003cbd1808 ffffffff88240b5d
> Aug 15 15:44:23 core kernel:  ffff81000f89b8bc ffff81005fc984e8 ffff81000f89bc30 ffff81005fc984e8
> Aug 15 15:44:23 core kernel:  0000000300000000 0000000000000000 0000000000000000 ffff81003cbd1800
> Aug 15 15:44:23 core kernel: Call Trace:
> Aug 15 15:44:23 core kernel:  [<ffffffff88240b5d>] :nfs:nfs4_xdr_enc_open_noattr+0x6d/0x90
> Aug 15 15:44:23 core kernel:  [<ffffffff881e74b7>] :sunrpc:rpcauth_wrap_req+0x97/0xf0
> Aug 15 15:44:23 core kernel:  [<ffffffff88240af0>] :nfs:nfs4_xdr_enc_open_noattr+0x0/0x90
> Aug 15 15:44:23 core kernel:  [<ffffffff881df57a>] :sunrpc:call_transmit+0x18a/0x290
> Aug 15 15:44:23 core kernel:  [<ffffffff881e5e7b>] :sunrpc:__rpc_execute+0x6b/0x290
> Aug 15 15:44:23 core kernel:  [<ffffffff881dff76>] :sunrpc:rpc_do_run_task+0x76/0xd0
> Aug 15 15:44:23 core kernel:  [<ffffffff882373f6>] :nfs:_nfs4_proc_open+0x76/0x230
> Aug 15 15:44:23 core kernel:  [<ffffffff88237a2e>] :nfs:nfs4_open_recover_helper+0x5e/0xc0
> Aug 15 15:44:23 core kernel:  [<ffffffff88237b74>] :nfs:nfs4_open_recover+0xe4/0x120
> Aug 15 15:44:23 core kernel:  [<ffffffff88238e14>] :nfs:nfs4_open_reclaim+0xa4/0xf0
> Aug 15 15:44:23 core kernel:  [<ffffffff882413c5>] :nfs:nfs4_reclaim_open_state+0x55/0x1b0
> Aug 15 15:44:23 core kernel:  [<ffffffff882417ea>] :nfs:reclaimer+0x2ca/0x390
> Aug 15 15:44:23 core kernel:  [<ffffffff88241520>] :nfs:reclaimer+0x0/0x390
> Aug 15 15:44:23 core kernel:  [<ffffffff8024e59b>] kthread+0x4b/0x80
> Aug 15 15:44:23 core kernel:  [<ffffffff8020cad8>] child_rip+0xa/0x12
> Aug 15 15:44:23 core kernel:  [<ffffffff8024e550>] kthread+0x0/0x80
> Aug 15 15:44:23 core kernel:  [<ffffffff8020cace>] child_rip+0x0/0x12
> Aug 15 15:44:23 core kernel: 
> Aug 15 15:44:23 core kernel: 
> Aug 15 15:44:23 core kernel: Code: 0f 0b eb fe 48 89 ef c7 00 00 00 00 02 be 08 00 00 00 e8 79 
> Aug 15 15:44:23 core kernel: RIP  [<ffffffff88240980>] :nfs:encode_open+0x1c0/0x330
> Aug 15 15:44:23 core kernel:  RSP <ffff8100467c5c60>
> Aug 15 15:44:23 core kernel: nfs: server pretzel OK
> Aug 15 15:45:02 core shutdown[16390]: shutting down for system reboot
> 
> [...]

OK. That probably indicates an error in the calculation of
NFS4_enc_open_noattr_sz (it that the resulting value is too small). I'll
have a look this weekend...

Cheers
  Trond

