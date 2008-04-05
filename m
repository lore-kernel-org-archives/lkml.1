Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbYDEHdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbYDEHdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 03:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYDEHd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 03:33:28 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:57155 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYDEHd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 03:33:27 -0400
X-Greylist: delayed 1327 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Apr 2008 03:33:26 EDT
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP S.A.L.
To: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com
Subject: probably XFS regression 2.6.24.x to 2.6.25-rc7-git5, XFS very unstable
Date: Sat, 5 Apr 2008 10:11:33 +0300
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804051011.33579.denys@visp.net.lb>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On loaded proxies running under 2.6.25-rc7-git one, and 2.6.25-rc8 i have at night outages. 
The filesystem is crashing without any serious reason (there is no power outage or even reboot). Even i did xfs_repair, after while it is crashing again, 
so probably or there is my mistake or regression kind of very serious.
On some proxies i did kexec while upgrading kernel, and probably filesystem was not unmounted properly. But it crashes again after xfs_repair!
I have absolutely same configuration proxy with 2.6.24.x, it is rock solid.

Here is dmesg i have on crash
uname 
Linux Proxy-Karam114 2.6.25-rc7-git5-build-0026 #10 SMP Mon Mar 31 04:41:05 EEST 2008 i686 unknown
mount options
/bin/mount -o noatime -L CACHE1 /cache1
/bin/mount -o noatime -L CACHE2 /cache2

Proxy-Karam114 /proc/sys/fs/xfs # grep "" *
age_buffer_centisecs:1500
error_level:3
filestream_centisecs:3000
inherit_noatime:1
inherit_nodefrag:1
inherit_nodump:1
inherit_nosymlinks:0
inherit_sync:1
irix_sgid_inherit:0
irix_symlink_mode:0
panic_mask:0
restrict_chown:1
rotorstep:1
stats_clear:0
xfsbufd_centisecs:100
xfssyncd_centisecs:3000

Apr  2 09:08:52 194.146.153.114 kernel: [194090.355098] xfs_force_shutdown(sdd1,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xf8b25dd6
Crashed, probably FS was unclean, i did xfs_repair

Here FS probably unclean
Apr  4 03:03:10 194.146.153.114 kernel: [350703.385931] xfs_inotobp: xfs_imap()  returned an error 22 on sdd1.  Returning error.
Apr  4 03:03:10 194.146.153.114 kernel: [350703.385931] xfs_iunlink_remove: xfs_inotobp()  returned an error 22 on sdd1.  Returning error.
Apr  4 03:03:10 194.146.153.114 kernel: [350703.385931] xfs_inactive:   xfs_ifree() returned an error = 22 on sdd1
Apr  4 03:03:10 194.146.153.114 kernel: [350703.385931] xfs_force_shutdown(sdd1,0x1) called from line 1737 of file fs/xfs/xfs_vnodeops.c.  Return address = 0xf8b257db
Apr  4 03:03:10 194.146.153.114 kernel: [379153.774514] xfs_difree: xfs_inobt_lookup_le returned()  an error 5 on sdd1.  Returning error.
Apr  4 03:03:10 194.146.153.114 kernel: [379153.838789] xfs_iunlink_remove: xfs_itobp()  returned an error 5 on sdd1.  Returning error.
Apr  4 03:03:10 194.146.153.114 kernel: [379153.838843] xfs_iunlink_remove: xfs_trans_read_buf()  returned an error 5 on sdd1.  Returning error.
Apr  4 03:03:10 194.146.153.114 kernel: [379153.838865] xfs_iunlink_remove: xfs_trans_read_buf()  returned an error 5 on sdd1.  Returning error.
Apr  4 03:03:10 194.146.153.114 kernel: [379153.867218] xfs_difree: xfs_inobt_lookup_le returned()  an error 5 on sdd1.  Returning error.
Apr  4 03:03:10 194.146.153.114 kernel: [379153.867243] xfs_iunlink_remove: xfs_trans_read_buf()  returned an error 5 on sdd1.  Returning error.




First errors appears in squid, nothing came to dmesg from kernel
Apr  4 03:46:38 194.146.153.28 squid[1793]: cache_dir /cache3/squid: (5) Input/output error
Apr  4 03:46:38 194.146.153.28 ERROR: squid stopped? status 134
Apr  4 03:46:41 194.146.153.28 ERROR: squid started
Apr  4 03:46:41 194.146.153.28 squid[2073]: cache_dir /cache3/squid: (5) Input/output error
Apr  4 03:46:41 194.146.153.28 ERROR: squid stopped? status 134
Apr  4 03:46:43 194.146.153.28 ERROR: squid started

After while
Apr  4 06:44:26 194.146.153.28 kernel: [285436.482594] xfs_force_shutdown(sde1,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xf8b73dd6


-- 
------
Technical Manager
Virtual ISP S.A.L.
Lebanon
