Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbYHESr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbYHESr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbYHESru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:47:50 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:38134 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbYHESrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=tZxO1O4zZxmOOJ/gxzrUv+vq9oXtalnu3kTF1BMJnTZ2S5n332apOwSAbT4boO5tMt
         cD7ziZUBTkWpkERrqHlUnfSk3JoFcp0NR3oRy7VJIwRyUqbfjloi4Q/bISalYig5f1Nd
         Lg8IVOf2Qb3gIHR9VMK7SQeAfR/G5ieWnj1yE=
Message-ID: <d4b6d3ea0808051147n4a494c0fj10a78c92890e354b@mail.gmail.com>
Date: Tue, 5 Aug 2008 14:47:47 -0400
From: "Michael Madore" <michael.madore@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: task blocked for more than 120 seconds (2.6.26.1)
Cc: jens.axboe@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Running 2.6.26.1 I am receiving errors similar to the following when
stress testing systems:

INFO: task kjournald:1004 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald     D ffff81013d347000     0  1004      2
 ffff81013cce9de0 0000000000000046 ffff81013cce9d90 ffffffff810478c5
 ffff810001069378 ffff81013cdd2cc0 ffff810120454320 ffff81013cdd3010
 ffff81013cce9de0 ffffffff81048096 ffff81013cce9db0 0000000000000246
Call Trace:
 [<ffffffff810478c5>] ? enqueue_hrtimer+0xd1/0xdf
 [<ffffffff81048096>] ? hrtimer_start+0x122/0x144
 [<ffffffffa0023be3>] :jbd:journal_commit_transaction+0xe9/0xd1e
 [<ffffffff8103bb2d>] ? lock_timer_base+0x26/0x4a
 [<ffffffff81045534>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8103bba7>] ? try_to_del_timer_sync+0x56/0x62
 [<ffffffffa002713e>] :jbd:kjournald+0xc3/0x1fb
 [<ffffffff81045534>] ? autoremove_wake_function+0x0/0x38
 [<ffffffffa002707b>] ? :jbd:kjournald+0x0/0x1fb
 [<ffffffff810453ff>] kthread+0x49/0x76
 [<ffffffff8100cd08>] child_rip+0xa/0x12
 [<ffffffff810453b6>] ? kthread+0x0/0x76
 [<ffffffff8100ccfe>] ? child_rip+0x0/0x12

This is on a 16 core Intel system with a single SATA disk and 4GB of
memory.  This particular instance of the error occurred after about an
hour.

I was previously using 2.6.24.7 from Fedora 8 and that did not exhibit
the problem.

Mike Madore
