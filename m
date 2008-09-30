Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYI3RAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYI3RAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYI3RA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:00:28 -0400
Received: from main.gmane.org ([80.91.229.2]:57282 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbYI3RA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:00:27 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: sleeping function called from invalid context at kernel/mutex.c
Date: Tue, 30 Sep 2008 18:00:21 +0100
Message-ID: <48E25B25.10408@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
X-Gmane-NNTP-Posting-Host: 87.114.24.126.plusnet.thn-ag3.dyn.plus.net
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This turned up in a linux-tip from yesterday after resuming from a 
suspend on an EeePC 900:

[ 1176.720189] ACPI: Preparing to enter system sleep state S3
[ 1176.745011] Intel machine check architecture supported.
[ 1176.745011] Intel machine check reporting enabled on CPU#0.
[ 1176.745011] Back to C!
[ 1176.745011] BUG: sleeping function called from invalid context at 
kernel/mutex.c:207
[ 1176.745011] in_atomic(): 0, irqs_disabled(): 1, pid: 4513, name: 
pm-suspend
[ 1176.745011] 3 locks held by pm-suspend/4513:
[ 1176.745011]  #0:  (&buffer->mutex){--..}, at: [<c01b89c0>] 
sysfs_write_file+0x30/0x100
[ 1176.745011]  #1:  (pm_mutex){--..}, at: [<c014ef5a>] 
enter_state+0x4a/0x140
[ 1176.745011]  #2:  (dpm_list_mtx){--..}, at: [<c029c254>] 
device_pm_lock+0x14/0x20
[ 1176.745011] irq event stamp: 28504
[ 1176.745011] hardirqs last  enabled at (28503): [<c014a92b>] 
trace_hardirqs_on+0xb/0x10
[ 1176.745011] hardirqs last disabled at (28504): [<c014593b>] 
trace_hardirqs_off+0xb/0x10
[ 1176.745011] softirqs last  enabled at (27690): [<c012bd53>] 
__do_softirq+0xa3/0xc0
[ 1176.745011] softirqs last disabled at (27685): [<c012bdc5>] 
do_softirq+0x55/0x60
[ 1176.745011] Pid: 4513, comm: pm-suspend Not tainted 
2.6.27-rc7-tipskw-00976-g30d1868-dirty #25
[ 1176.745011]  [<c012bdc5>] ? do_softirq+0x55/0x60
[ 1176.745011]  [<c011fe74>] __might_sleep+0xe4/0x110
[ 1176.745011]  [<c03cfd44>] mutex_lock_nested+0x24/0x50
[ 1176.745011]  [<c0116772>] microcode_update_cpu+0x22/0xf0
[ 1176.745011]  [<c014593b>] ? trace_hardirqs_off+0xb/0x10
[ 1176.745011]  [<c03d178c>] ? _spin_unlock_irqrestore+0x3c/0x60
[ 1176.745011]  [<c0116855>] mc_sysdev_resume+0x15/0x20
[ 1176.745011]  [<c029754b>] __sysdev_resume+0x3b/0x50
[ 1176.745011]  [<c0297997>] sysdev_resume+0x57/0x90
[ 1176.745011]  [<c029cf00>] device_power_up+0x10/0x20
[ 1176.745011]  [<c014ee8f>] suspend_devices_and_enter+0x11f/0x140
[ 1176.745011]  [<c014efbb>] enter_state+0xab/0x140
[ 1176.745011]  [<c014f0f4>] state_store+0xa4/0xe0
[ 1176.745011]  [<c014f050>] ? state_store+0x0/0xe0
[ 1176.745011]  [<c0205934>] kobj_attr_store+0x24/0x30
[ 1176.745011]  [<c01b8a37>] sysfs_write_file+0xa7/0x100
[ 1176.745011]  [<c017b4da>] vfs_write+0x9a/0x120
[ 1176.745011]  [<c01b8990>] ? sysfs_write_file+0x0/0x100
[ 1176.745011]  [<c017b622>] sys_write+0x42/0x70
[ 1176.745011]  [<c010334d>] sysenter_do_call+0x12/0x35
[ 1176.745011]  =======================
[ 1176.745011] Force enabled HPET at resume
[ 1176.748667] ACPI: Waking up from system sleep state S3
[ 1176.801657] ACPI: EC: non-query interrupt received, switching to 
interrupt mode

-- 
Sitsofe | http://sucs.org/~sits/

