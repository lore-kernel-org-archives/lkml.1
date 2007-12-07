Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbXLGWRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbXLGWRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbXLGWRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:17:03 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:18786 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbXLGWRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:17:00 -0500
Date: Fri, 7 Dec 2007 14:15:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: vincent.fortier1@ec.gc.ca, akpm <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-Id: <20071207141536.1e9199dc.randy.dunlap@oracle.com>
In-Reply-To: <1196776021.14468.2.camel@kayak.wul.qc.ec.gc.ca>
References: <1196427774.10204.4.camel@kayak.wul.qc.ec.gc.ca>
	<20071130091239.708173db.randy.dunlap@oracle.com>
	<F1D642E5A91BC94D9504EC83AE19E6B0B8998E@ecqcmtlmail3.quebec.int.ec.gc.ca>
	<1196776021.14468.2.camel@kayak.wul.qc.ec.gc.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 13:47:01 +0000 Vincent Fortier wrote:

> Le vendredi 30 novembre 2007 à 12:35 -0500, Fortier,Vincent [Montreal] a
> écrit :
> > > -----Message d'origine-----
> > > De : Randy Dunlap [mailto:randy.dunlap@oracle.com] 
> > > Envoyé : 30 novembre 2007 12:13
> > > 
> > > On Fri, 30 Nov 2007 13:02:54 +0000 Vincent Fortier wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > I'm using a 2.6.22.14 + CFS v24 and I got theses errors 
> > > when starting 
> > > > up my commvault galaxy client...  Do anybody know what this could mean?
> > > 
> > > Can you provide a few lines of syslog before the Oops: line, 
> > > which should contain some info about what happened, e.g.:
> > > 
> > > Unable to handle kernel paging request at virtual address 
> > > e4a85017 printing eip:
> > > c01d915a
> > > *pde = 37d0d067
> > > *pte = 00000000
> > 
> 
> I've umounted the XFS/DRBD filesystem/container (tought it might have
> been related?) but it did not helped... still getting the same kernel
> oops.
> 
> [1097523.808915] BUG: unable to handle kernel paging request at virtual
> address 80000000
> [1097523.808950]  printing eip:
> [1097523.808963] c01d915a
> [1097523.808977] *pdpt = 00000000220ea001
> [1097523.808992] *pde = 0000000000000000
> [1097523.809009] Oops: 0000 [#27]
> [1097523.809023] SMP
> [1097523.809040] Modules linked in: xfs drbd cn nfs nfsd exportfs lockd
> nfs_acl sunrpc ppdev parport_pc lp parport button ac battery ipv6 fuse
> ide_cd ide_generic usbkbd usbmouse tsdev serio_raw sg psmouse iTCO_wdt
> iTCO_vendor_support floppy e752x_edac sr_mod pcspkr evdev edac_mc shpchp
> pci_hotplug cdrom ext3 jbd mbcache dm_mirror dm_snapshot dm_mod generic
> piix ide_core ehci_hcd uhci_hcd tg3 ata_piix usbcore thermal processor
> fan mptscsih mptbase megaraid_sas megaraid_mbox megaraid_mm cciss
> aacraid
> [1097523.809266] CPU:    0
> [1097523.809268] EIP:    0060:[<c01d915a>]    Not tainted VLI
> [1097523.809269] EFLAGS: 00010297   (2.6.22.14-cfs-etch-686-envcan #1)
> [1097523.809323] EIP is at vsnprintf+0x2af/0x48c
> [1097523.809341] eax: 80000000   ebx: ffffffff   ecx: 80000000   edx:
> fffffffe
> [1097523.809361] esi: d89c6017   edi: dd1ffeac   ebp: ffffffff   esp:
> dd1ffe4c
> [1097523.809382] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [1097523.809403] Process clBackup (pid: 30311, ti=dd1fe000 task=f7043290
> task.ti=dd1fe000)
> [1097523.809423] Stack: dbc2a000 00001000 c033b638 f89e056c c02360f1
> dbc2a000 27639fe8 d89c6017
> [1097523.809469]        008e2408 00000000 ffffffff 00000000 ffffffff
> c0337eab 00000003 00000017
> [1097523.809512]        c037a340 dbc2a000 c01d93b8 dd1ffeac dd1ffeac
> c023566c d89c6017 c0337eaa
> [1097523.809559] Call Trace:
> [1097523.809588]  [<c02360f1>] dev_uevent+0x189/0x1e0
> [1097523.809614]  [<c01d93b8>] sprintf+0x20/0x23
> [1097523.809635]  [<c023566c>] show_uevent+0xad/0xd5
> [1097523.809658]  [<c01571d1>] get_page_from_freelist+0x273/0x30a
> [1097523.809686]  [<c01323fc>] group_send_sig_info+0x12/0x56
> [1097523.809711]  [<c01572ba>] __alloc_pages+0x52/0x286
> [1097523.809734]  [<c02355bf>] show_uevent+0x0/0xd5
> [1097523.809754]  [<c023517e>] dev_attr_show+0x15/0x18
> [1097523.809775]  [<c01a8e9f>] sysfs_read_file+0x87/0xd8
> [1097523.809796]  [<c01880bc>] sys_getxattr+0x46/0x4e
> [1097523.809818]  [<c01a8e18>] sysfs_read_file+0x0/0xd8
> [1097523.809839]  [<c0171fb7>] vfs_read+0xa6/0x128
> [1097523.809861]  [<c01723b3>] sys_read+0x41/0x67
> [1097523.809881]  [<c0103d8a>] syscall_call+0x7/0xb
> [1097523.809906]  =======================
> [1097523.809921] Code: 74 24 28 73 03 c6 06 20 4d 46 85 ed 7f f1 e9 b9
> 00 00 00 8b 0f b8 39 0a 33 c0 8b 54 24 30 81 f9 ff 0f 00 00 0f 46 c8 89
> c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 f6 44 24 2c 10 89
> c3
> [1097523.810088] EIP: [<c01d915a>] vsnprintf+0x2af/0x48c SS:ESP
> 0068:dd1ffe4c
> 
> Help would really be appreciated.

Let's try the last_sysfs_file (name) patch.
I've attempted to update it for 2.6.22.14.
Andrew, does this change in fs/sysfs/file.c look OK?

---
~Randy



From: Randy Dunlap <randy.dunlap@oracle.com>

Record last_sysfs_file name to print during oopsen so that we can
have a clue.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/i386/kernel/traps.c |    6 ++++++
 fs/sysfs/file.c          |    6 ++++++
 2 files changed, 12 insertions(+)

--- linux-2.6.22.14.orig/arch/i386/kernel/traps.c
+++ linux-2.6.22.14/arch/i386/kernel/traps.c
@@ -411,6 +411,12 @@ void die(const char * str, struct pt_reg
 #endif
 		if (nl)
 			printk("\n");
+		{
+			extern char last_sysfs_file[];
+
+			printk(KERN_ALERT "last sysfs file: %s\n",
+					last_sysfs_file);
+		}
 		if (notify_die(DIE_OOPS, str, regs, err,
 					current->thread.trap_no, SIGSEGV) !=
 				NOTIFY_STOP) {
--- linux-2.6.22.14.orig/fs/sysfs/file.c
+++ linux-2.6.22.14/fs/sysfs/file.c
@@ -8,6 +8,7 @@
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
+#include <linux/limits.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 
@@ -245,6 +246,8 @@ out:
 	return len;
 }
 
+char last_sysfs_file[PATH_MAX];
+
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
@@ -279,6 +282,9 @@ static int sysfs_open_file(struct inode 
 	if (!ops)
 		goto Eaccess;
 
+	d_path(file->f_path.dentry, sysfs_mount, last_sysfs_file,
+			sizeof(last_sysfs_file));
+
 	/* make sure we have a collection to add our buffers to */
 	mutex_lock(&inode->i_mutex);
 	if (!(set = inode->i_private)) {

