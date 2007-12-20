Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbXLTGE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbXLTGE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 01:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbXLTGEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 01:04:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902AbXLTGEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 01:04:14 -0500
Date: Wed, 19 Dec 2007 22:03:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70  -- 
 (triggered by "cat /proc/iomem")
Message-Id: <20071219220307.d69c0fde.akpm@linux-foundation.org>
In-Reply-To: <4769FF37.5060308@gmail.com>
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com>
	<4769F409.6030300@gmail.com>
	<4769FF37.5060308@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 00:35:51 -0500 Miles Lane <miles.lane@gmail.com> wrote:

> Added Ingo and Russell to the TO list, since they seem to potentially be 
> the right people to look into this.
> .config attached in order to not trip spam filters.
> 
> Miles Lane wrote:
> > Okay.  The command that directly triggers this is:       cat /proc/iomem
> >
> > Here is the stack trace without the line-wrapping (sorry!):
> >
> > [  251.602965] wlan0_rename: RX non-WEP frame, but expected encryption
> > [  252.868386] BUG: unable to handle kernel NULL pointer dereference 
> > at virtual address 00000018
> > [  252.868393] printing ip: c012d527 *pde = 00000000
> > [  252.868399] Oops: 0000 [#1] SMP
> > [  252.868403] last sysfs file: 
> > /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda3/stat 
> >
> > [  252.868407] Modules linked in: aes_i586 aes_generic i915 drm rfcomm 
> > l2cap bluetooth acpi_cpufreq cpufreq_stats cpufreq_conservative sbs 
> > sbshc dm_crypt sbp2 parport_pc lp parport arc4 ecb crypto_blkcipher 
> > cryptomgr crypto_algapi snd_hda_intel snd_pcm_oss snd_mixer_oss pcmcia 
> > snd_pcm iTCO_wdt iTCO_vendor_support snd_seq_dummy watchdog_core 
> > watchdog_dev snd_seq_oss snd_seq_midi tifm_7xx1 snd_rawmidi iwl3945 
> > snd_seq_midi_event rng_core tifm_core mac80211 snd_seq snd_timer 
> > snd_seq_device cfg80211 sky2 battery yenta_socket rsrc_nonstatic 
> > pcmcia_core ac snd soundcore snd_page_alloc button shpchp pci_hotplug 
> > sr_mod cdrom pata_acpi piix ide_core firewire_ohci firewire_core 
> > crc_itu_t thermal processor fan
> > [  252.868469]
> > [  252.868472] Pid: 7088, comm: head Not tainted (2.6.24-rc5-mm1 #9)
> > [  252.868476] EIP: 0060:[<c012d527>] EFLAGS: 00010297 CPU: 0
> > [  252.868481] EIP is at r_show+0x2a/0x70
> > [  252.868483] EAX: 00000000 EBX: 00000001 ECX: c07e3224 EDX: c04bb034
> > [  252.868486] ESI: 00000008 EDI: ed1f52c0 EBP: f5320f10 ESP: f5320f04
> > [  252.868489]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [  252.868493] Process head (pid: 7088, ti=f5320000 task=f532e000 
> > task.ti=f5320000)
> > [  252.868495] Stack: c03a6cac ed1f52c0 c07e3224 f5320f50 c0199a7e 
> > 00002000 bf930807 e1007800
> > [  252.868504]        ed1f52e0 00000000 00000000 000001d3 0000000e 
> > 00000000 0000000d 00000000
> > [  252.868512]        fffffffb f7d39370 c01998e4 f5320f74 c01af4f5 
> > f5320f9c 00002000 bf930807
> > [  252.868521] Call Trace:
> > [  252.868523]  [<c0107d55>] show_trace_log_lvl+0x12/0x25
> > [  252.868529]  [<c0107df2>] show_stack_log_lvl+0x8a/0x95
> > [  252.868534]  [<c0107e89>] show_registers+0x8c/0x154
> > [  252.868538]  [<c010805f>] die+0x10e/0x1d2
> > [  252.868542]  [<c039c8c9>] do_page_fault+0x52b/0x600
> > [  252.868547]  [<c039af9a>] error_code+0x72/0x78
> > [  252.868552]  [<c0199a7e>] seq_read+0x19a/0x26c
> > [  252.868557]  [<c01af4f5>] proc_reg_read+0x60/0x74
> > [  252.868562]  [<c018390d>] vfs_read+0xa2/0x11e
> > [  252.868567]  [<c0183d02>] sys_read+0x3b/0x60
> > [  252.868571]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
> > [  252.868575]  =======================
> > [  252.868577] Code: c3 55 89 d1 89 e5 57 89 c7 56 53 8b 50 64 83 7a 
> > 0c 00 77 0e 81 7a 08 ff ff 00 00 be 04 00 00 00 76 05 be 08 00 00 00 
> > 89 c8 31 db <8b> 40 18 39 d0 74 06 43 83 fb 05 75 f3 8b 41 10 ba 2f 1b 
> > 45 c0
> > [  252.868623] EIP: [<c012d527>] r_show+0x2a/0x70 SS:ESP 0068:f5320f04
> >
> >

I would be suspecting iget-stop-procfs-from-using-iget-and-read_inode.patch.

Here's a (tested) revert of various bits.  Can you please try it against
2.6.24-rc5-mm1?

Thanks.

 Documentation/filesystems/Locking |    3 +
 Documentation/filesystems/porting |   12 ++---
 Documentation/filesystems/vfs.txt |   17 ++++++-
 fs/inode.c                        |    4 +
 fs/proc/inode.c                   |   60 ++++++++++++++--------------
 include/linux/fs.h                |   14 ++++++
 6 files changed, 73 insertions(+), 37 deletions(-)

diff -puN fs/proc/inode.c~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes fs/proc/inode.c
--- a/fs/proc/inode.c~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/fs/proc/inode.c
@@ -73,6 +73,11 @@ static void proc_delete_inode(struct ino
 
 struct vfsmount *proc_mnt;
 
+static void proc_read_inode(struct inode * inode)
+{
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+}
+
 static struct kmem_cache * proc_inode_cachep;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
@@ -123,6 +128,7 @@ static int proc_remount(struct super_blo
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
+	.read_inode	= proc_read_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode	= proc_delete_inode,
 	.statfs		= simple_statfs,
@@ -395,41 +401,39 @@ struct inode *proc_get_inode(struct supe
 	if (de != NULL && !try_module_get(de->owner))
 		goto out_mod;
 
-	inode = iget_locked(sb, ino);
+	inode = iget(sb, ino);
 	if (!inode)
 		goto out_ino;
-	if (inode->i_state & I_NEW) {
-		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-		PROC_I(inode)->fd = 0;
-		PROC_I(inode)->pde = de;
-		if (de) {
-			if (de->mode) {
-				inode->i_mode = de->mode;
-				inode->i_uid = de->uid;
-				inode->i_gid = de->gid;
-			}
-			if (de->size)
-				inode->i_size = de->size;
-			if (de->nlink)
-				inode->i_nlink = de->nlink;
-			if (de->proc_iops)
-				inode->i_op = de->proc_iops;
-			if (de->proc_fops) {
-				if (S_ISREG(inode->i_mode)) {
+
+	PROC_I(inode)->fd = 0;
+	PROC_I(inode)->pde = de;
+	if (de) {
+		if (de->mode) {
+			inode->i_mode = de->mode;
+			inode->i_uid = de->uid;
+			inode->i_gid = de->gid;
+		}
+		if (de->size)
+			inode->i_size = de->size;
+		if (de->nlink)
+			inode->i_nlink = de->nlink;
+		if (de->proc_iops)
+			inode->i_op = de->proc_iops;
+		if (de->proc_fops) {
+			if (S_ISREG(inode->i_mode)) {
 #ifdef CONFIG_COMPAT
-					if (!de->proc_fops->compat_ioctl)
-						inode->i_fop =
-							&proc_reg_file_ops_no_compat;
-					else
+				if (!de->proc_fops->compat_ioctl)
+					inode->i_fop =
+						&proc_reg_file_ops_no_compat;
+				else
 #endif
-						inode->i_fop = &proc_reg_file_ops;
-				} else {
-					inode->i_fop = de->proc_fops;
-				}
+					inode->i_fop = &proc_reg_file_ops;
 			}
+			else
+				inode->i_fop = de->proc_fops;
 		}
-		unlock_new_inode(inode);
 	}
+
 	return inode;
 
 out_ino:
diff -puN Documentation/filesystems/Locking~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/Documentation/filesystems/Locking
@@ -90,6 +90,7 @@ of the locking scheme for directory oper
 prototypes:
 	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
+	void (*read_inode) (struct inode *);
 	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*put_inode) (struct inode *);
@@ -113,6 +114,7 @@ locking rules:
 			BKL	s_lock	s_umount
 alloc_inode:		no	no	no
 destroy_inode:		no
+read_inode:		no				(see below)
 dirty_inode:		no				(must not sleep)
 write_inode:		no
 put_inode:		no
@@ -131,6 +133,7 @@ show_options:		no				(vfsmount->sem)
 quota_read:		no	no	no		(see below)
 quota_write:		no	no	no		(see below)
 
+->read_inode() is not a method - it's a callback used in iget().
 ->remount_fs() will have the s_umount lock if it's already mounted.
 When called from get_sb_single, it does NOT have the s_umount lock.
 ->quota_read() and ->quota_write() functions are both guaranteed to
diff -puN Documentation/filesystems/porting~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes Documentation/filesystems/porting
--- a/Documentation/filesystems/porting~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/Documentation/filesystems/porting
@@ -34,8 +34,8 @@ FOO_I(inode) (see in-tree filesystems fo
 
 Make them ->alloc_inode and ->destroy_inode in your super_operations.
 
-Keep in mind that now you need explicit initialization of private data
-typically between calling iget_locked() and unlocking the inode.
+Keep in mind that now you need explicit initialization of private data -
+typically in ->read_inode() and after getting an inode from new_inode().
 
 At some point that will become mandatory.
 
@@ -173,10 +173,10 @@ should be a non-blocking function that i
 newly created inode to allow the test function to succeed. 'data' is
 passed as an opaque value to both test and set functions.
 
-When the inode has been created by iget5_locked(), it will be returned with the
-I_NEW flag set and will still be locked.  The filesystem then needs to finalize
-the initialization. Once the inode is initialized it must be unlocked by
-calling unlock_new_inode().
+When the inode has been created by iget5_locked(), it will be returned with
+the I_NEW flag set and will still be locked. read_inode has not been
+called so the file system still has to finalize the initialization. Once
+the inode is initialized it must be unlocked by calling unlock_new_inode().
 
 The filesystem is responsible for setting (and possibly testing) i_ino
 when appropriate. There is also a simpler iget_locked function that
diff -puN Documentation/filesystems/vfs.txt~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/Documentation/filesystems/vfs.txt
@@ -203,6 +203,8 @@ struct super_operations {
         struct inode *(*alloc_inode)(struct super_block *sb);
         void (*destroy_inode)(struct inode *);
 
+        void (*read_inode) (struct inode *);
+
         void (*dirty_inode) (struct inode *);
         int (*write_inode) (struct inode *, int);
         void (*put_inode) (struct inode *);
@@ -240,6 +242,15 @@ or bottom half).
   	->alloc_inode was defined and simply undoes anything done by
 	->alloc_inode.
 
+  read_inode: this method is called to read a specific inode from the
+        mounted filesystem.  The i_ino member in the struct inode is
+	initialized by the VFS to indicate which inode to read. Other
+	members are filled in by this method.
+
+	You can set this to NULL and use iget5_locked() instead of iget()
+	to read inodes.  This is necessary for filesystems for which the
+	inode number is not sufficient to identify an inode.
+
   dirty_inode: this method is called by the VFS to mark an inode dirty.
 
   write_inode: this method is called when the VFS needs to write an
@@ -297,9 +308,9 @@ or bottom half).
 
   quota_write: called by the VFS to write to filesystem quota file.
 
-Whoever sets up the inode is responsible for filling in the "i_op" field. This
-is a pointer to a "struct inode_operations" which describes the methods that
-can be performed on individual inodes.
+The read_inode() method is responsible for filling in the "i_op"
+field. This is a pointer to a "struct inode_operations" which
+describes the methods that can be performed on individual inodes.
 
 
 The Inode Object
diff -puN fs/inode.c~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes fs/inode.c
--- a/fs/inode.c~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/fs/inode.c
@@ -928,6 +928,8 @@ EXPORT_SYMBOL(ilookup);
  * @set:	callback used to initialize a new struct inode
  * @data:	opaque data pointer to pass to @test and @set
  *
+ * This is iget() without the read_inode() portion of get_new_inode().
+ *
  * iget5_locked() uses ifind() to search for the inode specified by @hashval
  * and @data in the inode cache and if present it is returned with an increased
  * reference count. This is a generalized version of iget_locked() for file
@@ -964,6 +966,8 @@ EXPORT_SYMBOL(iget5_locked);
  * @sb:		super block of file system
  * @ino:	inode number to get
  *
+ * This is iget() without the read_inode() portion of get_new_inode_fast().
+ *
  * iget_locked() uses ifind_fast() to search for the inode specified by @ino in
  * the inode cache and if present it is returned with an increased reference
  * count. This is for file systems where the inode number is sufficient for
diff -puN include/linux/fs.h~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes include/linux/fs.h
--- a/include/linux/fs.h~revert-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/include/linux/fs.h
@@ -1241,6 +1241,8 @@ struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
+	void (*read_inode) (struct inode *);
+  
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*put_inode) (struct inode *);
@@ -1752,6 +1754,18 @@ extern struct inode * iget5_locked(struc
 extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern void unlock_new_inode(struct inode *);
 
+static inline struct inode *iget(struct super_block *sb, unsigned long ino)
+{
+	struct inode *inode = iget_locked(sb, ino);
+	
+	if (inode && (inode->i_state & I_NEW)) {
+		sb->s_op->read_inode(inode);
+		unlock_new_inode(inode);
+	}
+
+	return inode;
+}
+
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
_

