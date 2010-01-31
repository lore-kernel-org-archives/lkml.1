Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699Ab0AaOzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0AaOzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 09:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306Ab0AaOzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 09:55:33 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37819 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752214Ab0AaOzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 09:55:31 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 09:55:31 EST
Date: Sun, 31 Jan 2010 06:47:50 -0800
From: Aaron Straus <aaron@merfinllc.com>
To: raven@themaw.net, Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org
Subject: nfs automount sysfs_add_one warning with 2.6.32
Message-ID: <20100131144750.GA26469@merfinllc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  Since upgrading to 2.6.32.x we've started hitting the warning below.
It seems to have caused a hiccup in our app as well. 

  It's a 64-bit vanilla kernel running with 32-bit userspace on a
Nehalem-based HP blade running RH4.  Though I've hit it on a few other
types of machines as well for example an Ubuntu Hardy desktop Dell box.

  I can't tell if this is an automount or NFS issue.

The mount we seem to be attempting is:

  t:/srv/data /mnt/m/data nfs rw,relatime,vers=3,rsize=8192,wsize=8192,namlen=255,hard,proto=tcp,port=65535,timeo=600,retrans=2,sec=sys,mountport=65535,addr=x.x.x.100 0 0

The auto.master file is served via NIS and the master file has:

  /mnt/m yp:auto.local rsize=8192,wsize=8192,hard,intr

While the map file has this in it:

  data t:/srv/data

Anyway, let me know if you need any other information (.config, dmesg,
etc.) and thanks for the help!

					=a=

--
The excerpt from the syslog follows:

