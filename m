Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYHSSAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYHSSAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYHSSA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:00:26 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:61144 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYHSSAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Sna+R8pUbZRMsnT/PxRc7jQ4hpSVyW3J1SJFkcB1OkhJJH4+olzWE+5WJ6UY6z8bUv
         qECHL5Gh+EB8cdAcOBJXcOXxysb3YGrplw4+a0JvrrfzuPqCeO1VKhjEonOCH+Mpqo1F
         xTu8zitnl+pe8252xAnR7x55NmiXBwOGLge28=
Message-ID: <d4b6d3ea0808191100m17ab13cbnb9a1a8a06f2e22e0@mail.gmail.com>
Date: Tue, 19 Aug 2008 14:00:24 -0400
From: "Michael Madore" <michael.madore@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: INFO: task blocked for more than 120 seconds
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Aug 12, 2008 at 11:47:35PM +0530, Aneesh Kumar K.V wrote:
>> On Mon, Aug 11, 2008 at 11:27:12AM -0700, Randy Dunlap wrote:
>> > On 2.6.27-rc2-git4 and several previous kernels, I see several
>> > of these messages.  E.g.:
>> >
>> > INFO: task kjournald:665 blocked for more than 120 seconds.
>> > INFO: task stress:17797 blocked for more than 120 seconds.
>> > INFO: task stress:17805 blocked for more than 120 seconds.
>> >
>> >
>> > Has anyone tracked this down?  Should I attempt to bisect it?
>> > (on x86_64, SMP, 8 GB RAM)
>> >
>> >
>> >
>> > INFO: task kjournald:665 blocked for more than 120 seconds.
>> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> > kjournald     D ffff88027e04be30  4592   665      2
>> >  ffff88027e04bdd0 0000000000000046 ffff88027e04bd90 ffffffff8022b5f8
>> >  ffff88027e703090 ffff880178c91bc0 ffff88027e7033d0 0000000178c91c08
>> >  ffff88027e04bdb0 ffff88027e04be30 ffff88017eaf80f0 0000000000000246
>> > Call Trace:
>> >  [<ffffffff8022b5f8>] ? __wake_up_common+0x41/0x74
>> >  [<ffffffff802f6eef>] journal_commit_transaction+0xe9/0xd7e
>> >  [<ffffffff8023db06>] ? lock_timer_base+0x26/0x4a
>> >  [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
>> >  [<ffffffff8023db80>] ? try_to_del_timer_sync+0x56/0x62
>> >  [<ffffffff802fa388>] kjournald+0xc3/0x1fb
>> >  [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
>> >  [<ffffffff802fa2c5>] ? kjournald+0x0/0x1fb
>> >  [<ffffffff80247107>] kthread+0x49/0x76
>> >  [<ffffffff8020ce39>] child_rip+0xa/0x11
>> >  [<ffffffff802470be>] ? kthread+0x0/0x76
>> >  [<ffffffff8020ce2f>] ? child_rip+0x0/0x11
>> >
>> > INFO: task stress:17797 blocked for more than 120 seconds.
>> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> > stress        D ffff88017eaf8024  5088 17797  17795
>> >  ffff8801f4055cd8 0000000000000082 0000000000000086 ffff88027e04bec0
>> >  ffff880178c93090 ffff88017faf75f0 ffff880178c933d0 0000000300000001
>> >  0000000000000292 ffff8801f4055ce8 ffff88017eaf80a8 0000000000000246
>> > Call Trace:
>> >  [<ffffffff802f9c04>] log_wait_commit+0xa4/0xf4
>> >  [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
>> >  [<ffffffff802f5798>] journal_stop+0x17c/0x1a9
>> >  [<ffffffff802f5fe6>] journal_force_commit+0x23/0x25
>> >  [<ffffffff802eee53>] ext3_force_commit+0x26/0x28
>> >  [<ffffffff802e91d2>] ext3_write_inode+0x39/0x3f
>> >  [<ffffffff802b58cf>] __writeback_single_inode+0x180/0x284
>> >  [<ffffffff80247278>] ? wake_bit_function+0x0/0x2a
>> >  [<ffffffff802b5db1>] generic_sync_sb_inodes+0x1c3/0x29e
>> >  [<ffffffff802b5e95>] sync_sb_inodes+0x9/0xb
>> >  [<ffffffff802b5f2c>] sync_inodes_sb+0x95/0x9c
>> >  [<ffffffff802b5f95>] __sync_inodes+0x62/0xaf
>> >  [<ffffffff802b6010>] sync_inodes+0x2e/0x33
>> >  [<ffffffff802b8908>] do_sync+0x34/0x59
>> >  [<ffffffff802b893b>] sys_sync+0xe/0x13
>> >  [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
>> >
>>
>> Committing a transaction would means writing rest of the meta-data in
>> the transaction. And that would imply forcing most of the buffer_heads
>> to disk in ordered mode. This can result a lot of seeks and make take
>> more thatn 120 seconds.
>
>
> Both Randy and Greg reported getting this for 2.6.27-rc but not
> for 2.6.26.
>
> Why are people getting such messages for 2.6.27-rc but not for 2.6.26?

Hi,

I have reported getting these messages on 2.6.26:

http://marc.info/?l=linux-kernel&m=121796211813099&w=2

In addition to the system mentioned in that posting, I have just
reproduced it by stress testing a system with 2 Opteron processors,
2GB of RAM and 2 SATA disks.

Backing out this patch seems to help:

commit cc19747977824ece6aa1c56a29e974fef5ec2b32
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Apr 20 20:45:39 2007 +0200

    cfq-iosched: tighten queue request overlap condition

    For tagged devices, allow overlap of requests if the idle window
    isn't enabled on the current active queue.

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a8237be..e859b49 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -989,7 +989,8 @@ static struct cfq_queue *cfq_select_queue(struct
cfq_data *cfqd)
* flight or is idling for a new request, allow either of these
* conditions to happen (or time out) before selecting a new queue.
*/
- if (cfqq->dispatched || timer_pending(&cfqd->idle_slice_timer)) {
+ if (timer_pending(&cfqd->idle_slice_timer) ||
+     (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
cfqq = NULL;
goto keep_queue;
}

Mike Madore
