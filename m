Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbXLIXpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbXLIXpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 18:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXLIXpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 18:45:10 -0500
Received: from pat.uio.no ([129.240.10.15]:35832 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbXLIXpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 18:45:08 -0500
Subject: Re: BUG fs/dcache.c:595 in 2.4.24rc3-git3 during NFS umount
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <200712081422.30815.ak@suse.de>
References: <200712031623.58223.ak@suse.de>  <200712081422.30815.ak@suse.de>
Content-Type: multipart/mixed; boundary="=-uvrAxHD9nvR+PYSn88t7"
Date: Sun, 09 Dec 2007 18:45:01 -0500
Message-Id: <1197243901.11792.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.4, required=5.0, autolearn=disabled, AWL=-0.351)
X-UiO-Scanned: 671EF6ABB855125E73EADD493F30708EEB57FAFF
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -3 maxlevel 200 minaction 2 bait 0 mail/h: 243 total 5650616 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uvrAxHD9nvR+PYSn88t7
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sat, 2007-12-08 at 14:22 +0100, Andi Kleen wrote:
>  [39943.212533] ------------[ cut here ]------------
> [39943.221973] kernel BUG at fs/dcache.c:595!
> [39943.230369] invalid opcode: 0000 [1] SMP
> [39943.238638] last sysfs file: /devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> [39943.253998] CPU 3
> [39943.258283] Modules linked in: nfs lockd nfs_acl sunrpc autofs4 iptable_filter ip_tables ip6table_filter ip6_tables x_tables af_packet ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq dm_crypt ext2 ext3 jbd mbcache loop dm_mod e1000 i2c_i801 shpchp container pci_hotplug button iTCO_wdt rtc_cmos rtc_core i2c_core iTCO_vendor_support rtc_lib sr_mod cdrom floppy sg ehci_hcd uhci_hcd sd_mod usbcore edd reiserfs fan aic79xx scsi_transport_spi ata_piix ahci libata scsi_mod thermal processor
> [39943.351718] Pid: 31869, comm: umount.nfs Tainted: G       N 2.6.24-rc4-git3-20071206230004-default #1
> [39943.370555] RIP: 0010:[<ffffffff802a64ce>]  [<ffffffff802a64ce>] shrink_dcache_for_umount_subtree+0x16/0x241
> [39943.390671] RSP: 0018:ffff8101dc88fe18  EFLAGS: 00010206
> [39943.401552] RAX: 0000000000000000 RBX: ffff8100840893c0 RCX: 0000000000000000
> [39943.416040] RDX: 00000000ffffffff RSI: 0000000000000296 RDI: ffff8100840893c0
> [39943.430504] RBP: ffff8100084fff20 R08: ffff81004d0a6850 R09: 0000000000000296
> [39943.444969] R10: ffff81004d0a6850 R11: ffffffff802f778c R12: ffff810222439400
> [39943.459424] R13: 0000000000000000 R14: 00007fef065cdf00 R15: 0000000000000000
> [39943.473887] FS:  00007fef052ad6f0(0000) GS:ffff810226419940(0000) knlGS:0000000000000000
> [39943.490452] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [39943.502134] CR2: 00007f5793a36580 CR3: 000000021ee38000 CR4: 00000000000006e0
> [39943.516599] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [39943.531049] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [39943.545507] Process umount.nfs (pid: 31869, threadinfo ffff8101dc88e000, task ffff81021ef3b080)
> [39943.563289] Stack:  0000000000000296 ffff810222439400 ffffffff883e9be0 ffff810222439400
> [39943.579846]  0000000000000000 ffffffff802a6728 ffff810222439400 ffffffff80297e34
> [39943.595152]  ffff81004d0a67c0 0000000000000017 ffffffff88401a80 ffffffff80297f33
> [39943.609871] Call Trace:
> [39943.615566]  [<ffffffff802a6728>] shrink_dcache_for_umount+0x2f/0x3d
> [39943.628463]  [<ffffffff80297e34>] generic_shutdown_super+0x19/0xf1
> [39943.641011]  [<ffffffff80297f33>] kill_anon_super+0x9/0x35
> [39943.652193]  [<ffffffff883cd1ba>] :nfs:nfs_kill_super+0xd/0x16
> [39943.664037]  [<ffffffff80297fe4>] deactivate_super+0x6a/0x83
> [39943.675537]  [<ffffffff802ab8ab>] sys_umount+0x23c/0x24d
> [39943.686361]  [<ffffffff802a5c8a>] d_kill+0x40/0x55
> [39943.696139]  [<ffffffff802a7217>] dput+0x26/0x115
> [39943.705745]  [<ffffffff802970c0>] __fput+0x14a/0x179
> [39943.715861]  [<ffffffff802aabd1>] mntput_no_expire+0x1f/0x86
> [39943.727375]  [<ffffffff802946ea>] filp_close+0x5a/0x61
> [39943.737853]  [<ffffffff8020bfde>] system_call+0x7e/0x83
> [39943.748495]
> [39943.751674]
> [39943.751675] Code: 0f 0b eb fe 48 c7 c7 80 06 63 80 e8 67 75 17 00 48 8b 53 40
> [39943.770405] RIP  [<ffffffff802a64ce>] shrink_dcache_for_umount_subtree+0x16/0x241
> [39943.785790]  RSP <ffff8101dc88fe18>
> [82148.423473] JBD: barrier-based sync failed on dm-1 - disabling barriers

Hi Andi,

Does the attached patch fix the Oops?

Cheers
  Trond

--=-uvrAxHD9nvR+PYSn88t7
Content-Description: 
Content-Type: message/rfc822
Content-Disposition: inline; filename=linux-2.6.24-002-fix_oops_in_nfs_unmount.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: 
Subject: NFS: Fix an Oops in NFS unmount
Message-Id: <1197243901.11792.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Ensure that the dummy 'root dentry' is invisible to d_find_alias(). If not,
then it may be spliced into the tree if a parent directory from the same
filesystem gets mounted at a later time.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/getroot.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 0ee4384..076987e 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -57,6 +57,15 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
 		}
 		/* Circumvent igrab(): we know the inode is not being freed */
 		atomic_inc(&inode->i_count);
+		/*
+		 * Ensure that this dentry is invisible to d_find_alias().
+		 * Otherwise, it may be spliced into the tree by
+		 * d_materialise_unique if a parent directory from the same
+		 * filesystem gets mounted at a later time.
+		 * This again causes shrink_dcache_for_umount_subtree() to
+		 * Oops, since the test for IS_ROOT() will fail.
+		 */
+		sb->s_root->d_flags |= DCACHE_DISCONNECTED;
 	}
 	return 0;
 }

--=-uvrAxHD9nvR+PYSn88t7--

