Return-Path: <linux-kernel-owner+w=401wt.eu-S1763951AbZDCMQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763951AbZDCMQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbZDCMQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:16:06 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:53914 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbZDCMQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:x-comment:date:to:from:subject:cc:in-reply-to:references
         :mime-version:content-type;
        b=YHML0RFd+mVeKKxBvU8ueV7TaQh6zgfXb7ms7HvX1+cVbwvi7XM1LEFqrMtQx/O8lp
         HJbK8hO+s1k0/4DDqLG/Thl1PGyC/8ZeyxC8L1NemH822WAxmeMXcpmTGvz5zFpiCBvA
         qKZXCtyEDUgGlOweyitFFpa6LPctO/wHUgF50=
Message-ID: <49d5fe00.86c3f10a.0641.ffffbbdd@mx.google.com>
X-Comment: 
Date: Fri, 03 Apr 2009 08:15:08 -0400
To: Ingo Molnar <mingo@elte.hu>
From: Tom Talpey <tmtalpey@gmail.com>
Subject: Re: [PATCH] nfs: fix nfs_parse_mount_options() double kfree()
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Yinghai Lu <yinghai@kernel.org>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>, chuck.lever@oracle.com
In-Reply-To: <20090403071638.GB14498@elte.hu>
References: <86802c440904021512o2405ffa2gcbe057b9f81d5a46@mail.gmail.com>
 <20090402222106.GC9239@elte.hu>
 <49D56415.1080402@kernel.org>
 <84144f020904022252v2dbc18f5o35cc9737bf6d146d@mail.gmail.com>
 <20090403071638.GB14498@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03:16 AM 4/3/2009, Ingo Molnar wrote:
>
>Impact: fix crash
>
>Yinghai Lu reported the following crash:

This has to have been a merge problem, I moved a single kfree()
down a few lines in order to use the pointer in a second context.
With the moved line, it had been running successfully in Trond's
tree and linux-next for several weeks.

Thanks for fixing!

Tom.

