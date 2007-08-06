Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbXHFCSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbXHFCSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXHFCSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:18:18 -0400
Received: from maggie.cs.pitt.edu ([130.49.220.148]:37281 "EHLO
	maggie.cs.pitt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbXHFCSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:18:18 -0400
X-Greylist: delayed 2534 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2007 22:18:17 EDT
Message-ID: <46B67B03.1050008@cs.pitt.edu>
Date: Sun, 05 Aug 2007 18:36:03 -0700
From: Nevine AbouGhazaleh <nevine@cs.pitt.edu>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: suspend-to-disk using a SAS drive
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -101.665/8 BAYES_00,USER_IN_WHITELIST SA-version=3.000002
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to suspend-to-disk using the Suspend2 modules. I am using an SSD drive connected through a SAS bus interface. The SSD acts as a boot disk.
All read and write transactions to the drive works well during normal operation.  
when I hibernate (suspend-to-disk).

I get the following errors:
------------------
mptbase: ioc0: ERROR – Invalid IOC facts reply, msgLength=0 offset=6
pnp: Failed to activate device 00:09.
pnp: Failed to activate device 00:0a.
------------

Immediately after these messages, Linux hangs as soon as it starts writing the image to the drive. showing the following output.
------------------
Writing Kernel and process data ...
20%...
------------------


When using KDB to trace the problem after the kernel hung.

<ps> shows a running process: Ks2io

when doing Back Trace for Ks2io wheen the kernel hangs, I get the following trace
--------------------
_spin_unlock_irq+0xb
thread_return+0x64
_raw_spin_lock+ox90
__mutex_up_process+0x10
wake_up_process+0x10
suspend_bio_write_page
mutex_lock+0x2a
flush_workqueue+0x51
kblockd_flush+0x10
do_bio_wait+0x1b
suspend_bio_write_page
suepend_bio_write_page+0x41
suspend_compress_write_page+0x137
worker_rw_loop
worker_rw_loop+0x133
worker_rw_loop
kthread+0xf5
schedule_tail_0x45
child_rip+0x45
worker_thread
kthread
child_rip 
--------------------

It seems that the problem is when suspend2 tries to write to the SSD drive.
I am not sure whether the problem is with the suspend2 module or the mpt driver? 
I am using kernel 2.6.21.1 x86_64 with fedora core 5 x86_64. MPT driver 3.04
Any insights/recommendations will be greatly appreciated.  

