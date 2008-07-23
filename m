Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYGWUww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYGWUww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYGWUwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:52:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:13852 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbYGWUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZsGSyhMnuIO314OdXZvnYt3smRLR0L1CgB9XtQus4XHzTojGhlWa+0zeDdB2hCw9Em
         oaBVdSM79GuvOgaAotcrXuP0i/rPd1CkybqZ7am17uklYyee8WAlLQ5IdSi8+FGOGo8h
         fJH+/D0kQpWQtuxAyygByq3wt+5SMQ+v6mGDA=
Message-ID: <19f34abd0807231352j1ba1414am84ee9683df9b5657@mail.gmail.com>
Date: Wed, 23 Jul 2008 22:52:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20080723203109.GH14380@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
	 <20080723203109.GH14380@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:31 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Wed, Jul 23, 2008 at 01:07:04PM -0700, Vegard Nossum wrote:
>> Hi,
>>
>> I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
>> yesterday):
>
> Do you see this in 2.6.26 aswell? I suspect it is coming from post 2.6.26
> changes.
>

Humm... I got something different now on plain 2.6.26:

------------[ cut here ]------------
WARNING: at kernel/sched_fair.c:815 hrtick_start_fair+0x158/0x170()
Pid: 5575, comm: migration/1 Not tainted 2.6.26 #1
 [<c013471f>] warn_on_slowpath+0x4f/0x70
 [<c010aea5>] ? native_sched_clock+0xb5/0x110
 [<c0129aae>] ? update_curr_rt+0x10e/0x450
 [<c0581427>] ? _spin_unlock+0x27/0x50
 [<c0129aae>] ? update_curr_rt+0x10e/0x450
 [<c012802a>] ? __dequeue_entity+0x2a/0xa0
 [<c0129518>] hrtick_start_fair+0x158/0x170
 [<c012958f>] pick_next_task_fair+0x5f/0x70
 [<c057e2e8>] schedule+0x148/0x850
 [<c0581582>] ? _spin_unlock_irq+0x22/0x60
 [<c0157a24>] ? trace_hardirqs_on+0xd4/0x160
 [<c012fd92>] migration_thread+0x132/0x240
 [<c0127f39>] ? complete+0x49/0x60
 [<c012fc60>] ? migration_thread+0x0/0x240
 [<c0148722>] kthread+0x42/0x70
 [<c01486e0>] ? kthread+0x0/0x70
 [<c0105a53>] kernel_thread_helper+0x7/0x14
 =======================
---[ end trace 3e4aafeba0960600 ]---
BUG: unable to handle kernel paging request at c0804358
IP: [<c057e38d>] schedule+0x1ed/0x850
*pde = 3780e163 *pte = 00804162
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 5575, comm: migration/1 Tainted: G        W (2.6.26 #1)
EIP: 0060:[<c057e38d>] EFLAGS: 00010086 CPU: 1
EIP is at schedule+0x1ed/0x850
EAX: c0803f00 EBX: 00000001 ECX: f4d10000 EDX: 00450008
ESI: f4c91fe0 EDI: c0803f00 EBP: f4c85fa0 ESP: f4c85f3c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process migration/1 (pid: 5575, ti=f4c84000 task=f6348000 task.ti=f4c84000)
Stack: ef927c97 f63484b8 f6348000 f63484b8 c08ba810 f6348000 c1fb3f00 f4c91fe0
       00000000 00000000 f6348000 f6348274 c1fb3f00 f4c84000 00000000 f6348000
       c0581582 c1fb3f00 f4c85f94 c0157a24 c1fb3f00 00000001 c1fb4378 00000001
Call Trace:
 [<c0581582>] ? _spin_unlock_irq+0x22/0x60
 [<c0157a24>] ? trace_hardirqs_on+0xd4/0x160
 [<c012fd92>] ? migration_thread+0x132/0x240
 [<c0127f39>] ? complete+0x49/0x60
 [<c012fc60>] ? migration_thread+0x0/0x240
 [<c0148722>] ? kthread+0x42/0x70
 [<c01486e0>] ? kthread+0x0/0x70
 [<c0105a53>] ? kernel_thread_helper+0x7/0x14
 =======================
Code: c0 0f 84 40 02 00 00 8b 86 48 04 00 00 39 45 b8 0f 84 ad 00 00
00 8b 75 b8 b8 00 3f 80 c0 8b 4e 04 8b 51 10 03 04 95 00 af
75 c0 <8b> b0 58 04 00 00 8b 98 54 04 00 00 89 75 c0 8b 75 b8 89 5d bc
EIP: [<c057e38d>] schedule+0x1ed/0x850 SS:ESP 0068:f4c85f3c
---[ end trace 3e4aafeba0960600 ]---
note: migration/1[5575] exited with preempt_count 2

I'll give it a few more tries to see if it can come up with the same
thing as before.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
