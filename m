Return-Path: <linux-kernel-owner+w=401wt.eu-S1422853AbXCWM3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422853AbXCWM3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422854AbXCWM3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:29:14 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3537 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422853AbXCWM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:29:10 -0400
Message-ID: <4603C7EC.6030906@shadowen.org>
Date: Fri, 23 Mar 2007 12:28:28 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4602B7D3.4030108@shadowen.org> <4602C83B.20608@shadowen.org> <200703231718.20647.kernel@kolivas.org> <460393A3.60502@shadowen.org>
In-Reply-To: <460393A3.60502@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Con Kolivas wrote:
>> On Friday 23 March 2007 05:17, Andy Whitcroft wrote:
>>> Ok, I have yet a third x86_64 machine is is blowing up with the latest
>>> 2.6.21-rc4-mm1+hotfixes+rsdl-0.32 but working with
>>> 2.6.21-rc4-mm1+hotfixes-RSDL.  I have results on various hotfix levels
>>> so I have just fired off a set of tests across the affected machines on
>>> that latest hotfix stack plus the RSDL backout and the results should be
>>> in in the next hour or two.
>>>
>>> I think there is a strong correlation between RSDL and these hangs.  Any
>>> suggestions as to the next step.
>> Found a nasty in requeue_task
>> +	if (list_empty(old_array->queue + old_prio))
>> +		__clear_bit(old_prio, p->array->prio_bitmap);
>>
>> see anything wrong there? I do :P
>>
>> I'll queue that up with the other changes pending and hopefully that will fix 
>> your bug.
> 
> Tests queued with your rdsl-0.33 patch (I am assuming its in there).
> Will let you know how it looks.

Hmmm, this is good for the original machine (as was 0.32) but not for
either of the other two.  I am seeing panics as below on those two.

-apw

elm3b245:

NULL pointer dereference
 at 0000000000000020 RIP:
 [<ffffffff80497d94>] __sched_text_start+0x424/0x8a5
PGD 0
Oops: 0000 [1] SMP
last sysfs file: block/ram0/uevent
CPU 0
Modules linked in:
Pid: 1038, comm: udevd Not tainted 2.6.21-rc4-mm1-autokern1 #1
RIP: 0010:[<ffffffff80497d94>]  [<ffffffff80497d94>]
__sched_text_start+0x424/0x8a5
RSP: 0018:ffff81000316de68  EFLAGS: 00010017
RAX: 00000000000006c6 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000000008c RDI: ffffffffffffffd0
RBP: ffff81000316def8 R08: 0000000000000064 R09: 0000000000000024
R10: ffff810001014ad8 R11: 0000000000000286 R12: ffff810001014218
R13: ffff810001013780 R14: ffff810001769450 R15: 0000000000000000
FS:  00002b75d89c66d0(0000) GS:ffffffff805aa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 0000000000201000 CR4: 00000000000006e0
Process udevd (pid: 1038, threadinfo ffff81000316c000, task
ffff8100031cebb0)
Stack:  0000000000000000 0000000000000001 0000000000000000 ffff8100031cebb0
 ffffffffffffffd0 00000036e28ef568 ffff8100031ced48 0000000000000292
 ffff81000316def8 0000000000000246 ffff81000316def8 ffffffff8022af3d
Call Trace:
 [<ffffffff8022af3d>] put_files_struct+0xbd/0xc9
 [<ffffffff8022c773>] do_exit+0x7d2/0x7d6
 [<ffffffff8022c801>] sys_exit_group+0x0/0x14
 [<ffffffff8022c813>] sys_exit_group+0x12/0x14
 [<ffffffff8020968e>] system_call+0x7e/0x83


Code: 48 39 47 50 74 51 48 c7 47 40 00 00 00 00 8b 52 f4 48 b9 40
RIP  [<ffffffff80497d94>] __sched_text_start+0x424/0x8a5
 RSP <ffff81000316de68>
CR2: 0000000000000020
Fixing recursive fault but reboot is needed!


elm3b6:
Unable to handle kernel paging request at 000000000000fb6c RIP:
 [<ffffffff8020c573>] convert_rip_to_linear+0x53/0x91
PGD 180780067 PUD 182242067 PMD 0
Oops: 0000 [1] SMP
last sysfs file:
devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
CPU 0
Modules linked in:
Pid: 2442, comm: autorun Not tainted 2.6.21-rc4-mm1-autokern1 #1
RIP: 0010:[<ffffffff8020c573>]  [<ffffffff8020c573>]
convert_rip_to_linear+0x53/0x91
RSP: 0000:ffff810181a53cf8  EFLAGS: 00010002
RAX: 000000000000fb68 RBX: ffff810181a53e28 RCX: ffff8101823d6930
RDX: ffffffff8049fb6d RSI: ffff810182342180 RDI: ffff810182342440
RBP: ffff810181a53cf8 R08: 0000000080209bb9 R09: 000000000000008c
R10: 0000000000000000 R11: 0000000001200011 R12: 0000000000000000
R13: ffff810182342180 R14: ffff810181a53e28 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff805b2000(0063) knlGS:00000000f7f1cb80
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 000000000000fb6c CR3: 0000000181a5b000 CR4: 00000000000006e0
Process autorun (pid: 2442, threadinfo ffff810181a52000, task
ffff8101823d6930)
Stack:  ffff810181a53d18 ffffffff80219075 ffff8101823d84a8 0000000000000020
 ffff810181a53e18 ffffffff80219ab4 ffff8101fff654d8 ffff810181a53d48
 ffffffff80264291 ffff8101823d6930 ffff810181a53e28 0000000000000046
Call Trace:
 [<ffffffff80219075>] is_prefetch+0x29/0x217
 [<ffffffff80219ab4>] do_page_fault+0x608/0x7f0
 [<ffffffff80264291>] page_dup_rmap+0x1d/0x24
 [<ffffffff8024567c>] search_module_extables+0x83/0x8f
 [<ffffffff80229b43>] oops_enter+0xe/0x10
 [<ffffffff8020ae62>] oops_begin+0x3c/0x70
 [<ffffffff80219b31>] do_page_fault+0x685/0x7f0
 [<ffffffff8022404d>] task_running_tick+0xad/0x290
 [<ffffffff8049fb6d>] error_exit+0x0/0x84
 [<ffffffff8049fb6d>] error_exit+0x0/0x84
 [<ffffffff8049dc11>] thread_return+0x22/0xd3
 [<ffffffff80209802>] int_careful+0xd/0x11


Code: 8b 48 04 0f b7 50 02 0f b6 c1 c1 e0 10 09 c2 89 c8 25 00 00
RIP  [<ffffffff8020c573>] convert_rip_to_linear+0x53/0x91
 RSP <ffff810181a53cf8>
CR2: 000000000000fb6c
