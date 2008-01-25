Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbYAYVvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbYAYVvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYAYVvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:51:39 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:60410 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbYAYVvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:51:37 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
       "Bryan O'Sullivan" <bryan.osullivan@qlogic.com>,
       Arthur Jones <arthur.jones@qlogic.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 148/196] Infiniband: make ipath driver use default driver groups.
X-Message-Flag: Warning: May contain useful information
References: <20080125071127.GA4860@kroah.com>
	<1201246425-5058-69-git-send-email-gregkh@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 25 Jan 2008 13:51:32 -0800
In-Reply-To: <1201246425-5058-69-git-send-email-gregkh@suse.de> (Greg Kroah-Hartman's message of "Thu, 24 Jan 2008 23:32:57 -0800")
Message-ID: <adabq79lgkb.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jan 2008 21:51:33.0644 (UTC) FILETIME=[7371E4C0:01C85F9C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

with Linus's latest kernel v2.6.24-412-gb47711b (which includes the
patch in the email I'm replying to), I see the following when I do
"modprobe -r ib_ipath" (on a system that actually has ipath hardware):

 kernel BUG at fs/sysfs/group.c:74!
 invalid opcode: 0000 [1] SMP
 CPU 1
 Modules linked in: fan ac battery ipv6 nfs lockd nfs_acl sunrpc dm_snapshot dm_mirror dm_mod loop ide_cd cdrom e1000 amd74xx generic psmouse shpchp pci_hotplug thermal ib_ipath serio_raw ehci_hcd ohci_hcd evdev button i2c_nforce2 ide_core processor ib_core k8temp i2c_core
 Pid: 3975, comm: modprobe Not tainted 2.6.24 #24
 RIP: 0010:[<ffffffff802bdbdb>]  [<ffffffff802bdbdb>] sysfs_remove_group+0x25/0x94
 RSP: 0000:ffff8101fbc33db8  EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81007d8bc070
 RDX: ffff81007d634272 RSI: ffff81007d634d00 RDI: ffffffff80503090
 RBP: ffffffff880a7220 R08: 0000000000000000 R09: ffff81007d8bc070
 R10: 0000000000000000 R11: 00000000fd812590 R12: ffff81007d8bc070
 R13: 00007fffc6f88c80 R14: 0000000000000000 R15: 0000000000000000
 FS:  00002acbe409b6e0(0000) GS:ffff81007e001a00(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00002acbe3e59de0 CR3: 000000007d482000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process modprobe (pid: 3975, threadinfo ffff8101fbc32000, task ffff8101fbead590)
 Stack:  000000000e9000ff ffff81007d8bc160 ffff81007d8bc070 ffffffff88087574
  ffffc20001734000 ffffc20001734000 ffffffff880a7050 ffffffff88074b26
  ffffffff804bd39a ffff81007d8bc000 ffffffff880a7050 ffffffff804bd39a
 Call Trace:
  [<ffffffff88087574>] :ib_ipath:ipath_device_remove_group+0x20/0x42
  [<ffffffff88074b26>] :ib_ipath:ipath_remove_one+0x9f/0x431
  [<ffffffff803235e5>] pci_device_remove+0x24/0x47
  [<ffffffff8036ec01>] __device_release_driver+0x74/0x97
  [<ffffffff8036f075>] driver_detach+0x96/0xd5
  [<ffffffff8036e568>] bus_remove_driver+0x7b/0x9e
  [<ffffffff803238da>] pci_unregister_driver+0x29/0x7d
  [<ffffffff8809093f>] :ib_ipath:infinipath_cleanup+0x33/0x40
  [<ffffffff8025032a>] sys_delete_module+0x199/0x1cf
  [<ffffffff80318400>] __up_read+0x2/0x8a
  [<ffffffff8020befe>] system_call+0x7e/0x83

 Code: 0f 0b eb fe 48 85 db 74 2e 83 3b 00 75 26 48 c7 c1 d8 ae 43
 RIP  [<ffffffff802bdbdb>] sysfs_remove_group+0x25/0x94
  RSP <ffff8101fbc33db8>

The BUG() in question is the one here:

	void sysfs_remove_group(struct kobject * kobj, 
				const struct attribute_group * grp)
	{
		struct sysfs_dirent *dir_sd = kobj->sd;
		struct sysfs_dirent *sd;
	
		if (grp->name) {
			sd = sysfs_get_dirent(dir_sd, grp->name);
			BUG_ON(!sd);

Any ideas here?  I'll continue to try to relearn all the sysfs stuff
but a hint my make things go faster.

Thanks,
  Roland
