Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXEPSZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXEPSZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761139AbXEPSZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:25:21 -0400
Received: from barclay.balt.net ([195.14.162.78]:13940 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbXEPSZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:25:20 -0400
X-Greylist: delayed 1474 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 14:25:19 EDT
Subject: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1 +
	CFS v12)
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 16 May 2007 21:00:41 +0300
Message-Id: <1179338441.4265.13.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

In short, on shutdown my laptop is always freezing now. I was able to
capture the 'sysrq-P' (hit that several times), sysrq-T outputs. Please
see .config and log messages at http://barclay.balt.net/~zilvinas/oops/ 

Kernel version I had built according git is :

zilvinas@zv:/projects/linux-amd64.git$ git describe HEAD
v2.6.22-rc1-29-gfaa8b6c

On top of that I have CFS v12 applied (no other changes otherwise).
Please note that there is ''fglrx.ko'' loaded and kernel is tainted
because of that (feel free to ignore the report ...).

Anyway, 'sysrq-P' always show that PC is stuck at (NFS lockd?) and it is
always the same backtrace is shown. 'sysrq-t' output is in
'kernel-nfs-freeze.log' file (did not want to post it here).

 Pid: 3652, comm: lockd Tainted: P       2.6.22-rc1-cfs-v12 #1

[<ffffffff8024a5a0>] wq_barrier_func+0x0/0x10
[<ffffffff8024a7e5>] destroy_workqueue+0x75/0xa0
[<ffffffff8833cd34>] :sunrpc:rpciod_down+0xf4/0x170
[<ffffffff8836dd74>] :lockd:lockd+0x244/0x300
[<ffffffff80233e1f>] schedule_tail+0x3f/0xb0
[<ffffffff8020b0f8>] child_rip+0xa/0x12
[<ffffffff8836db30>] :lockd:lockd+0x0/0x300
[<ffffffff8836db30>] :lockd:lockd+0x0/0x300
[<ffffffff8020b0ee>] child_rip+0x0/0x12

Hope this helps. Thanks in advance for any advice how to solve problem !
For now I am back to '2.6.21.1-cfs-v10'.