>
>> mpk12-3214-189-158:~ # sh x
>> [   63.198629] ------------[ cut here ]------------
>> [   63.202589] kernel BUG at mm/slub.c:2753!
>> [   63.202589] invalid opcode: 0000 [#1] SMP
>> [   63.202589] last sysfs file: /sys/devices/virtual/net/sit0/type
>> [   63.202589] CPU 0
>> [   63.202589] Modules linked in:
>> [   63.202589] Pid: 10027, comm: mount.nfs Not tainted 
>2.6.29-07100-g833bb30 #21 Sun Fire X4440
>> [   63.202589] RIP: 0010:[<ffffffff802e0015>]  [<ffffffff802e0015>] 
>kfree+0x5a/0xcd
>> [   63.202589] RSP: 0018:ffff882042ceb9f8  EFLAGS: 00010246
>> [   63.202589] RAX: 0200000000000000 RBX: 0000000000000005 RCX: 
>ffffffff80a7dc1f
>> [   63.202589] RDX: ffffe20000000000 RSI: ffffc2000000f470 RDI: 
>ffffe2001c018950
>> [   63.202589] RBP: ffff882042ceba18 R08: 0000000000000000 R09: 
>ffffffff811019c0
>> [   63.202589] R10: 000000004262ce02 R11: ffff882042ceba18 R12: 
>ffff880800706475
>> [   63.202589] R13: ffff882042886000 R14: ffff882042cebbd8 R15: 
>ffff882042cebbf0
>> [   63.202589] FS:  00007fac729ed6f0(0000) GS:ffffc20000000000(0000) 
>knlGS:0000000000000000
>> [   63.202589] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [   63.202589] CR2: 00007fac72c12000 CR3: 0000001841cbb000 CR4: 
>00000000000006e0
>> [   63.202589] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>0000000000000000
>> [   63.202589] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
>0000000000000400
>> [   63.202589] Process mount.nfs (pid: 10027, threadinfo 
>ffff882042cea000, task ffff8820434dc290)
>> [   63.202589] Stack:
>> [   63.202589]  ffff882042ceba18 000000004262ce02 0000000000000005 
>ffff882042886028
>> [   63.202589]  ffff882042ceba58 ffffffff80a7dc1f 000000004262ce02 
>ffff882042886000
>> [   63.202589]  000000004262ce02 ffff882042886000 ffffffff80a7b4a6 
>ffff882042c9ee18
>> [   63.202589] Call Trace:
>> [   63.202589]  [<ffffffff80a7dc1f>] xs_destroy+0x67/0xac
>> [   63.202589]  [<ffffffff80a7b4a6>] ? xprt_destroy+0x0/0xa7
>> [   63.202589]  [<ffffffff80a7b532>] xprt_destroy+0x8c/0xa7
>> [   63.202589]  [<ffffffff80a823b2>] ? put_rpccred+0x112/0x131
>> [   63.202589]  [<ffffffff8051cdd5>] kref_put+0x65/0x87
>> [   63.202589]  [<ffffffff80a7a9a9>] ? rpc_free_client+0x0/0xf9
>> [   63.202589]  [<ffffffff80a7b490>] xprt_put+0x23/0x39
>> [   63.202589]  [<ffffffff80a7aa7a>] rpc_free_client+0xd1/0xf9
>> [   63.202589]  [<ffffffff80a83345>] ? unx_destroy+0x3c/0x57
>> [   63.202589]  [<ffffffff8051cdd5>] kref_put+0x65/0x87
>> [   63.202589]  [<ffffffff80a7aaa2>] ? rpc_free_auth+0x0/0x69
>> [   63.202589]  [<ffffffff80a7aaf0>] rpc_free_auth+0x4e/0x69
>> [   63.202589]  [<ffffffff8025b827>] ? __wake_up+0x52/0x75
>> [   63.202589]  [<ffffffff8051cdd5>] kref_put+0x65/0x87
>> [   63.202589]  [<ffffffff80a7a98e>] rpc_release_client+0x64/0x7f
>> [   63.202589]  [<ffffffff80a8061c>] ? rpc_put_task+0xb0/0xcb
>> [   63.202589]  [<ffffffff80a7abe0>] rpc_shutdown_client+0xd5/0xf8
>> [   63.202589]  [<ffffffff80a7a893>] ? rpc_call_sync+0x63/0x80
>> [   63.202589]  [<ffffffff803fc4ab>] nfs_mount+0x11f/0x1bf
>> [   63.202589]  [<ffffffff803f3036>] nfs_get_sb+0x4ac/0x82a
>> [   63.202589]  [<ffffffff802e8f24>] vfs_kern_mount+0x61/0xbf
>> [   63.202589]  [<ffffffff802fea1d>] ? get_fs_type+0x58/0xc5
>> [   63.202589]  [<ffffffff802e9015>] do_kern_mount+0x56/0x108
>> [   63.202589]  [<ffffffff80302195>] do_mount+0x729/0x788
>> [   63.202589]  [<ffffffff80300025>] ? copy_mount_options+0xdf/0x155
>> [   63.202589]  [<ffffffff8030228c>] sys_mount+0x98/0xf8
>> [   63.202589]  [<ffffffff80230d6b>] system_call_fastpath+0x16/0x1b
>> [   63.202589] Code: 0c 48 ba 00 00 00 00 00 e2 ff ff 48 6b c0 38 48 
>8d 3c 10 48 8b 07 f6 c4 40 74 04 48 8b 7f 10 48 8b 07 84 c0 78 10 f6 
>c4 60 75 04 <0f> 0b eb fe e8 90 75 fd ff eb 4c 48 8b 4d 08 4c 8b 4f 10 9c 5b
>> [   63.202589] RIP  [<ffffffff802e0015>] kfree+0x5a/0xcd
>> [   63.202589]  RSP <ffff882042ceb9f8>
>> [   63.524555] ---[ end trace cd0d38e02ad11d61 ]---
>
>Pekka observed that a bogus pointer was passed to kfree().
>
>This commit:
>
>  a67d18f: NFS: load the rpc/rdma transport module automatically
>
>Moved a kfree() of the options strings in nfs_parse_mount_options()
>inadvertently and introduced a double kfree(). Fix it.
>
>Reported-by: Yinghai Lu <yinghai@kernel.org>
>Analyzed-by: Pekka Enberg <penberg@cs.helsinki.fi>
>Signed-off-by: Ingo Molnar <mingo@elte.hu>
>---
> fs/nfs/super.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/fs/nfs/super.c b/fs/nfs/super.c
>index 0942fcb..4e7f879 100644
>--- a/fs/nfs/super.c
>+++ b/fs/nfs/super.c
>@@ -1191,7 +1191,6 @@ static int nfs_parse_mount_options(char *raw,
> 				goto out_nomem;
> 			token = match_token(string,
> 					    nfs_xprt_protocol_tokens, args);
>-			kfree(string);
> 
> 			switch (token) {
> 			case Opt_xprt_udp:
>@@ -1221,6 +1220,7 @@ static int nfs_parse_mount_options(char *raw,
> 				goto out_nomem;
> 			token = match_token(string,
> 					    nfs_xprt_protocol_tokens, args);
>+			kfree(string);
> 
> 			switch (token) {
> 			case Opt_xprt_udp:

