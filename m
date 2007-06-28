Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbXF1VkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbXF1VkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763953AbXF1VkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:40:11 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:29396 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761852AbXF1VkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kiQU+YlnCEqZ4zhXySDZq7hTDgMxGnukdPWbb1nc1uBFMOZUHWPu94Ow1hykEkbMEHF6AI36W8k6LQfvzSrjOl+Dq3oj4X2H5g6Q4ITA7zqGDlR47kMs26sExLJYtcUaNvcLpTffqe0x/FsZSe+rcaeSYWP8r6DuwUD9+RfmlOE=
Message-ID: <e9c3a7c20706281440t4ceaac58sc966de34cb5f42f6@mail.gmail.com>
Date: Thu, 28 Jun 2007 14:40:07 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>,
       "john stultz" <johnstul@us.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <e9c3a7c20706281423p27059e90qe7f986d7485753a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
	 <1182823276.5493.240.camel@localhost.localdomain>
	 <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com>
	 <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com>
	 <e9c3a7c20706281102l5db2e91alf465e7983d68f284@mail.gmail.com>
	 <Pine.LNX.4.58.0706281632510.27157@gandalf.stny.rr.com>
	 <e9c3a7c20706281423p27059e90qe7f986d7485753a7@mail.gmail.com>
X-Google-Sender-Auth: 8b3ae7c84abff6be
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Dan Williams <dan.j.williams@intel.com> wrote:
> Everything thus far has been CONFIG_PREEMPT=n (the default for this platform).
>
> With CONFIG_PREEMPT=y the resync is back in the 50MB/s range.
>
> [iop-adma: hi-prio workqueue, CONFIG_PREEMPT=y]
> iq81340mc:~# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid5 sdd[4] sdc[2] sdb[1] sda[0]
>       468872448 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>       [=>...................]  recovery =  5.8% (9136404/156290816)
> finish=46.1min speed=53161K/sec
>
> The tasklet configuration stays in 50MB/s ballpark, and the default
> priority (nice -5) workqueue case remains in the 30's with
> CONFIG_PREEMPT=n.
>
That last line should be CONFIG_PREEMPT=y

But I guess there is a reason it is still marked experimental...

