Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYKDRZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYKDRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYKDRZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:25:21 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3199 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYKDRZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:25:20 -0500
Date: Tue, 4 Nov 2008 18:25:17 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.26] WARN warn_on_slowpath
Message-ID: <20081104172513.GH23232@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Nov  5 16:29:01 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running my http://vanheusden.com/pyk/ script (which randomly
inserts and removes modules) I triggered the folllowing WARNING in a
2.6.26 kernel on an IBM xSeries x3650 (2 quadcores (intel qc x5450)
and 10GB ram).

[ 2812.832441] sysfs group ffffffffa0191ec0 not found for kobject 'cpufreq'
[ 2812.833486] ------------[ cut here ]------------
[ 2812.833556] WARNING: at fs/sysfs/group.c:139 cpufreq_stats_free_table+0x32/0x6e [cpufreq_stats]()
[ 2812.837160] Modules linked in: cpufreq_ondemand sg lp cpufreq_userspace acpi_cpufreq pcspkr edac_core ses parport_pc appletalk(-) enclosure loop thermal parport cpufreq_stats(-) video output battery cdrom rng_core qla2xxx ac rfcomm l2cap bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs freq_table ipv6 evdev ext3 jbd mbcache dm_log dm_mod usbhid hid ff_memless sd_mod firmware_class scsi_transport_fc ide_pci_generic ide_core ehci_hcd uhci_hcd scsi_tgt aacraid scsi_mod processor thermal_sys [last unloaded: dm_mirror]
[ 2812.837160] Pid: 12061, comm: rmmod Not tainted 2.6.26-1-amd64 #1
[ 2812.837160] 
[ 2812.837160] Call Trace:
[ 2812.837160]  [<ffffffff80234878>] warn_on_slowpath+0x51/0x7a
[ 2812.837160]  [<ffffffff8022c195>] default_wake_function+0x0/0xe
[ 2812.837160]  [<ffffffff802e21b4>] sysfs_find_dirent+0x1b/0x2f
[ 2812.837160]  [<ffffffff802e2c62>] sysfs_get_dirent+0x51/0x59
[ 2812.837160]  [<ffffffff802e3523>] sysfs_remove_group+0x41/0xc2
[ 2812.837197]  [<ffffffffa0191380>] :cpufreq_stats:cpufreq_stats_free_table+0x32/0x6e
[ 2812.837283]  [<ffffffffa01913fd>] :cpufreq_stats:cpufreq_stats_exit+0x41/0x58
[ 2812.837355]  [<ffffffff80255200>] sys_delete_module+0x1a6/0x1fe
[ 2812.837494]  [<ffffffff8020be9a>] system_call_after_swapgs+0x8a/0x8f
[ 2812.837564] 
[ 2812.837623] ---[ end trace a70f168407a6dea1 ]---
[ 2812.837692] sysfs group ffffffffa0191ec0 not found for kobject 'cpufreq'


Folkert van Heusden

-- 
Ever wonder what is out there? Any alien races? Then please support
the seti@home project: setiathome.ssl.berkeley.edu
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
