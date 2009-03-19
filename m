Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbZCSIvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbZCSIvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZCSIvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:51:12 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:50119
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025AbZCSIvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:51:11 -0400
Date: Thu, 19 Mar 2009 09:51:05 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: linux-kernel@vger.kernel.org
Subject: [BUG] linux-2.6.29-rc7-rt1: sleeping function called from invalid
	context
Message-ID: <20090319085105.GD4087@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after booting my box with linux 2.6.29-rc7-rt1 dmesg contains the
following bug report:

[   33.616819] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   33.616827] in_atomic(): 1, irqs_disabled(): 0, pid: 5015, name: modprobe
[   33.616834] Pid: 5015, comm: modprobe Not tainted 2.6.29-rc7-rt1 #1
SMP PREEMPT RT Wed Mar 18 17:59:59 CET 2009
[   33.616838] Call Trace:
[   33.616853]  [<c012941f>] __might_sleep+0xff/0x130
[   33.616860]  [<c033c25a>] rt_spin_lock+0x2a/0x70
[   33.616867]  [<c01b7441>] kfree+0x31/0x90
[   33.616873]  [<c010a413>] exit_thread+0x43/0xb0
[   33.616879]  [<c0136720>] do_exit+0x150/0x890
[   33.616885]  [<c033f325>] ? sub_preempt_count+0x95/0xd0
[   33.616891]  [<c0159683>] ? rt_up_read+0x33/0x50
[   33.616898]  [<c0136e95>] do_group_exit+0x35/0x90
[   33.616903]  [<c0136f04>] sys_exit_group+0x14/0x20
[   33.616908]  [<c010301b>] sysenter_do_call+0x12/0x2c
[   34.724300] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   34.724308] in_atomic(): 1, irqs_disabled(): 0, pid: 5114, name: xkbcomp
[   34.724314] Pid: 5114, comm: xkbcomp Not tainted 2.6.29-rc7-rt1 #1
SMP PREEMPT RT Wed Mar 18 17:59:59 CET 2009
[   34.724318] Call Trace:
[   34.724334]  [<c012941f>] __might_sleep+0xff/0x130
[   34.724342]  [<c033c25a>] rt_spin_lock+0x2a/0x70
[   34.724348]  [<c01b7441>] kfree+0x31/0x90
[   34.724354]  [<c010a413>] exit_thread+0x43/0xb0
[   34.724359]  [<c0136720>] do_exit+0x150/0x890
[   34.724366]  [<c033f325>] ? sub_preempt_count+0x95/0xd0
[   34.724371]  [<c0159683>] ? rt_up_read+0x33/0x50
[   34.724378]  [<c0136e95>] do_group_exit+0x35/0x90
[   34.724383]  [<c0136f04>] sys_exit_group+0x14/0x20
[   34.724388]  [<c010301b>] sysenter_do_call+0x12/0x2c

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

          We can't solve problems by using the same kind
             of thinking we used when we created them
                         (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