iq81340mc:/data_dir# ./md0_verify.sh
kernel BUG at mm/page_alloc.c:363!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = b29b8000
[00000000] *pgd=00000000
Internal error: Oops: 805 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.22-rc6 #144)
PC is at __bug+0x20/0x2c
LR is at 0x403f37a0
pc : [<4002ef08>]    lr : [<403f37a0>]    psr: 60000093
sp : b28a3cc8  ip : 01d80000  fp : b28a3cd4
r10: 00000001  r9 : 00000001  r8 : 00000000
r7 : 0000004f  r6 : ffffffe0  r5 : 412919c0  r4 : 412919e0
r3 : 00000000  r2 : 403f37a0  r1 : 60000093  r0 : 00000026
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  Segment user
Control: 0400397f  Table: 729b8018  DAC: 00000015
Process md0_verify_kern (pid: 4188, stack limit = 0xb28a2258)
Stack: (0xb28a3cc8 to 0xb28a4000)
3cc0:                   b28a3d1c b28a3cd8 40070a90 4002eef4 b28a2000 403f6818
3ce0: 403f682c 40000013 403f6838 0000001f 00000010 4129c3c0 20000013 15573000
3d00: 4129c3c0 00000000 b28a4550 00000000 b28a3d2c b28a3d20 40070b54 400706b8
3d20: b28a3d44 b28a3d30 40073e7c 40070b4c 4129c3c0 15574000 b28a3d58 b28a3d48
3d40: 40084734 40073e34 b3e0fdcc b28a3dcc b28a3d5c 40079cd8 400846f8 ffffffff
3d60: 00000000 b39a4860 b28a3ddc 00000000 00000001 15574000 b28a2000 4040d548
3d80: b28a4550 b3357240 72d9e0ff ffffffff 00000000 15573fff 00003ffe 15574000
3da0: 15573fff 4040d548 b28a3ddc b2c15320 b28a2000 00000000 b333cc00 b3357240
3dc0: b28a3e04 b28a3dd0 4007d724 40079844 b28a3dd8 00000000 00000015 4040d548
3de0: b3357240 b28f6920 b28a2000 b3357240 b3357240 b3a4f9c0 b28a3e18 b28a3e08
3e00: 4003f2d8 4007d6b4 b3a462e0 b28a3e5c b28a3e1c 40095e70 4003f2a0 00000000
3e20: 00000000 b28a3e3c 00000013 b28a3e5c b28a3e3c b333cc10 b3c15cc0 b333cc00
3e40: 00000080 b28a3fb0 00000000 00000000 b28a3f2c b28a3e60 400c8270 400958f0
3e60: 00000000 b28a3ec8 b28a2000 b3c15c00 00000003 00000000 b29e54a0 00000014
3e80: 00000044 b38b4f00 00000002 00000000 00000000 00000001 403f6aac 403f6aac
3ea0: b333cc7c b3a462e0 000200d2 00000000 403f6aa8 b28a2000 b333cd30 b28a3f08
3ec0: b28a3ecc 40070c38 4006fdbc 000200d2 403f6aac 00000010 41295a60 b28a2000
3ee0: b333cc7c 00000000 b333cc00 b333cc00 00000003 0001fff3 0000004f 0000004f
3f00: b333cc00 403f72a8 b28a2000 400c7e60 00000000 b333cc00 b28a3fb0 fffffffe
3f20: b28a3f5c b28a3f30 40095054 400c7e6c 00000000 b4503000 000bf408 b333cc00
3f40: 00000000 000bf628 b28a2000 b28a3fb0 b28a3f84 b28a3f60 40096c3c 40094f58
3f60: b4503000 000bf408 b28a3fb0 b4503000 4002b0e4 156da000 b28a3fa4 b28a3f88
3f80: 4002e3cc 40096b24 000bf408 000bf628 000bf788 0000000b 00000000 b28a3fa8
3fa0: 4002af20 4002e39c 000bf408 000bf628 000bf788 000bf628 000bf408 00000000
3fc0: 000bf408 000bf628 000bf788 ffffffff 000bf628 000bf408 156da000 000be848
3fe0: 15651550 3eb7e4ac 0002b4f0 1565158c 60000010 000bf788 00000000 00000000
Backtrace:
[<4002eee8>] (__bug+0x0/0x2c) from [<40070a90>] (free_hot_cold_page+0x3e4/0x434)
[<400706ac>] (free_hot_cold_page+0x0/0x434) from [<40070b54>]
(free_hot_page+0x14/0x18)
[<40070b40>] (free_hot_page+0x0/0x18) from [<40073e7c>] (put_page+0x54/0x174)
[<40073e28>] (put_page+0x0/0x174) from [<40084734>]
(free_page_and_swap_cache+0x48/0x64)
 r5:15574000 r4:4129c3c0
[<400846ec>] (free_page_and_swap_cache+0x0/0x64) from [<40079cd8>]
(unmap_vmas+0x4a0/0x67c)
 r4:b3e0fdcc
[<40079838>] (unmap_vmas+0x0/0x67c) from [<4007d724>] (exit_mmap+0x7c/0x158)
[<4007d6a8>] (exit_mmap+0x0/0x158) from [<4003f2d8>] (mmput+0x44/0x100)
[<4003f294>] (mmput+0x0/0x100) from [<40095e70>] (flush_old_exec+0x58c/0x9d8)
 r4:b3a462e0
[<400958e4>] (flush_old_exec+0x0/0x9d8) from [<400c8270>]
(load_elf_binary+0x410/0x18fc)
[<400c7e60>] (load_elf_binary+0x0/0x18fc) from [<40095054>]
(search_binary_handler+0x108/0x2b4)
[<40094f4c>] (search_binary_handler+0x0/0x2b4) from [<40096c3c>]
(do_execve+0x124/0x1e4)
[<40096b18>] (do_execve+0x0/0x1e4) from [<4002e3cc>] (sys_execve+0x3c/0x5c)
[<4002e390>] (sys_execve+0x0/0x5c) from [<4002af20>] (ret_fast_syscall+0x0/0x3c)
 r7:0000000b r6:000bf788 r5:000bf628 r4:000bf408
Code: e1a01000 e59f000c eb004d60 e3a03000 (e5833000)
note: md0_verify_kern[4188] exited with preempt_count 4
