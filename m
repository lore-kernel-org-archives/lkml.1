Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbYHDJfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbYHDJfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYHDJey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:34:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:53557 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYHDJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=LsVGDIRrGHuYcG7B3dowmfVTRRyZ+7X/ndtE8Y+xXEbiZOmk9+i1jdOKvQ1E682nJF
         GMOMKXIin6bW/OwWGCl8YmPZo3vxkTSgE0hG0pJY9wKw/OVGvzBev1q8v1gW18weJAEC
         ZRNkYvkw2Ys2Jb2EGjGS6XyrWFM55FZMyx+fs=
Message-ID: <c4e36d110808040234m2564cb7cveac6e8e8bbb68835@mail.gmail.com>
Date: Mon, 4 Aug 2008 11:34:53 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: INFO: trying to register non-static key
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Happened during reinsert of the loop module

[ 7145.533707] INFO: trying to register non-static key.
[ 7145.533713] the code is fine but needs lockdep annotation.
[ 7145.533719] turning off the locking correctness validator.
[ 7145.533728] Pid: 20864, comm: rmmod Not tainted 2.6.27-rc1 #56
[ 7145.533733]
[ 7145.533735] Call Trace:
[ 7145.533751]  [<ffffffff81065d80>] ? static_obj+0x80/0x90
[ 7145.533761]  [<ffffffff8106913f>] __lock_acquire+0x12af/0x13b0
[ 7145.533770]  [<ffffffff8106646d>] ? trace_hardirqs_off+0xd/0x10
[ 7145.533783]  [<ffffffff810135c0>] ? native_sched_clock+0x90/0xb0
[ 7145.533794]  [<ffffffff81053172>] ? __cancel_work_timer+0x72/0x230
[ 7145.533803]  [<ffffffff810692d6>] lock_acquire+0x96/0xe0
[ 7145.533812]  [<ffffffff81053172>] ? __cancel_work_timer+0x72/0x230
[ 7145.533824]  [<ffffffff810531a2>] __cancel_work_timer+0xa2/0x230
[ 7145.533832]  [<ffffffff8104af2a>] ? try_to_del_timer_sync+0x5a/0x70
[ 7145.533844]  [<ffffffff81319ab0>] ? sub_preempt_count+0x80/0x120
[ 7145.533857]  [<ffffffff81315dc5>] ? _spin_unlock_irqrestore+0x45/0x90
[ 7145.533866]  [<ffffffff8104af2a>] ? try_to_del_timer_sync+0x5a/0x70
[ 7145.533875]  [<ffffffff810658d4>] ? lock_release_holdtime+0x74/0xd0
[ 7145.533885]  [<ffffffff8105334b>] cancel_work_sync+0xb/0x10
[ 7145.533897]  [<ffffffff8117e1d7>] blk_sync_queue+0x27/0x30
[ 7145.533906]  [<ffffffff8117ffd3>] blk_release_queue+0x23/0x70
[ 7145.533917]  [<ffffffff8118e792>] kobject_release+0x52/0xb0
[ 7145.533926]  [<ffffffff8118e740>] ? kobject_release+0x0/0xb0
[ 7145.533935]  [<ffffffff8118f807>] kref_put+0x37/0x70
[ 7145.533943]  [<ffffffff8118e647>] kobject_put+0x27/0x60
[ 7145.533951]  [<ffffffff8117e19b>] blk_cleanup_queue+0x5b/0x70
[ 7145.533964]  [<ffffffffa03cd0b8>] loop_free+0x18/0x60 [loop]
[ 7145.533976]  [<ffffffffa03cf90a>] loop_exit+0x6e/0xb6 [loop]
[ 7145.533988]  [<ffffffff810742ff>] sys_delete_module+0x1cf/0x2d0
[ 7145.533999]  [<ffffffff81315726>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 7145.534009]  [<ffffffff8106776b>] ? trace_hardirqs_on_caller+0x14b/0x1b0
[ 7145.534023]  [<ffffffff8100c5bb>] system_call_fastpath+0x16/0x1b

Zdenek