Jan 31 02:37:36 possum7 kernel: ------------[ cut here ]------------
Jan 31 02:37:36 possum7 kernel: WARNING: at fs/sysfs/dir.c:491 sysfs_add_one+0x87/0x9b()
Jan 31 02:37:36 possum7 kernel: Hardware name: ProLiant BL2x220c G6
Jan 31 02:37:36 possum7 kernel: sysfs: cannot create duplicate filename '/class/bdi/0:19'
Jan 31 02:37:36 possum7 kernel: Modules linked in: nfs lockd autofs4 sunrpc cpufreq_powersave usbhid video acpi_pad ehci_hcd uhci_hcd usbcore igb ata_piix [last unloaded: x_tables]
Jan 31 02:37:36 possum7 kernel: Pid: 19618, comm: mount Not tainted 2.6.32.7-asb #75
Jan 31 02:37:36 possum7 kernel: Call Trace:
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810df8ad>] ? sysfs_add_one+0x87/0x9b
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810359dd>] warn_slowpath_common+0x77/0x8f
Jan 31 02:37:36 possum7 kernel:  [<ffffffff81035a6a>] warn_slowpath_fmt+0x64/0x66
Jan 31 02:37:36 possum7 kernel:  [<ffffffff81122b02>] ? ida_get_new_above+0x103/0x18d
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810df526>] ? sysfs_ilookup_test+0x0/0x14
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810df81e>] ? sysfs_pathname+0x37/0x3f
Jan 31 02:37:36 possum7 automount[19617]: >> mount: File exists
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810df81e>] ? sysfs_pathname+0x37/0x3f
Jan 31 02:37:36 possum7 automount[19617]: mount(nfs): nfs: mount failure t:/srv/data on /mnt/m/data
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810df81e>] ? sysfs_pathname+0x37/0x3f
Jan 31 02:37:36 possum7 automount[19617]: failed to mount /mnt/m/data
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810df8ad>] sysfs_add_one+0x87/0x9b
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810dfe5f>] create_dir+0x58/0x93
Jan 31 02:37:36 possum7 kernel:  [<ffffffff810dfed2>] sysfs_create_dir+0x38/0x4f
Jan 31 02:37:36 possum7 kernel:  [<ffffffff8112368f>] ? kobject_get+0x1a/0x22
Jan 31 02:37:36 possum7 kernel:  [<ffffffff81123772>] kobject_add_internal+0xdb/0x19c
Jan 31 02:37:36 possum7 kernel:  [<ffffffff8112390b>] kobject_add_varg+0x41/0x4d
Jan 31 02:37:36 possum7 kernel:  [<ffffffff81123cba>] kobject_add+0x89/0x8b
Jan 31 02:37:36 possum7 kernel:  [<ffffffffa00b0c2f>] ? rpc_run_task+0x52/0x5a [sunrpc]
Jan 31 02:37:37 possum7 kernel:  [<ffffffff8112368f>] ? kobject_get+0x1a/0x22
Jan 31 02:37:37 possum7 kernel:  [<ffffffff811b699e>] ? get_device+0x14/0x1a
Jan 31 02:37:37 possum7 kernel:  [<ffffffff811b7016>] device_add+0xaf/0x563
Jan 31 02:37:37 possum7 kernel:  [<ffffffff811234be>] ? kobject_init+0x42/0x6a
Jan 31 02:37:37 possum7 kernel:  [<ffffffff811b74e3>] device_register+0x19/0x1e
Jan 31 02:37:37 possum7 kernel:  [<ffffffff811b7583>] device_create_vargs+0x9b/0xc9
Jan 31 02:37:37 possum7 kernel:  [<ffffffff8107ba35>] bdi_register+0x7e/0x147
Jan 31 02:37:37 possum7 kernel:  [<ffffffff81096e21>] ? set_anon_super+0x71/0xe7
Jan 31 02:37:37 possum7 kernel:  [<ffffffffa0116f9a>] ? nfs_set_super+0x24/0x3c [nfs]
Jan 31 02:37:37 possum7 kernel:  [<ffffffff810978a0>] ? sget+0x3ae/0x3c0
Jan 31 02:37:37 possum7 kernel:  [<ffffffffa0116f76>] ? nfs_set_super+0x0/0x3c [nfs]
Jan 31 02:37:37 possum7 kernel:  [<ffffffff8107bb21>] bdi_register_dev+0x23/0x26
Jan 31 02:37:37 possum7 kernel:  [<ffffffffa0116f74>] nfs_bdi_register+0x13/0x15 [nfs]
Jan 31 02:37:37 possum7 kernel:  [<ffffffffa0117f07>] nfs_get_sb+0x887/0xac7 [nfs]
Jan 31 02:37:37 possum7 kernel:  [<ffffffff81093c76>] ? __alloc_percpu+0xb/0xd
Jan 31 02:37:37 possum7 kernel:  [<ffffffff81097b05>] vfs_kern_mount+0x56/0xc9
Jan 31 02:37:37 possum7 kernel:  [<ffffffff81097bd5>] do_kern_mount+0x47/0xed
Jan 31 02:37:37 possum7 kernel:  [<ffffffff810abdd5>] do_mount+0x6be/0x723
Jan 31 02:37:37 possum7 kernel:  [<ffffffff810c9888>] compat_sys_mount+0x1f4/0x234
Jan 31 02:37:37 possum7 kernel:  [<ffffffff81027ef4>] sysenter_dispatch+0x7/0x2b
Jan 31 02:37:37 possum7 kernel: ---[ end trace 211698af59a534e7 ]---
Jan 31 02:37:37 possum7 kernel: kobject_add_internal failed for 0:19 with -EEXIST, don't try to register things with the same name in the same directory.
Jan 31 02:37:37 possum7 kernel: Pid: 19618, comm: mount Tainted: G        W  2.6.32.7-asb #75
Jan 31 02:37:37 possum7 kernel: Call Trace:
Jan 31 02:37:37 possum7 kernel:  [<ffffffff81123567>] ? kobject_put+0x47/0x4b
Jan 31 02:37:38 possum7 kernel:  [<ffffffff811237f0>] kobject_add_internal+0x159/0x19c
Jan 31 02:37:38 possum7 kernel:  [<ffffffff8112390b>] kobject_add_varg+0x41/0x4d
Jan 31 02:37:38 possum7 kernel:  [<ffffffff81123cba>] kobject_add+0x89/0x8b
Jan 31 02:37:38 possum7 kernel:  [<ffffffffa00b0c2f>] ? rpc_run_task+0x52/0x5a [sunrpc]
Jan 31 02:37:38 possum7 kernel:  [<ffffffff8112368f>] ? kobject_get+0x1a/0x22
Jan 31 02:37:38 possum7 kernel:  [<ffffffff811b699e>] ? get_device+0x14/0x1a
Jan 31 02:37:38 possum7 kernel:  [<ffffffff811b7016>] device_add+0xaf/0x563
Jan 31 02:37:38 possum7 kernel:  [<ffffffff811234be>] ? kobject_init+0x42/0x6a
Jan 31 02:37:38 possum7 kernel:  [<ffffffff811b74e3>] device_register+0x19/0x1e
Jan 31 02:37:38 possum7 kernel:  [<ffffffff811b7583>] device_create_vargs+0x9b/0xc9
Jan 31 02:37:38 possum7 kernel:  [<ffffffff8107ba35>] bdi_register+0x7e/0x147
Jan 31 02:37:38 possum7 kernel:  [<ffffffff81096e21>] ? set_anon_super+0x71/0xe7
Jan 31 02:37:38 possum7 kernel:  [<ffffffffa0116f9a>] ? nfs_set_super+0x24/0x3c [nfs]
Jan 31 02:37:38 possum7 kernel:  [<ffffffff810978a0>] ? sget+0x3ae/0x3c0
Jan 31 02:37:38 possum7 kernel:  [<ffffffffa0116f76>] ? nfs_set_super+0x0/0x3c [nfs]
Jan 31 02:37:38 possum7 kernel:  [<ffffffff8107bb21>] bdi_register_dev+0x23/0x26
Jan 31 02:37:38 possum7 kernel:  [<ffffffffa0116f74>] nfs_bdi_register+0x13/0x15 [nfs]
Jan 31 02:37:38 possum7 kernel:  [<ffffffffa0117f07>] nfs_get_sb+0x887/0xac7 [nfs]
Jan 31 02:37:38 possum7 kernel:  [<ffffffff81093c76>] ? __alloc_percpu+0xb/0xd
Jan 31 02:37:38 possum7 kernel:  [<ffffffff81097b05>] vfs_kern_mount+0x56/0xc9
Jan 31 02:37:38 possum7 kernel:  [<ffffffff81097bd5>] do_kern_mount+0x47/0xed
Jan 31 02:37:38 possum7 kernel:  [<ffffffff810abdd5>] do_mount+0x6be/0x723
Jan 31 02:37:38 possum7 kernel:  [<ffffffff810c9888>] compat_sys_mount+0x1f4/0x234
Jan 31 02:37:38 possum7 kernel:  [<ffffffff81027ef4>] sysenter_dispatch+0x7/0x2b
