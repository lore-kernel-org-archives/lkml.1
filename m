Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYIIK3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYIIK3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYIIK3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:29:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52118 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbYIIK3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:29:41 -0400
Date: Tue, 9 Sep 2008 12:29:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rjw@sisk.pl,
       akpm@linux-foundation.org, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.27-rc5-mm1: rmmod ide-cd_mod: tried to init an initialized  object, something is seriously wrong.
Message-ID: <20080909102925.GE20055@kernel.dk>
References: <200809051528.54213.rjw@sisk.pl> <20080908084312.GF20055@kernel.dk> <20080908092717.GH20055@kernel.dk> <200809091107.04629.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809091107.04629.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09 2008, Mariusz Kozlowski wrote:
> Witam, 
> 
> > On Mon, Sep 08 2008, Jens Axboe wrote:
> > > On Sat, Sep 06 2008, FUJITA Tomonori wrote:
> > > > On Fri, 5 Sep 2008 18:25:04 +0200
> > > > Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> > > > 
> > > > > Hello,
> > > > > 
> > > > > > > > 	Again 100% reproducible rmmod ide-cd_mod problem. Kernel is tainted because
> > > > > > > > of earlier sysfs acpi problems similar (probably identical) to those reported
> > > > > > > > by Li Zefan here http://marc.info/?l=linux-kernel&m=121921059026064&w=2
> > > > > > > > 
> > > > > > > > Steps to reproduce: unload ide-cd_mod
> > > > > > > > 
> > > > > > > > kobject (dd9e4a7c): tried to init an initialized object, something is seriously wrong.
> > > > > > > > Pid: 4734, comm: modprobe Tainted: G        W 2.6.27-rc5-mm1 #1
> > > > > > > >  [<c01ec982>] kobject_init+0xc4/0xc9
> > > > > > > >  [<c02cb84a>] ? _spin_unlock+0x27/0x3f
> > > > > > > >  [<c01aff2e>] ? sysfs_find_dirent+0x21/0x2b
> > > > > > > >  [<c01aff7e>] ? __sysfs_add_one+0x46/0x6d
> > > > > > > >  [<c01affb4>] ? sysfs_add_one+0xf/0x44
> > > > > > > >  [<c01b0036>] ? sysfs_addrm_start+0x4d/0x90
> > > > > > > >  [<c01b0f31>] ? sysfs_do_create_link+0x9a/0x14c
> > > > > > > >  [<c01ec9c5>] kobject_init_and_add+0x14/0x30
> > > > > > > >  [<c01b1009>] ? sysfs_create_link+0x12/0x19
> > > > > > > >  [<c01e8bad>] blk_register_filter+0x3b/0x46
> > > > > > > >  [<ded9e40a>] ide_cd_probe+0x253/0x5a8 [ide_cd_mod]
> > > > > > > >  [<c01b0000>] ? sysfs_addrm_start+0x17/0x90
> > > > > > > >  [<c01b0f31>] ? sysfs_do_create_link+0x9a/0x14c
> > > > > > > >  [<c01b004e>] ? sysfs_addrm_start+0x65/0x90
> > > > > > > >  [<c025145f>] generic_ide_probe+0x1f/0x21
> > > > > > > >  [<c024c002>] driver_probe_device+0x77/0x15b
> > > > > > > >  [<c02cb91b>] ? _spin_unlock_irqrestore+0x39/0x60
> > > > > > > >  [<c024c146>] __driver_attach+0x60/0x62
> > > > > > > >  [<c024b7bd>] bus_for_each_dev+0x44/0x62
> > > > > > > >  [<c0251461>] ? generic_ide_remove+0x0/0x1e
> > > > > > > >  [<c024bead>] driver_attach+0x19/0x1b
> > > > > > > >  [<c024c0e6>] ? __driver_attach+0x0/0x62
> > > > > > > >  [<c024bca8>] bus_add_driver+0x1ab/0x213
> > > > > > > >  [<c0251461>] ? generic_ide_remove+0x0/0x1e
> > > > > > > >  [<c024c291>] driver_register+0x4f/0x118
> > > > > > > >  [<de7bf000>] ? ide_cdrom_init+0x0/0xf [ide_cd_mod]
> > > > > > > >  [<de7bf00d>] ide_cdrom_init+0xd/0xf [ide_cd_mod]
> > > > > > > >  [<c0101114>] do_one_initcall+0x24/0x12f
> > > > > > > >  [<c02c9d8e>] ? mutex_unlock+0x8/0xa
> > > > > > > >  [<c01455ca>] sys_init_module+0xa5/0x1c1
> > > > > > > >  [<c0176a0a>] ? sys_read+0x3d/0x64
> > > > > > > >  [<c01030f1>] sysenter_do_call+0x12/0x35
> > > > > > > >  [<c012007b>] ? __set_special_pids+0x43/0x71
> > > > > > > > 
> > > > > > > > First time I modprobe/rmmod ide-cd_mod the system works but quickly gets unstable.
> > > > > > > > Second modprobe/rmmod is 100% fatal. Memory gets corruped seriously I guess.
> > > > > > > > pcspeaker beeps all the time, kernel throws dumps on the screen until
> > > > > > > > its really dead, sadly blinking 'leds of panic' ;)
> > > > > > > 
> > > > > > > Can you please verify if that happens with the current mainline?
> > > > > > 
> > > > > > Oops. How come I didn't find it earlier? hmm...
> > > > > 
> > > > > It's relatively new, that's why :) And this is the culprit:
> > > > > 
> > > > > abf5439370491dd6fbb4fe1a7939680d2a9bc9d4 is first bad commit
> > > > > commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4
> > > > > Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > > Date:   Sat Aug 16 14:10:05 2008 +0900
> > > > > 
> > > > >     block: move cmdfilter from gendisk to request_queue
> > > > >     
> > > > >     cmd_filter works only for the block layer SG_IO with SCSI block
> > > > >     devices. It breaks scsi/sg.c, bsg, and the block layer SG_IO with SCSI
> > > > >     character devices (such as st). We hit a kernel crash with them.
> > > > >     
> > > > >     The problem is that cmd_filter code accesses to gendisk (having struct
> > > > >     blk_scsi_cmd_filter) via inode->i_bdev->bd_disk. It works for only
> > > > >     SCSI block device files. With character device files, inode->i_bdev
> > > > >     leads you to struct cdev. inode->i_bdev->bd_disk->blk_scsi_cmd_filter
> > > > >     isn't safe.
> > > > >     
> > > > >     SCSI ULDs don't expose gendisk; they keep it private. bsg needs to be
> > > > >     independent on any protocols. We shouldn't change ULDs to expose their
> > > > >     gendisk.
> > > > >     
> > > > >     This patch moves struct blk_scsi_cmd_filter from gendisk to
> > > > >     request_queue, a common object, which eveyone can access to.
> > > > >     
> > > > >     The user interface doesn't change; users can change the filters via
> > > > >     /sys/block/. gendisk has a pointer to request_queue so the cmd_filter
> > > > >     code accesses to struct blk_scsi_cmd_filter.
> > > > >     
> > > > >     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > >     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > > > 
> > > > > > This is current mainline:
> > > > > > 
> > > > > > kobject (ddb049fc): tried to init an initialized object, something is seriously wrong.
> > > > > > Pid: 4650, comm: modprobe Not tainted 2.6.27-rc5-00132-gb380b0d #8
> > > > > >  [<c01e3196>] kobject_init+0x6a/0x6c
> > > > > >  [<c01e35cb>] kobject_init_and_add+0x14/0x30
> > > > > >  [<c01e32f7>] ? kobject_get+0x12/0x17
> > > > > >  [<c01df89c>] blk_register_filter+0x4b/0x5a
> > > > > >  [<de839310>] ide_cd_probe+0x289/0x5ae [ide_cd_mod]
> > > > > >  [<c01aad99>] ? sysfs_addrm_start+0x65/0x90
> > > > > >  [<c01aba69>] ? sysfs_do_create_link+0x9a/0x11c
> > > > > >  [<c024f7a0>] generic_ide_probe+0x1f/0x21
> > > > > >  [<c024a672>] driver_probe_device+0x77/0x15b
> > > > > >  [<c02c8bdb>] ? _spin_unlock_irqrestore+0x39/0x60
> > > > > >  [<c024a7b6>] __driver_attach+0x60/0x62
> > > > > >  [<c0249e2a>] bus_for_each_dev+0x44/0x62
> > > > > >  [<c024f7a2>] ? generic_ide_remove+0x0/0x1e
> > > > > >  [<c024a51d>] driver_attach+0x19/0x1b
> > > > > >  [<c024a756>] ? __driver_attach+0x0/0x62
> > > > > >  [<c024a318>] bus_add_driver+0x1ae/0x216
> > > > > >  [<c024f7a2>] ? generic_ide_remove+0x0/0x1e
> > > > > >  [<c024a901>] driver_register+0x4f/0x118
> > > > > >  [<dee3500d>] ide_cdrom_init+0xd/0xf [ide_cd_mod]
> > > > > >  [<c010111a>] do_one_initcall+0x2a/0x14c
> > > > > >  [<c0108560>] ? native_sched_clock+0x58/0xa1
> > > > > >  [<dee35000>] ? ide_cdrom_init+0x0/0xf [ide_cd_mod]
> > > > > >  [<c013d042>] ? trace_hardirqs_on+0xb/0xd
> > > > > >  [<c013cfaf>] ? trace_hardirqs_on_caller+0xac/0x134
> > > > > >  [<c0147083>] sys_init_module+0x7e/0x19f
> > > > > >  [<c013cfaf>] ? trace_hardirqs_on_caller+0xac/0x134
> > > > > >  [<c01e8144>] ? trace_hardirqs_on_thunk+0xc/0x10
> > > > > >  [<c0103035>] sysenter_do_call+0x12/0x35
> > > > > >  [<c012007b>] ? put_fs_struct+0x5/0x2e
> > > > 
> > > > ide-cd uses multiple gendisks share one request_queue?
> > > > 
> > > > Here's a patch for mainline.
> > > 
> > > Hmm, I don't think that it does. There's a queue per drive in the old
> > > IDE driver, so there should be a 1:1 relation between queues and gendisk
> > > there.
> > 
> > I think the problem here is due to the usage of kobject_init_and_add().
> > When we hit the add the second time, the ->state_initalised in the kojb
> > is still 1. The below should fix it.
> > 
> > The ->state_initalised stuff is a disaster imho, it should be shot and
> > killed.
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 6cb3c6d..820132b 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -495,6 +495,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
> >  	INIT_LIST_HEAD(&q->timeout_list);
> >  
> >  	kobject_init(&q->kobj, &blk_queue_ktype);
> > +	kobject_init(&q->cmd_filter.kobj, &rcf_ktype);
> >  
> >  	mutex_init(&q->sysfs_lock);
> >  	spin_lock_init(&q->__queue_lock);
> > diff --git a/block/blk.h b/block/blk.h
> > index eb13740..47d6b22 100644
> > --- a/block/blk.h
> > +++ b/block/blk.h
> > @@ -9,6 +9,7 @@
> >  
> >  extern struct kmem_cache *blk_requestq_cachep;
> >  extern struct kobj_type blk_queue_ktype;
> > +extern struct kobj_type rcf_ktype;
> >  
> >  void init_request_from_bio(struct request *req, struct bio *bio);
> >  void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
> > diff --git a/block/cmd-filter.c b/block/cmd-filter.c
> > index da7f7a4..9556e85 100644
> > --- a/block/cmd-filter.c
> > +++ b/block/cmd-filter.c
> > @@ -201,7 +201,7 @@ static struct sysfs_ops rcf_sysfs_ops = {
> >  	.store = rcf_attr_store,
> >  };
> >  
> > -static struct kobj_type rcf_ktype = {
> > +struct kobj_type rcf_ktype = {
> >  	.sysfs_ops = &rcf_sysfs_ops,
> >  	.default_attrs = default_attrs,
> >  };
> > @@ -211,8 +211,7 @@ int blk_register_filter(struct gendisk *disk)
> >  	int ret;
> >  	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
> >  
> > -	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype,
> > -				   &disk_to_dev(disk)->kobj,
> > +	ret = kobject_add(&filter->kobj, &disk_to_dev(disk)->kobj,
> >  				   "%s", "cmd_filter");
> >  	if (ret < 0)
> >  		return ret;
> > 
> 
> I applied your fix to 2.6.27-rc5-mm1 (it doesn't apply to mainline) and the result 
> is that when I first rmmod ide-cd_mod it's ok, but it seems that the module is not
> unregistered because when you rmmod ide-cd_mod again immediately you will see this:
> 
> BUG: atomic counter underflow at:
> Pid: 4920, comm: rmmod Tainted: G        W 2.6.27-rc5-mm1 #4
>  [<c01ec579>] ? kobject_release+0x0/0x59
>  [<c01ed300>] kref_put+0x4c/0x7c
>  [<c01ec4cc>] kobject_put+0x20/0x4e
>  [<c01aed10>] ? sysfs_hash_and_remove+0x50/0x57
>  [<c01e8d4b>] blk_unregister_filter+0x13/0x15
>  [<dedd822b>] ide_cd_remove+0xf/0x21 [ide_cd_mod]
>  [<c025147b>] generic_ide_remove+0x1a/0x1e
>  [<c024bdaf>] __device_release_driver+0x59/0x7f
>  [<c024be6c>] driver_detach+0x97/0x99
>  [<c024b26e>] bus_remove_driver+0x6f/0x8b
>  [<c024c231>] driver_unregister+0x2f/0x33
>  [<deddb341>] ide_cdrom_exit+0xd/0xf [ide_cd_mod]
>  [<c0143da5>] sys_delete_module+0x10d/0x1e2
>  [<c0162cbc>] ? do_munmap+0x1d7/0x234
>  [<c0163d13>] ? sys_munmap+0x30/0x36
>  [<c01030f1>] sysenter_do_call+0x12/0x35
>  =======================
> hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
> 
> Btw I found something interesting. On earlier kernels - 2.6.25 I can not remove ide-cd_mod
> at all - it's still there when I lsmod modules:
> 
> # modprobe ide-cd_mod
> # rmmod ide-cd_mod
> # rmmod ide-cd_mod
> # rmmod ide-cd_mod
> # rmmod ide-cd_mod
> # rmmod ide-cd_mod
> # rmmod ide-cd_mod
> # rmmod ide-cd_mod
> # lsmod | grep ide_cd
> ide_cd_mod             29600  0 
> cdrom                  32160  1 ide_cd_mod
> 
> On the other hand on newer kernels (post 2.6.26 - these which did not blow up) right
> after boot I have to run rmmod ide-cd_mod exactly three times to have ide-cd_mod
> unloaded. If I modprobe and rmmod again it works as expected. Why is this?
> 
> laptop mako # modprobe ide-cd_mod
> laptop mako # rmmod ide-cd_mod
> laptop mako # rmmod ide-cd_mod
> laptop mako # rmmod ide-cd_mod
> laptop mako # rmmod ide-cd_mod
> ERROR: Module ide_cd_mod does not exist in /proc/modules
> laptop mako # modprobe ide-cd_mod
> laptop mako # rmmod ide-cd_mod
> laptop mako # rmmod ide-cd_mod
> ERROR: Module ide_cd_mod does not exist in /proc/modules

Can you try the below patch from Elias?

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 304ec73..0120c8e 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -9,12 +9,6 @@
 
 #include "blk.h"
 
-struct queue_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(struct request_queue *, char *);
-	ssize_t (*store)(struct request_queue *, const char *, size_t);
-};
-
 static ssize_t
 queue_var_show(unsigned int var, char *page)
 {
diff --git a/block/blk.h b/block/blk.h
index c79f30e..9ab0d6a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -10,6 +10,12 @@
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kobj_type blk_queue_ktype;
 
+struct queue_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct request_queue *, char *);
+	ssize_t (*store)(struct request_queue *, const char *, size_t);
+};
+
 void init_request_from_bio(struct request *req, struct bio *bio);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index 228b644..fc0f0b2 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -26,6 +26,8 @@
 #include <scsi/scsi.h>
 #include <linux/cdrom.h>
 
