Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbYFQMv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbYFQMv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbYFQMvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:51:48 -0400
Received: from smtp2.Stanford.EDU ([171.67.20.25]:55757 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbYFQMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:51:47 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2008 08:51:47 EDT
Subject: 2.6.25.7 + rt6 = BUGs (sleeping function called from invalid
	context)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 17 Jun 2008 14:40:57 +0200
Message-Id: <1213706457.23172.4.camel@cage.kgw.TU-Berlin.DE>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, just trying the latest rt6 (for 2.6.25) on top of 2.6.25.7 and
I'm getting a lot these (1 a second?):

BUG: sleeping function called from invalid context swapper(0) at
kernel/rtmutex.c:739
in_atomic():1 [00000001], irqs_disabled():0
Pid: 0, comm: swapper Not tainted 2.6.25.7-1.rt6.1.fc8.ccrma.i686.rt #1
 [<c041f5ae>] __might_sleep+0xed/0xf4
 [<c0637bec>] __rt_spin_lock+0x24/0x61
 [<c0637c31>] rt_spin_lock+0x8/0xa
 [<c043ce6d>] pm_qos_requirement+0x10/0x29
 [<c05aac94>] menu_select+0x55/0x79
 [<c05aa222>] ? cpuidle_idle_call+0x0/0x8e
 [<c05aa263>] cpuidle_idle_call+0x41/0x8e
 [<c05aa222>] ? cpuidle_idle_call+0x0/0x8e
 [<c040466a>] cpu_idle+0xa4/0xfb
 [<c0633447>] start_secondary+0x15c/0x161
 [<c0403664>] ? lguest_time_init+0xa3/0xa3f
 =======================

(please cc me, I can't currently read lkml)
-- Fernando


