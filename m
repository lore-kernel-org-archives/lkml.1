Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYHTPG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYHTPG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbYHTPGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:06:51 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:53769 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYHTPGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:06:50 -0400
X-BigFish: VPS-17(z1039oz1432R936eQ1805M936fQ873fnzz10d3izz5a6ciz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K5WNAZ-01-CZO-01
Message-ID: <48AC32FE.4040902@amd.com>
Date: Wed, 20 Aug 2008 17:06:38 +0200
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Max Krasnyansky <maxk@qualcomm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: [2/2 -tip] x86-microcode: generic interface refactoring
References: <1219184546.10426.41.camel@earth> <48AC2340.5010204@amd.com> <b647ffbd0808200711j49c6c9a8m9f0af6ade5f4338@mail.gmail.com>
In-Reply-To: <b647ffbd0808200711j49c6c9a8m9f0af6ade5f4338@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2008 15:06:38.0603 (UTC) FILETIME=[5864D5B0:01C902D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko schrieb:
> 2008/8/20 Peter Oruba <peter.oruba@amd.com>:
>> With latest tip-microcode I get the following:
>>
>> Aug 23 13:38:26 gai_nfs ------------[ cut here ]------------
>> Aug 23 13:38:26 gai_nfs kernel BUG at arch/x86/kernel/microcode.c:351!
> 
> What's your kernel version?
> 
> I assume it does not have the following fix, doesn't it?

Yep, that fix helped. Didn't find any other issues so far.
Thanks

> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=279ef6bbb8308488398c8f33b04c760148428378
> 
> sched, cpu hotplug: fix set_cpus_allowed() use in hotplug callbacks
> author	Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 	Wed, 30 Jul 2008 10:34:04 +0000 (12:34 +0200)
> committer	Ingo Molnar <mingo@elte.hu>
> 	Mon, 11 Aug 2008 14:32:41 +0000 (16:32 +0200)
> commit	279ef6bbb8308488398c8f33b04c760148428378
> 
> 
>> Aug 23 13:38:26 gai_nfs invalid opcode: 0000 [1] SMP
>> Aug 23 13:38:26 gai_nfs CPU 0
>> Aug 23 13:38:26 gai_nfs Modules linked in: microcode_amd microcode
>> Aug 23 13:38:26 gai_nfs Pid: 4258, comm: bash Not tainted 2.6.27-rc1 #10
>> Aug 23 13:38:26 gai_nfs RIP: 0010:[<ffffffffa000048e>]  [<ffffffffa000048e>]
>> microcode_update_cpu+0x1b/0xf1 [microcode]
>> Aug 23 13:38:26 gai_nfs RSP: 0018:ffff88003ed41db8  EFLAGS: 00010297
>> Aug 23 13:38:26 gai_nfs RAX: 0000000000000000 RBX: 0000000000000001 RCX:
>> 00000000c0000100
>> Aug 23 13:38:26 gai_nfs RDX: 0000000000000000 RSI: ffff88003f87cbf0 RDI:
>> 0000000000000001
>> Aug 23 13:38:26 gai_nfs RBP: 0000000000000001 R08: 0000000000000000 R09:
>> ffff880001011ae0
>> Aug 23 13:38:26 gai_nfs R10: 000000009f3b7578 R11: ffff88003f887de0 R12:
>> 0000000000000000
>> Aug 23 13:38:26 gai_nfs R13: 0000000000000001 R14: 0000000000000002 R15:
>> ffffffff80739d00
>> Aug 23 13:38:26 gai_nfs FS:  00007f0e312d26d0(0000)
>> GS:ffffffff807b2a80(0000) knlGS:0000000000000000
>> Aug 23 13:38:26 gai_nfs CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> Aug 23 13:38:26 gai_nfs CR2: 00007f0f13293f20 CR3: 000000003e412000 CR4:
>> 00000000000006a0
>> Aug 23 13:38:26 gai_nfs DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> Aug 23 13:38:26 gai_nfs DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> Aug 23 13:38:26 gai_nfs Process bash (pid: 4258, threadinfo
>> ffff88003ed40000, task ffff88003f3e5950)
>> Aug 23 13:38:26 gai_nfs Stack:  ffff88000101c980 0000000000000296
>> 0000000000000003 0000000000000001
>> Aug 23 13:38:26 gai_nfs 0000000000000001 0000000000000001 0000000000000001
>> ffffffffa00005ac
>> Aug 23 13:38:26 gai_nfs 0000000000000003 0000000000000001 0000000000000282
>> 0000000000000002
>> Aug 23 13:38:26 gai_nfs Call Trace:
>> Aug 23 13:38:26 gai_nfs [<ffffffffa00005ac>] ? microcode_init_cpu+0x48/0x61
>> [microcode]
>> Aug 23 13:38:26 gai_nfs [<ffffffffa00006a7>] ? mc_cpu_callback+0x2b/0x76
>> [microcode]
>> Aug 23 13:38:26 gai_nfs [<ffffffff80242ffd>] ? notifier_call_chain+0x29/0x4c
>> Aug 23 13:38:26 gai_nfs [<ffffffff805ca600>] ? cpu_up+0x105/0x16a
>> Aug 23 13:38:26 gai_nfs [<ffffffff805a99d7>] ? store_online+0x46/0x6d
>> Aug 23 13:38:26 gai_nfs [<ffffffff802c431a>] ? sysfs_write_file+0xd0/0x107
>> Aug 23 13:38:26 gai_nfs [<ffffffff80282b8c>] ? vfs_write+0xad/0x136
>> Aug 23 13:38:26 gai_nfs [<ffffffff80282cd1>] ? sys_write+0x45/0x6e
>> Aug 23 13:38:26 gai_nfs [<ffffffff8020be8b>] ?
>> system_call_fastpath+0x16/0x1b
> 
> [ ... ]
> 

-- 
            |           AMD Saxony Limited Liability Company & Co. KG
  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
  System    |                  Register Court Dresden: HRA 4896
  Research  |              General Partner authorized to represent:
  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