+#include "blk.h"
+
 int blk_verify_command(struct blk_cmd_filter *filter,
 		       unsigned char *cmd, int has_write_perm)
 {
@@ -50,9 +52,9 @@ int blk_verify_command(struct blk_cmd_filter *filter,
 EXPORT_SYMBOL(blk_verify_command);
 
 /* and now, the sysfs stuff */
-static ssize_t rcf_cmds_show(struct blk_cmd_filter *filter, char *page,
-			     int rw)
+static ssize_t rcf_cmds_show(struct request_queue *q, char *page, int rw)
 {
+	struct blk_cmd_filter *filter = &q->cmd_filter;
 	char *npage = page;
 	unsigned long *okbits;
 	int i;
@@ -76,24 +78,27 @@ static ssize_t rcf_cmds_show(struct blk_cmd_filter *filter, char *page,
 	return npage - page;
 }
 
-static ssize_t rcf_readcmds_show(struct blk_cmd_filter *filter, char *page)
+static ssize_t rcf_readcmds_show(struct request_queue *q, char *page)
 {
-	return rcf_cmds_show(filter, page, READ);
+	return rcf_cmds_show(q, page, READ);
 }
 
-static ssize_t rcf_writecmds_show(struct blk_cmd_filter *filter,
-				 char *page)
+static ssize_t rcf_writecmds_show(struct request_queue *q, char *page)
 {
-	return rcf_cmds_show(filter, page, WRITE);
+	return rcf_cmds_show(q, page, WRITE);
 }
 
-static ssize_t rcf_cmds_store(struct blk_cmd_filter *filter,
-			      const char *page, size_t count, int rw)
+static ssize_t rcf_cmds_store(struct request_queue *q, const char *page,
+			      size_t count, int rw)
 {
+	struct blk_cmd_filter *filter = &q->cmd_filter;
 	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
 	int cmd, set;
 	char *p, *status;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	if (rw == READ) {
 		memcpy(&okbits, filter->read_ok, sizeof(okbits));
 		target_okbits = filter->read_ok;
@@ -128,31 +133,25 @@ static ssize_t rcf_cmds_store(struct blk_cmd_filter *filter,
 	return count;
 }
 
-static ssize_t rcf_readcmds_store(struct blk_cmd_filter *filter,
-				  const char *page, size_t count)
+static ssize_t rcf_readcmds_store(struct request_queue *q, const char *page,
+				  size_t count)
 {
-	return rcf_cmds_store(filter, page, count, READ);
+	return rcf_cmds_store(q, page, count, READ);
 }
 
-static ssize_t rcf_writecmds_store(struct blk_cmd_filter *filter,
-				   const char *page, size_t count)
+static ssize_t rcf_writecmds_store(struct request_queue *q, const char *page,
+				   size_t count)
 {
-	return rcf_cmds_store(filter, page, count, WRITE);
+	return rcf_cmds_store(q, page, count, WRITE);
 }
 
-struct rcf_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(struct blk_cmd_filter *, char *);
-	ssize_t (*store)(struct blk_cmd_filter *, const char *, size_t);
-};
-
-static struct rcf_sysfs_entry rcf_readcmds_entry = {
+static struct queue_sysfs_entry rcf_readcmds_entry = {
 	.attr = { .name = "read_table", .mode = S_IRUGO | S_IWUSR },
 	.show = rcf_readcmds_show,
 	.store = rcf_readcmds_store,
 };
 
-static struct rcf_sysfs_entry rcf_writecmds_entry = {
+static struct queue_sysfs_entry rcf_writecmds_entry = {
 	.attr = {.name = "write_table", .mode = S_IRUGO | S_IWUSR },
 	.show = rcf_writecmds_show,
 	.store = rcf_writecmds_store,
@@ -164,72 +163,30 @@ static struct attribute *default_attrs[] = {
 	NULL,
 };
 
-#define to_rcf(atr) container_of((atr), struct rcf_sysfs_entry, attr)
-
-static ssize_t
-rcf_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
-{
-	struct rcf_sysfs_entry *entry = to_rcf(attr);
-	struct blk_cmd_filter *filter;
-
-	filter = container_of(kobj, struct blk_cmd_filter, kobj);
-	if (entry->show)
-		return entry->show(filter, page);
-
-	return 0;
-}
-
-static ssize_t
-rcf_attr_store(struct kobject *kobj, struct attribute *attr,
-			const char *page, size_t length)
-{
-	struct rcf_sysfs_entry *entry = to_rcf(attr);
-	struct blk_cmd_filter *filter;
-
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	if (!entry->store)
-		return -EINVAL;
-
-	filter = container_of(kobj, struct blk_cmd_filter, kobj);
-	return entry->store(filter, page, length);
-}
-
-static struct sysfs_ops rcf_sysfs_ops = {
-	.show = rcf_attr_show,
-	.store = rcf_attr_store,
-};
-
-static struct kobj_type rcf_ktype = {
-	.sysfs_ops = &rcf_sysfs_ops,
-	.default_attrs = default_attrs,
+static struct attribute_group rcf_attr_group = {
+	.name = "cmd_filter",
+	.attrs = default_attrs,
 };
 
 int blk_register_filter(struct gendisk *disk)
 {
+	struct kobject *kobj = &disk->queue->kobj;
 	int ret;
-	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
-	struct kobject *parent = kobject_get(disk->holder_dir->parent);
 
-	if (!parent)
-		return -ENODEV;
+	ret = sysfs_create_group(kobj, &rcf_attr_group);
+	if (!ret)
+		ret = sysfs_create_link_to_group(disk->holder_dir->parent,
+						 kobj, rcf_attr_group.name,
+						 rcf_attr_group.name);
+	WARN_ON(ret);
 
-	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype, parent,
-				   "%s", "cmd_filter");
-
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(blk_register_filter);
 
 void blk_unregister_filter(struct gendisk *disk)
 {
-	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
-
-	kobject_put(&filter->kobj);
-	kobject_put(disk->holder_dir->parent);
+	sysfs_remove_link(disk->holder_dir->parent, rcf_attr_group.name);
+	sysfs_remove_group(&disk->queue->kobj, &rcf_attr_group);
 }
 EXPORT_SYMBOL(blk_unregister_filter);
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index a3ba217..d2813a1 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -19,22 +19,16 @@
 
 #include "sysfs.h"
 
-static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
+static int sysfs_sd_create_link(struct sysfs_dirent *parent_sd,
+				struct sysfs_dirent *target_sd,
 				const char *name, int warn)
 {
-	struct sysfs_dirent *parent_sd = NULL;
-	struct sysfs_dirent *target_sd = NULL;
 	struct sysfs_dirent *sd = NULL;
 	struct sysfs_addrm_cxt acxt;
 	int error;
 
 	BUG_ON(!name);
 
-	if (!kobj)
-		parent_sd = &sysfs_root;
-	else
-		parent_sd = kobj->sd;
-
 	error = -EFAULT;
 	if (!parent_sd)
 		goto out_put;
@@ -43,8 +37,8 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 	 * sysfs_assoc_lock.  Fetch target_sd from it.
 	 */
 	spin_lock(&sysfs_assoc_lock);
-	if (target->sd)
-		target_sd = sysfs_get(target->sd);
+	if (target_sd)
+		target_sd = sysfs_get(target_sd);
 	spin_unlock(&sysfs_assoc_lock);
 
 	error = -ENOENT;
@@ -77,6 +71,19 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 	return error;
 }
 
+static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
+				const char *name, int warn)
+{
+	struct sysfs_dirent *parent_sd;
+
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
+		parent_sd = kobj->sd;
+
+	return sysfs_sd_create_link(parent_sd, target->sd, name, warn);
+}
+
 /**
  *	sysfs_create_link - create symlink between two objects.
  *	@kobj:	object whose directory we're creating the link in.
@@ -104,6 +111,26 @@ int sysfs_create_link_nowarn(struct kobject *kobj, struct kobject *target,
 	return sysfs_do_create_link(kobj, target, name, 0);
 }
 
+int sysfs_create_link_to_group(struct kobject *kobj, struct kobject *target,
+			       const char *group, const char *linkname)
+{
+	struct sysfs_dirent *sd;
+	int ret;
+
+	BUG_ON(!kobj || !target);
+
+	sd = sysfs_get_dirent(target->sd, group);
+	if (!sd) {
+		WARN(!sd, KERN_WARNING "sysfs group %p not found for "
+		     "kobject '%s'\n", group, kobject_name(target));
+		return -ENOENT;
+	}
+
+	ret = sysfs_sd_create_link(kobj->sd, sd, linkname, 1);
+	sysfs_put(sd);
+	return ret;
+}
+
 /**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
@@ -213,4 +240,5 @@ const struct inode_operations sysfs_symlink_inode_operations = {
 
 
 EXPORT_SYMBOL_GPL(sysfs_create_link);
+EXPORT_SYMBOL_GPL(sysfs_create_link_to_group);
 EXPORT_SYMBOL_GPL(sysfs_remove_link);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 44710d7..ca616b7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -286,7 +286,6 @@ struct blk_queue_tag {
 struct blk_cmd_filter {
 	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
 	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-	struct kobject kobj;
 };
 
 struct request_queue
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 37fa241..e9e0971 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -116,6 +116,8 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
+int sysfs_create_link_to_group(struct kobject *kobj, struct kobject *target,
+			       const char *grpname, const char *linkname);
 
 void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
 

-- 
Jens Axboe

