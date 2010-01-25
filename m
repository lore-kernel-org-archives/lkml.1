Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136Ab0AYPR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0AYPR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699Ab0AYPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:17:55 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:45505 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0AYPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:17:54 -0500
Date: Mon, 25 Jan 2010 10:17:26 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [btrfs] kernel BUG at include/linux/spinlock.h:376!
Message-ID: <20100125151726.GA331@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001072229.33976.johannes.hirte@fem.tu-ilmenau.de>
 <20100114193708.GD23810@think>
 <201001232123.58602.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001232123.58602.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B5DB61C.00FC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 09:23:56PM +0100, Johannes Hirte wrote:
> Am Donnerstag 14 Januar 2010 20:37:08 schrieb Chris Mason:
> > On Thu, Jan 07, 2010 at 10:29:32PM +0100, Johannes Hirte wrote:
> > > One of my btrfs filesystems gives the following bug message on access:
> > > 
> > > Jan  6 23:08:12 datengrab kernel: ------------[ cut here ]------------
> > > Jan  6 23:08:12 datengrab kernel: kernel BUG at
> > > include/linux/spinlock.h:376! Jan  6 23:08:12 datengrab kernel: invalid
> > > opcode: 0000 [#1] SMP
> > > Jan  6 23:08:12 datengrab kernel: last sysfs file:
> > > /sys/devices/pci0000:00/0000:00:18.3/temp1_input
> > > Jan  6 23:08:12 datengrab kernel: CPU 1
> > > Jan  6 23:08:12 datengrab kernel: Pid: 2837, comm: btrfs-endio-wri Not
> > > tainted 2.6.33-rc3-00033-g03b7675 #12 TYAN Tiger K8W Dual AMD Opteron,
> > > S2875/To Be Filled
> > > By O.E.M.
> > > Jan  6 23:08:12 datengrab kernel: RIP: 0010:[<ffffffff8118f7ea>] 
> > > [<ffffffff8118f7ea>] btrfs_assert_tree_locked+0x16/0x1c
> > 
> > Well, we really should have this tree block locked, but
> > btrfs_mark_extent_written is doing some special things.  Is the trace
> > always the same?
> 
> Sorry for the long delay. Yes the trace was always the same. I can't test 
> patches, since I'm not working on the corrupted FS anymore. The bug only 
> occurred on the corrupted filesystem. But as I've seen, Yan Zheng has tracked 
> it down (commit 6c7d54ac87f338c479d9729e8392eca3f76e11e1). 
> 
> I still suspect that the FS corruption was caused by this bug. It didn't 
> happened again. If so, I'll report.

Right, we should have it fixed now, thanks for the report.

-chris

