Return-Path: <linux-kernel-owner+w=401wt.eu-S934351AbXJRP65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbXJRP65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764991AbXJRP4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:56:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765941AbXJRP4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:56:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=sTcAxBDrOtHW331q+lX7ufnrkkAdJzSSMTM603W1lmI+k6YF5LkxyTRYkJy/gmuuE
	xL7bDWu2ReXDmF9dLWRfg==
Message-ID: <6599ad830710180856r45948c15t5cb04d06c0faff78@mail.gmail.com>
Date: Thu, 18 Oct 2007 08:56:34 -0700
From: "Paul Menage" <menage@google.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: 2.6.23-mm1 - list_add corruption in cgroup
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4716303C.8020009@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <4716303C.8020009@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
> Hello !
>
> While polling the contents of a cgroup task file, I caught the
> following corruption. Is there a known race (and a fix) or should
> I start digging ?

Not a known race, no. Sorry, didn't have time to look at this
yesterday since I was out of the office all day; I'll try to get a
chance today.

Paul

>
> the program running in the cgroup is fork/exec intensive:
>
>  while (1) {
>         int i, s;
>
>         for (i = 0; i < count; i++)
>             if (fork() == 0)
>                 execlp("/bin/true", "true", 0);
>
>         for (i = 0; i < count; i++)
>             wait(&s);
>     }
>
> Thanks for any insights,
>
> C.
>
>
>
>  list_add corruption. next->prev should be prev (ffffffff80a3f338), but was 0000000000200200. (next=ffff810103dcbe90).
> ------------[ cut here ]------------
> kernel BUG at /home/legoater/linux/2.6.23-mm1/lib/list_debug.c:27!
> invalid opcode: 0000 [1] SMP
> last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:01:01.0/local_cpus
> CPU 3
> Modules linked in: ipt_REJECT iptable_filter autofs4 nfs lockd sunrpc tg3 sg joydev ext3 jbd ehci_hcd ohci_hcd uhci_hcd
> Pid: 2441, comm: bash Not tainted 2.6.23-mm1 #4
> RIP: 0010:[<ffffffff80308cda>]  [<ffffffff80308cda>] __list_add+0x27/0x5b
> RSP: 0018:ffff810103d87dd8  EFLAGS: 00010296
> RAX: 0000000000000079 RBX: ffff810105033040 RCX: 0000000000000079
> RDX: ffff810103d960c0 RSI: 0000000000000001 RDI: 0000000000000096
> RBP: ffff810103d87dd8 R08: 0000000000000002 R09: ffff810008123780
> R10: 0000000000000000 R11: ffff810103d87a98 R12: 0000000000000000
> R13: ffff810105033040 R14: ffff810104c11ac0 R15: 0000000000000000
> FS:  00007f4e273556f0(0000) GS:ffff81010011a840(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000006ca2f8 CR3: 0000000103d82000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bash (pid: 2441, threadinfo ffff810103d86000, task ffff810103d960c0)
> last branch before last exception/interrupt
>  from  [<ffffffff80235885>] printk+0x68/0x69
>  to  [<ffffffff80308cda>] __list_add+0x27/0x5b
> Stack:  ffff810103d87de8 ffffffff80308d1a ffff810103d87e08 ffffffff802606bf
>  ffff810103d87e08 0000000000000000 ffff810103d87ea8 ffffffff80233dca
>  ffff810103ddf340 00007f4e27355780 0000000000000000 ffff810103d87f58
> Call Trace:
>  [<ffffffff80308d1a>] list_add+0xc/0xe
>  [<ffffffff802606bf>] cgroup_post_fork+0x41/0x52
>  [<ffffffff80233dca>] copy_process+0x12d0/0x143a
>  [<ffffffff8020b9b5>] tracesys+0xdc/0xe1
>  [<ffffffff80234095>] do_fork+0x76/0x203
>  [<ffffffff802679cc>] audit_syscall_entry+0x148/0x17e
>  [<ffffffff8020b9b5>] tracesys+0xdc/0xe1
>  [<ffffffff80209dd5>] sys_clone+0x23/0x25
>  [<ffffffff8020bb67>] ptregscall_common+0x67/0xb0
>
> INFO: lockdep is turned off.
>
> Code: 0f 0b eb fe 4c 8b 00 49 39 f0 74 18 48 89 c1 4c 89 c2 48 c7
> RIP  [<ffffffff80308cda>] __list_add+0x27/0x5b
>  RSP <ffff810103d87dd8>
> BUG: soft lockup - CPU#1 stuck for 11s! [true:2030]
> CPU 1:
> Modules linked in: ipt_REJECT iptable_filter autofs4 nfs lockd sunrpc tg3 sg joydev ext3 jbd ehci_hcd ohci_hcd uhci_hcd
> Pid: 2030, comm: true Tainted: G      D 2.6.23-mm1 #4
> RIP: 0010:[<ffffffff80306baf>]  [<ffffffff80306baf>] __write_lock_failed+0xf/0x20
> RSP: 0018:ffff81010513be80  EFLAGS: 00000287
> RAX: 0000000000000001 RBX: ffff81010513be98 RCX: ffffffff807d8d60
> RDX: 0000000000000037 RSI: 0000000000000037 RDI: ffffffff805beac0
> RBP: ffff81010289e040 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff8026072c R11: ffff81010513be08 R12: ffff81000812c300
> R13: ffff81010289e040 R14: ffff81010513a000 R15: ffff810087acb000
> FS:  0000000000000000(0000) GS:ffff8101000560c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f8171b028b0 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>
> Call Trace:
>  [<ffffffff80308a1d>] _raw_write_lock+0x6c/0x8b
>  [<ffffffff8026072c>] cgroup_exit+0x5c/0xc3
>  [<ffffffff80474803>] _write_lock+0x2d/0x31
>  [<ffffffff8026072c>] cgroup_exit+0x5c/0xc3
>  [<ffffffff802383c1>] do_exit+0x2a0/0x7a5
>  [<ffffffff80238955>] sys_exit_group+0x0/0x14
>  [<ffffffff80238967>] sys_exit_group+0x12/0x14
>  [<ffffffff8020b9b5>] tracesys+0xdc/0xe1
>
