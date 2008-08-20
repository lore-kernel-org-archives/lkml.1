Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYHTOL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYHTOL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbYHTOLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:11:05 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38411 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYHTOLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZOAa3IE3m07c4TCLXjN/vyGceEbue4/myq1TX8KB2AoJqXNuTx+dOKGql4KbIrGcgb
         cYjZ6o77oTvYrgr1n0wI3Dez7zBx6EYmM2lh9JfU27n4nFog8zbuLw4xUVYqAmlt3Izv
         dy9YX8rA/kiUcvvzu9Htl98G5DmWCdlHjqHLc=
Message-ID: <b647ffbd0808200711j49c6c9a8m9f0af6ade5f4338@mail.gmail.com>
Date: Wed, 20 Aug 2008 16:11:00 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: BUG: [2/2 -tip] x86-microcode: generic interface refactoring
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48AC2340.5010204@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219184546.10426.41.camel@earth> <48AC2340.5010204@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/20 Peter Oruba <peter.oruba@amd.com>:
> With latest tip-microcode I get the following:
>
> Aug 23 13:38:26 gai_nfs ------------[ cut here ]------------
> Aug 23 13:38:26 gai_nfs kernel BUG at arch/x86/kernel/microcode.c:351!

What's your kernel version?

I assume it does not have the following fix, doesn't it?

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=279ef6bbb8308488398c8f33b04c760148428378

sched, cpu hotplug: fix set_cpus_allowed() use in hotplug callbacks
author	Dmitry Adamushko <dmitry.adamushko@gmail.com>
	Wed, 30 Jul 2008 10:34:04 +0000 (12:34 +0200)
committer	Ingo Molnar <mingo@elte.hu>
	Mon, 11 Aug 2008 14:32:41 +0000 (16:32 +0200)
commit	279ef6bbb8308488398c8f33b04c760148428378


> Aug 23 13:38:26 gai_nfs invalid opcode: 0000 [1] SMP
> Aug 23 13:38:26 gai_nfs CPU 0
> Aug 23 13:38:26 gai_nfs Modules linked in: microcode_amd microcode
> Aug 23 13:38:26 gai_nfs Pid: 4258, comm: bash Not tainted 2.6.27-rc1 #10
> Aug 23 13:38:26 gai_nfs RIP: 0010:[<ffffffffa000048e>]  [<ffffffffa000048e>]
> microcode_update_cpu+0x1b/0xf1 [microcode]
> Aug 23 13:38:26 gai_nfs RSP: 0018:ffff88003ed41db8  EFLAGS: 00010297
> Aug 23 13:38:26 gai_nfs RAX: 0000000000000000 RBX: 0000000000000001 RCX:
> 00000000c0000100
> Aug 23 13:38:26 gai_nfs RDX: 0000000000000000 RSI: ffff88003f87cbf0 RDI:
> 0000000000000001
> Aug 23 13:38:26 gai_nfs RBP: 0000000000000001 R08: 0000000000000000 R09:
> ffff880001011ae0
> Aug 23 13:38:26 gai_nfs R10: 000000009f3b7578 R11: ffff88003f887de0 R12:
> 0000000000000000
> Aug 23 13:38:26 gai_nfs R13: 0000000000000001 R14: 0000000000000002 R15:
> ffffffff80739d00
> Aug 23 13:38:26 gai_nfs FS:  00007f0e312d26d0(0000)
> GS:ffffffff807b2a80(0000) knlGS:0000000000000000
> Aug 23 13:38:26 gai_nfs CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Aug 23 13:38:26 gai_nfs CR2: 00007f0f13293f20 CR3: 000000003e412000 CR4:
> 00000000000006a0
> Aug 23 13:38:26 gai_nfs DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> Aug 23 13:38:26 gai_nfs DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> Aug 23 13:38:26 gai_nfs Process bash (pid: 4258, threadinfo
> ffff88003ed40000, task ffff88003f3e5950)
> Aug 23 13:38:26 gai_nfs Stack:  ffff88000101c980 0000000000000296
> 0000000000000003 0000000000000001
> Aug 23 13:38:26 gai_nfs 0000000000000001 0000000000000001 0000000000000001
> ffffffffa00005ac
> Aug 23 13:38:26 gai_nfs 0000000000000003 0000000000000001 0000000000000282
> 0000000000000002
> Aug 23 13:38:26 gai_nfs Call Trace:
> Aug 23 13:38:26 gai_nfs [<ffffffffa00005ac>] ? microcode_init_cpu+0x48/0x61
> [microcode]
> Aug 23 13:38:26 gai_nfs [<ffffffffa00006a7>] ? mc_cpu_callback+0x2b/0x76
> [microcode]
> Aug 23 13:38:26 gai_nfs [<ffffffff80242ffd>] ? notifier_call_chain+0x29/0x4c
> Aug 23 13:38:26 gai_nfs [<ffffffff805ca600>] ? cpu_up+0x105/0x16a
> Aug 23 13:38:26 gai_nfs [<ffffffff805a99d7>] ? store_online+0x46/0x6d
> Aug 23 13:38:26 gai_nfs [<ffffffff802c431a>] ? sysfs_write_file+0xd0/0x107
> Aug 23 13:38:26 gai_nfs [<ffffffff80282b8c>] ? vfs_write+0xad/0x136
> Aug 23 13:38:26 gai_nfs [<ffffffff80282cd1>] ? sys_write+0x45/0x6e
> Aug 23 13:38:26 gai_nfs [<ffffffff8020be8b>] ?
> system_call_fastpath+0x16/0x1b

[ ... ]

-- 
Best regards,
Dmitry Adamushko
