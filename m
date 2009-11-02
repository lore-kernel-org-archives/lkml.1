Return-Path: <linux-kernel-owner+w=401wt.eu-S932538AbZKBXL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbZKBXL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbZKBXL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:11:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:14099 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbZKBXL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:11:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=COiwIKi4lUgFroLaEzwc1RmVsOGE3XJCfQZFOshccgoCJjPtMD+RHC6v31gzF9AZZ6
         OygOjdGmR4ZnOB8AwY3DSVTGTcSwnPlpDinhORptXrj7uEp0NIJmvgnUSsLHujhdP81V
         8mXEzZrluKOTYrvzmfL1qep2AdajP7HgRW3rA=
Message-ID: <4AEF673E.5030509@gmail.com>
Date: Tue, 03 Nov 2009 00:11:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, hbabu@us.ibm.com,
       kexec@lists.infradead.org
Subject: kdump fails to load and crashes [was: mmotm 2009-11-01-10-01 uploaded]
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
In-Reply-To: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 07:07 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to

Hi, kdump loading crashes:
BUG: unable to handle kernel paging request at ffff8800010a7000
IP: [<ffffffff8101cd8b>] machine_kexec_prepare+0x16b/0x13e0
PGD 1806063 PUD 180a063 PMD 10001e1
Oops: 0003 [#1] SMP
last sysfs file: /sys/firmware/memmap/10/type
CPU 1
Modules linked in: fuse ath5k ath
Pid: 3250, comm: kexec Tainted: G        W  2.6.32-rc5-mm1_64 #869 To Be
Filled By O.E.M.
RIP: 0010:[<ffffffff8101cd8b>]  [<ffffffff8101cd8b>]
machine_kexec_prepare+0x16b/0x13e0
RSP: 0018:ffff8801c95d1e88  EFLAGS: 00010206
RAX: 00000000000001e3 RBX: ffff8801ca2aac00 RCX: 0000000040000000
RDX: 0000000000200000 RSI: ffff8800010a7000 RDI: ffff8800010a7000
RBP: ffff8801c95d1ee8 R08: 00000000000010a7 R09: 00000000010a7fff
R10: 0000000000000fff R11: 0000000004ffffff R12: 0000000000000000
R13: ffff8800010a6000 R14: 0000008000000000 R15: ffff880000000000
FS:  00007f4f97b4c6f0(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8800010a7000 CR3: 00000001c8cf2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kexec (pid: 3250, threadinfo ffff8801c95d0000, task
ffff8801ca116700)
Stack:
ffff8801c95d1ee8 ffff8800010a6000 ffff8800010a4000 ffff8800010a4000
<0> 0000000000000000 00000001cc000000 ffff8801c95d1ee8 0000000000000006
<0> ffff8801ca2aac00 0000000000000000 0000000000000000 000000000146eae0
Call Trace:
[<ffffffff8106d32c>] sys_kexec_load+0xec/0x5e0
[<ffffffff814365b5>] ? do_page_fault+0x185/0x350
[<ffffffff81002e6b>] system_call_fastpath+0x16/0x1b
Code: 00 40 48 c1 e6 0c 4c 01 fe 48 39 ca 73 21 48 89 f7 0f 1f 80 00 00
00 00 48 89 d0 48 81 c2 00 00 20 00 48 0d e3 01 00 00 48 39 d1 <48> ab
77 e9 48 89 f7 49 81 c4 00 00 00 40 e8 e2 93 00 00 4c 89
RIP  [<ffffffff8101cd8b>] machine_kexec_prepare+0x16b/0x13e0
RSP <ffff8801c95d1e88>
CR2: ffff8800010a7000
---[ end trace 4eaa2a86a8e2da24 ]---

ffff8800010a7000 should be OK, as crashkernel=64M@16M was passed to the
kernel.

It's here:
static void init_level2_page(pmd_t *level2p, unsigned long addr)
{
        unsigned long end_addr;

        addr &= PAGE_MASK;
        end_addr = addr + PUD_SIZE;
        while (addr < end_addr) {
here ->         set_pmd(level2p++, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
                addr += PMD_SIZE;
        }
}

Corresponding -fverbose-asm with -g:
        .loc 1 65 0
        addq    $2097152, %rdx  #, addr
.LVL31:
.LBB416:
        .loc 5 77 0
        orq     $483, %rax      #, tmp140
.LBE416:
        .loc 1 63 0
        cmpq    %rdx, %rcx      # addr, end_addr
.LBB417:
        .loc 5 77 0
        stosq
.LVL32:
.LBE417:
        .loc 1 63 0
        ja      .L26    #,



