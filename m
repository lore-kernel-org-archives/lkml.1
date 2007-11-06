Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbXKFIVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbXKFIVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXKFIVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:21:20 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:39548 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbXKFIVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=CDY+OzoVlZraDUZ5mGpClOxk0okjonxifmMTpG0/79c10mDJ/PSRsyiQEicnviF+uQNgiJBy78mWRmufeqG6g9Wc0fd7xmnXyJqa7hBnyTLDAhQ6UNpmcRHaYhx3Li8j15rL9V8m+hicahKS1XLssT5tWIorrl28W/IcrLOPUvc=
Message-ID: <473023FE.8020501@networksentry.co.za>
Date: Tue, 06 Nov 2007 10:21:18 +0200
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Odd Ooops jbd ??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Gregory Nietsky <gregnietsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

here is a error i keep bumping into with 2.6.24-rc1 (git11)

the trigger is a ISDN call from one port to another (loopback cable) 
within asterisk i have not been able to replicate it in any other way 
the error may be in the ISDN
what i cant understand is why it would affect the fs.

shortly after this occurs there many oopses letting it run yesterday 
corrupted the superblock on the / fs

i will continue to try narrow it down any ideas are welcome.

printing eip: c0177656 *pde = 00000000
Oops: 0000 [#1] PREEMPT SMP

...

Pid: 564, comm: kjournald Not tainted (2.6.24-rc1-git11-i386-smp #4)
EIP: 0060:[<c0177656>] EFLAGS: 00010006 CPU: 1
EIP is at kmem_cache_alloc+0x5d/0xa6
EAX: 00000000 EBX: 00000282 ECX: c03621d0 EDX: 74736e69
ESI: c1c164fc EDI: 74736e69 EBP: c03621d0 ESP: c359de80
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kjournald (pid: 564, ti=c359c000 task=c352d800 task.ti=c359c000)
Stack: c352d800 00000001 74736e69 00011200 00000092 c2035600 c3179380 
00000001
       00011210 c015d385 00000010 c019797d 00000001 00000002 c359dee8 
c019797d
       00000000 c3179380 00000001 00000000 c019a0fa 00000000 c201c2a0 
00000010
Call Trace:
 [<c015d385>] mempool_alloc+0x24/0xc2
 [<c019797d>] sync_buffer+0x0/0x33
 [<c019797d>] sync_buffer+0x0/0x33
 [<c019a0fa>] bio_alloc_bioset+0x8c/0xe6
 [<c011e0cb>] __wake_up_common+0x38/0x5d
 [<c019a15f>] bio_alloc+0xb/0x17
 [<c0196959>] submit_bh+0x6b/0xf5
 [<f88c2b47>] journal_do_submit_data+0x23/0x2b [jbd]
 [<f88c3054>] journal_commit_transaction+0x4a7/0xcff [jbd]
 [<c010316d>] __switch_to+0x94/0x10b
 [<c02b49b7>] schedule+0x4b9/0x4f2
 [<c012d019>] lock_timer_base+0x19/0x35
 [<c012d079>] try_to_del_timer_sync+0x44/0x4a
 [<f88c61f3>] kjournald+0xb0/0x1ec [jbd]
 [<c01362a4>] autoremove_wake_function+0x0/0x33
 [<f88c6143>] kjournald+0x0/0x1ec [jbd]
 [<c01361d5>] kthread+0x38/0x5f
 [<c013619d>] kthread+0x0/0x5f
 [<c0105347>] kernel_thread_helper+0x7/0x10
 =======================
Code: 3e 85 ff 89 7c 24 08 75 1b 89 14 24 8b 54 24 0c 83 c9 ff 89 e8 89 
74 24 04 e8 d8 f8 ff ff 89 44 24 08 eb 0c 8b 54 24 08 8b 46 0c <8b> 04 
82 89 06 89 d8
50 9d 0f 1f 84 00 00 00 00 00 66 83 7c 24
EIP: [<c0177656>] kmem_cache_alloc+0x5d/0xa6 SS:ESP 0068:c359de80
