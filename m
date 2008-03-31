Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYCaRny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYCaRny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYCaRnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:43:46 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:54314 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbYCaRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:43:46 -0400
Message-ID: <47F122CB.4000702@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2008 23:13:39 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, stable@kernel.org, greg@kroah.com,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] 2.6.24.4 kernel warning at kernel/lockdep.c:2662 check_flags()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel warning is seen while booting up 2.6.24.4 kernel on x86_64 box
with the CONFIG_DEBUG_LOCKDEP enabled.

WARNING: at kernel/lockdep.c:2662 check_flags()
Pid: 0, comm: swapper Not tainted 2.6.24.4 #1

Call Trace:
 [<ffffffff8025b02a>] check_flags+0xc6/0x19e
 [<ffffffff8025eb82>] lock_acquire+0x53/0xb2
 [<ffffffff804b51ac>] __atomic_notifier_call_chain+0x50/0xaf
 [<ffffffff8020af14>] mwait_idle+0x0/0x50
 [<ffffffff804b521a>] atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8020ab7e>] __exit_idle+0x27/0x29
 [<ffffffff8020ae90>] cpu_idle+0xa8/0xe2
 [<ffffffff80220679>] start_secondary+0x3c6/0x3d5

possible reason: unannotated irqs-on.
irq event stamp: 720
hardirqs last  enabled at (719): [<ffffffff804b1f6a>] trace_hardirqs_on_thunk+0x35/0x3a
hardirqs last disabled at (720): [<ffffffff8020ae84>] cpu_idle+0x9c/0xe2
softirqs last  enabled at (718): [<ffffffff80241b40>] __do_softirq+0xd9/0xe2
softirqs last disabled at (713): [<ffffffff8020d49c>] call_softirq+0x1c/0x28

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
