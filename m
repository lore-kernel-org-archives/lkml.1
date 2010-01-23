Return-Path: <linux-kernel-owner+w=401wt.eu-S1751681Ab0AWUYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0AWUYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494Ab0AWUYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:24:12 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:33360 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0AWUYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:24:11 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [btrfs] kernel BUG at include/linux/spinlock.h:376!
Date: Sat, 23 Jan 2010 21:23:56 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc3-00033-g03b7675; KDE/4.3.90; x86_64; ; )
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001072229.33976.johannes.hirte@fem.tu-ilmenau.de> <20100114193708.GD23810@think>
In-Reply-To: <20100114193708.GD23810@think>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001232123.58602.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 14 Januar 2010 20:37:08 schrieb Chris Mason:
> On Thu, Jan 07, 2010 at 10:29:32PM +0100, Johannes Hirte wrote:
> > One of my btrfs filesystems gives the following bug message on access:
> > 
> > Jan  6 23:08:12 datengrab kernel: ------------[ cut here ]------------
> > Jan  6 23:08:12 datengrab kernel: kernel BUG at
> > include/linux/spinlock.h:376! Jan  6 23:08:12 datengrab kernel: invalid
> > opcode: 0000 [#1] SMP
> > Jan  6 23:08:12 datengrab kernel: last sysfs file:
> > /sys/devices/pci0000:00/0000:00:18.3/temp1_input
> > Jan  6 23:08:12 datengrab kernel: CPU 1
> > Jan  6 23:08:12 datengrab kernel: Pid: 2837, comm: btrfs-endio-wri Not
> > tainted 2.6.33-rc3-00033-g03b7675 #12 TYAN Tiger K8W Dual AMD Opteron,
> > S2875/To Be Filled
> > By O.E.M.
> > Jan  6 23:08:12 datengrab kernel: RIP: 0010:[<ffffffff8118f7ea>] 
> > [<ffffffff8118f7ea>] btrfs_assert_tree_locked+0x16/0x1c
> 
> Well, we really should have this tree block locked, but
> btrfs_mark_extent_written is doing some special things.  Is the trace
> always the same?

Sorry for the long delay. Yes the trace was always the same. I can't test 
patches, since I'm not working on the corrupted FS anymore. The bug only 
occurred on the corrupted filesystem. But as I've seen, Yan Zheng has tracked 
it down (commit 6c7d54ac87f338c479d9729e8392eca3f76e11e1). 

I still suspect that the FS corruption was caused by this bug. It didn't 
happened again. If so, I'll report.

regards,
  Johannes
