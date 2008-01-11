Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYAKXKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYAKXKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762373AbYAKXJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:09:34 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:54741 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762746AbYAKXJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:09:32 -0500
Date: Sat, 12 Jan 2008 00:09:29 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080111230929.GA7052@boogie.lpds.sztaki.hu>
References: <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <20080107141300.GB12763@boogie.lpds.sztaki.hu> <47824415.80703@gmail.com> <20080107210024.GA13537@boogie.lpds.sztaki.hu> <47834593.1000506@gmail.com> <20080108133215.GA15814@boogie.lpds.sztaki.hu> <478490D2.5050902@gmail.com> <20080110011117.GA3968@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110011117.GA3968@darkstar.te-china.tietoenator.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 09:11:17AM +0800, Dave Young wrote:

> For bluetooth device_move, the only child device of hci_conn dev is
> the rfcomm tty_dev. How about the following patch, please verify :

There is now no oops, instead the keyboard becomes almost completely
unresponsible when I switch off & on the phone. The mouse still works
(tested both with X and with the VGA console), but terminal input and VT
switching is dead. On the VGA console, even scrolling using Shift+PgUp
stops working.

Alt+SysRq+w works, trace is below. Ctrl+Alt+Del also works, but then
init complains about hung processes and that it can not umount the file
systems and cannot stop the RAID arrays. Once it still rebooted though,
the second time it got hung after trying to umount the filesystems, and
I had to use Alt+SysRq+b.

If I can choose then I prefer the Oops...

Jan 11 23:46:35 twister kernel: SysRq : Emergency Sync
Jan 11 23:46:35 twister kernel: Emergency Sync complete
Jan 11 23:46:42 twister kernel: SysRq : Show Blocked State
Jan 11 23:46:42 twister kernel:   task                        PC stack   pid father
Jan 11 23:46:42 twister kernel: events/0      D ffffffff80487190     0     5      2
Jan 11 23:46:42 twister kernel:  ffff8100bf84fd40 0000000000000046 ffff8100ae7f2600 ffff8100bf84fd00
Jan 11 23:46:42 twister kernel:  ffff8100bf84a830 ffff8100bd872000 ffffffff80652ae0 0000000100000100
Jan 11 23:46:42 twister kernel:  0000000000000000 7fffffffffffffff 7fffffffffffffff 0000000000000002
Jan 11 23:46:42 twister kernel: Call Trace:
Jan 11 23:46:42 twister kernel:  [<ffffffff80473543>] schedule_timeout+0x1e/0xad
Jan 11 23:46:42 twister kernel:  [<ffffffff8028560d>] dput+0x26/0x103
Jan 11 23:46:42 twister kernel:  [<ffffffff802af3fd>] sysfs_move_dir+0x1ee/0x1fd
Jan 11 23:46:42 twister kernel:  [<ffffffff8047340b>] wait_for_common+0xc4/0x129
Jan 11 23:46:42 twister kernel:  [<ffffffff80224204>] default_wake_function+0x0/0xe
Jan 11 23:46:42 twister kernel:  [<ffffffff80471d72>] klist_del+0x15/0x2e
Jan 11 23:46:42 twister kernel:  [<ffffffff803698f3>] device_move+0x80/0x111
Jan 11 23:46:42 twister kernel:  [<ffffffff88146a27>] :bluetooth:hci_conn_move_child+0x0/0xf
Jan 11 23:46:42 twister kernel:  [<ffffffff88146a32>] :bluetooth:hci_conn_move_child+0xb/0xf
Jan 11 23:46:42 twister kernel:  [<ffffffff80369836>] device_for_each_child+0x22/0x4d
Jan 11 23:46:42 twister kernel:  [<ffffffff88146a05>] :bluetooth:del_conn+0x0/0x22
Jan 11 23:46:42 twister kernel:  [<ffffffff88146a1e>] :bluetooth:del_conn+0x19/0x22
Jan 11 23:46:42 twister kernel:  [<ffffffff8023696d>] run_workqueue+0x74/0xee
Jan 11 23:46:42 twister kernel:  [<ffffffff80236ff8>] worker_thread+0x0/0xe7
Jan 11 23:46:42 twister kernel:  [<ffffffff802370d2>] worker_thread+0xda/0xe7
Jan 11 23:46:42 twister kernel:  [<ffffffff80239b77>] autoremove_wake_function+0x0/0x2e
Jan 11 23:46:42 twister kernel:  [<ffffffff80236ff8>] worker_thread+0x0/0xe7
Jan 11 23:46:42 twister kernel:  [<ffffffff802399a0>] kthread+0x47/0x73
Jan 11 23:46:42 twister kernel:  [<ffffffff8020bdc8>] child_rip+0xa/0x12
Jan 11 23:46:42 twister kernel:  [<ffffffff80239959>] kthread+0x0/0x73
Jan 11 23:46:42 twister kernel:  [<ffffffff8020bdbe>] child_rip+0x0/0x12
Jan 11 23:46:42 twister kernel: 
Jan 11 23:46:42 twister kernel: cat           D 7fffffffffffffff     0  3978   3965
Jan 11 23:46:42 twister kernel:  ffff81009e857ce8 0000000000000086 ffff8100ae7f2900 ffff81009e857ca8
Jan 11 23:46:42 twister kernel:  ffff8100bd872000 ffff8100bf9e7060 ffffffff80652ae0 00000001000000c0
Jan 11 23:46:42 twister kernel:  0000000000000000 7fffffffffffffff 7fffffffffffffff 0000000000000002
Jan 11 23:46:42 twister kernel: Call Trace:
Jan 11 23:46:42 twister kernel:  [<ffffffff80473543>] schedule_timeout+0x1e/0xad
Jan 11 23:46:42 twister kernel:  [<ffffffff80223ccc>] __dequeue_entity+0x1c/0x32
Jan 11 23:46:42 twister kernel:  [<ffffffff80223d05>] set_next_entity+0x23/0x73
Jan 11 23:46:42 twister kernel:  [<ffffffff8047340b>] wait_for_common+0xc4/0x129
Jan 11 23:46:42 twister kernel:  [<ffffffff80224204>] default_wake_function+0x0/0xe
Jan 11 23:46:42 twister kernel:  [<ffffffff80236b02>] flush_cpu_workqueue+0x50/0x58
Jan 11 23:46:42 twister kernel:  [<ffffffff80236c32>] wq_barrier_func+0x0/0x9
Jan 11 23:46:42 twister kernel:  [<ffffffff80236ecf>] flush_workqueue+0x9/0x12
Jan 11 23:46:42 twister kernel:  [<ffffffff803449f9>] release_dev+0x47c/0x5e2
Jan 11 23:46:42 twister kernel:  [<ffffffff8021b609>] do_page_fault+0x2ff/0x65a
Jan 11 23:46:42 twister kernel:  [<ffffffff80344b6b>] tty_release+0xc/0x10
Jan 11 23:46:42 twister kernel:  [<ffffffff80277013>] __fput+0xb1/0x16f
Jan 11 23:46:42 twister kernel:  [<ffffffff80274961>] filp_close+0x5d/0x65
Jan 11 23:46:42 twister kernel:  [<ffffffff80275ab3>] sys_close+0x73/0xa6
Jan 11 23:46:42 twister kernel:  [<ffffffff8020b5fc>] tracesys+0xdc/0xe1
Jan 11 23:46:42 twister kernel: 

If I'm not mistaken the "cat" above is the "cat /dev/zero >
/dev/rfcomm0" command.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
