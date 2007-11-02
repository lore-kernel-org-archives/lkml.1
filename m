Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXKBNQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXKBNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXKBNQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:16:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXKBNQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:16:18 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1193519317.5776.14.camel@lov.site>
References: <1193410087.6914.34.camel@twins>
	 <1193411451.2431.13.camel@lov.site> <1193412147.27652.2.camel@twins>
	 <1193412788.2431.22.camel@lov.site> <1193412836.27652.11.camel@twins>
	 <1193414147.2431.35.camel@lov.site> <1193429066.5648.35.camel@lappy>
	 <1193447889.5648.44.camel@lappy> <20071027024033.GB29039@kroah.com>
	 <1193474399.27652.15.camel@twins>  <20071027160203.GA5709@kroah.com>
	 <1193519317.5776.14.camel@lov.site>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 14:15:59 +0100
Message-Id: <1194009359.27652.377.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the help so far, however we're still not quite there.

The below patch still has the funny 20 character name limit. Is there a
good reason its a char array like this, and not just a char * to a kstr?
The code does kstrdup all over the place, I can't imagine why suddenly
limiting it to 20 chars seems like a good idea.


Mounting NFS filesystems:  mount: 192.168.0.1:/mnt/ying failed, reason given by server: Permission denied
mount: 192.168.0.1:/mnt/yang failed, reason given by server: Permission denied
[   52.705052] sysfs: duplicate filename 'bdi-nfs-192.168.0.1' can not be created
[   52.712517] WARNING: at /mnt/md0/src/linux-2.6-2/fs/sysfs/dir.c:424 sysfs_add_one()
[   52.720243]
[   52.720244] Call Trace:
[   52.724311]  [<ffffffff80304f7c>] sysfs_add_one+0xac/0xe0
[   52.729708]  [<ffffffff80305613>] create_dir+0x63/0xc0
[   52.734832]  [<ffffffff803056a4>] sysfs_create_dir+0x34/0x50
[   52.740489]  [<ffffffff804d5710>] _spin_unlock+0x30/0x60
[   52.745792]  [<ffffffff8036958e>] kobject_add+0xbe/0x200
[   52.751094]  [<ffffffff803dfc40>] device_add+0xc0/0x680
[   52.756305]  [<ffffffff803e0219>] device_register+0x19/0x20
[   52.761877]  [<ffffffff803e0697>] device_create+0xe7/0x120
[   52.767360]  [<ffffffff8036e0bc>] vsnprintf+0x2bc/0x690
[   52.772585]  [<ffffffff80370380>] kvasprintf+0x70/0x90
[   52.777724]  [<ffffffff80295bbb>] bdi_register+0x9b/0xe0
[   52.783037]  [<ffffffff8037e039>] percpu_counter_init_irq+0x39/0x50
[   52.789299]  [<ffffffff8036abcc>] prop_local_init_percpu+0x3c/0x50
[   52.795462]  [<ffffffff80295a41>] bdi_init+0x61/0xb0
[   52.800411]  [<ffffffff80308069>] nfs_probe_fsinfo+0x4d9/0x640
[   52.806226]  [<ffffffff80308f9a>] nfs_create_server+0x1ea/0x560
[   52.812123]  [<ffffffff80263526>] lock_release_holdtime+0x66/0x80
[   52.818217]  [<ffffffff802ca936>] __d_lookup+0x106/0x1d0
[   52.823529]  [<ffffffff802b0fd5>] __kmalloc_track_caller+0xa5/0x100
[   52.829789]  [<ffffffff80266185>] trace_hardirqs_on+0xd5/0x170
[   52.835618]  [<ffffffff80312412>] nfs_get_sb+0x2b2/0x740
[   52.840931]  [<ffffffff80312459>] nfs_get_sb+0x2f9/0x740
[   52.846245]  [<ffffffff802d0000>] __put_mnt_ns+0x90/0xa0
[   52.851556]  [<ffffffff802b89db>] vfs_kern_mount+0xbb/0x150
[   52.857127]  [<ffffffff802b8ade>] do_kern_mount+0x4e/0x100
[   52.862614]  [<ffffffff802d122c>] do_mount+0x4dc/0x7a0
[   52.867751]  [<ffffffff80266185>] trace_hardirqs_on+0xd5/0x170
[   52.873580]  [<ffffffff804d5842>] _spin_unlock_irqrestore+0x42/0x80
[   52.879841]  [<ffffffff8036c505>] __up_read+0x45/0xb0
[   52.884894]  [<ffffffff80255aa5>] search_exception_tables+0x25/0x40
[   52.891155]  [<ffffffff8028d1d5>] get_page_from_freelist+0x4a5/0x760
[   52.897487]  [<ffffffff8028a58f>] bad_range+0x1f/0x80
[   52.902540]  [<ffffffff8028d0b7>] get_page_from_freelist+0x387/0x760
[   52.908888]  [<ffffffff8028d54e>] __alloc_pages+0x6e/0x3b0
[   52.914374]  [<ffffffff802a80ea>] alloc_pages_current+0x5a/0x90
[   52.920290]  [<ffffffff8028c97b>] __get_free_pages+0x1b/0x40
[   52.925929]  [<ffffffff802cf892>] copy_mount_options+0x52/0x170
[   52.931827]  [<ffffffff802d1584>] sys_mount+0x94/0xe0
[   52.936881]  [<ffffffff804d49cd>] trace_hardirqs_on_thunk+0x35/0x3a
[   52.943141]  [<ffffffff8020c43e>] system_call+0x7e/0x83
[   52.948357]
[   52.949850] kobject_add failed for bdi-nfs-192.168.0.1 with -EEXIST, don't try to register things with the same name in the same directory.
[   52.962332]

(just in case it wasn't obvious, the -%p part that was supposed to make
it unique got truncated)

---
 block/genhd.c               |    3 +
 fs/fuse/inode.c             |    3 -
 fs/nfs/client.c             |    3 -
 include/linux/backing-dev.h |   19 +++++++
 include/linux/writeback.h   |    3 +
 lib/percpu_counter.c        |    1 
 mm/backing-dev.c            |  107 ++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |    2 
 8 files changed, 138 insertions(+), 3 deletions(-)

Index: linux-2.6-2/block/genhd.c
===================================================================
--- linux-2.6-2.orig/block/genhd.c
+++ linux-2.6-2/block/genhd.c
@@ -182,6 +182,8 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	bdi_register(&disk->queue->backing_dev_info, NULL,
+		"bdi-%s", disk->disk_name);
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -190,6 +192,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 void unlink_gendisk(struct gendisk *disk)
 {
 	blk_unregister_queue(disk);
+	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
 }
Index: linux-2.6-2/fs/fuse/inode.c
===================================================================
--- linux-2.6-2.orig/fs/fuse/inode.c
+++ linux-2.6-2/fs/fuse/inode.c
@@ -467,7 +467,8 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
-		err = bdi_init(&fc->bdi);
+		err = bdi_init_fmt(&fc->bdi, NULL,
+				"bdi-fuse-%llu", (unsigned long long)fc->id);
 		if (err) {
 			kfree(fc);
 			fc = NULL;
Index: linux-2.6-2/fs/nfs/client.c
===================================================================
--- linux-2.6-2.orig/fs/nfs/client.c
+++ linux-2.6-2/fs/nfs/client.c
@@ -678,7 +678,8 @@ static int nfs_probe_fsinfo(struct nfs_s
 		goto out_error;
 
 	nfs_server_set_fsinfo(server, &fsinfo);
-	error = bdi_init(&server->backing_dev_info);
+	error = bdi_init_fmt(&server->backing_dev_info, NULL,
+				"bdi-nfs-%s-%p", clp->cl_hostname, server);
 	if (error)
 		goto out_error;
 
Index: linux-2.6-2/include/linux/backing-dev.h
===================================================================
--- linux-2.6-2.orig/include/linux/backing-dev.h
+++ linux-2.6-2/include/linux/backing-dev.h
@@ -11,6 +11,8 @@
 #include <linux/percpu_counter.h>
 #include <linux/log2.h>
 #include <linux/proportions.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -48,11 +50,28 @@ struct backing_dev_info {
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
+
+	struct device *dev;
 };
 
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...);
+void bdi_unregister(struct backing_dev_info *bdi);
+
+#define bdi_init_fmt(bdi, parent, fmt...)			\
+	({							\
+	 	int ret = bdi_init(bdi);			\
+	 	if (!ret) {					\
+	 		ret = bdi_register(bdi, parent, ##fmt);	\
+	 		if (ret)				\
+	 			bdi_destroy(bdi);		\
+	 	}						\
+	 	ret;						\
+	 })
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
Index: linux-2.6-2/include/linux/writeback.h
===================================================================
--- linux-2.6-2.orig/include/linux/writeback.h
+++ linux-2.6-2/include/linux/writeback.h
@@ -113,6 +113,9 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
+void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		 struct backing_dev_info *bdi);
+
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
Index: linux-2.6-2/mm/backing-dev.c
===================================================================
--- linux-2.6-2.orig/mm/backing-dev.c
+++ linux-2.6-2/mm/backing-dev.c
@@ -4,12 +4,115 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/writeback.h>
+#include <linux/device.h>
+
+
+static struct class *bdi_class;
+
+static ssize_t readahead_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+
+	bdi->ra_pages = simple_strtoul(buf, &end, 10);
+
+	return end - buf;
+}
+
+#define BDI_SHOW(name, expr)						\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *page)	\
+{									\
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
+									\
+	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
+}
+
+BDI_SHOW(readahead, bdi->ra_pages)
+
+BDI_SHOW(reclaimable, bdi_stat(bdi, BDI_RECLAIMABLE))
+BDI_SHOW(writeback, bdi_stat(bdi, BDI_WRITEBACK))
+
+static inline unsigned long get_dirty(struct backing_dev_info *bdi, int i)
+{
+	unsigned long thresh[3];
+
+	get_dirty_limits(&thresh[0], &thresh[1], &thresh[2], bdi);
+
+	return thresh[i];
+}
+
+BDI_SHOW(dirty, get_dirty(bdi, 1))
+BDI_SHOW(bdi_dirty, get_dirty(bdi, 2))
+
+static struct device_attribute bdi_dev_attrs[] = {
+	__ATTR(readahead, 0644, readahead_show, readahead_store),
+	__ATTR_RO(reclaimable),
+	__ATTR_RO(writeback),
+	__ATTR_RO(dirty),
+	__ATTR_RO(bdi_dirty),
+	__ATTR_NULL,
+};
+
+static __init int bdi_class_init(void)
+{
+	bdi_class = class_create(THIS_MODULE, "bdi");
+	bdi_class->dev_attrs = bdi_dev_attrs;
+	return 0;
+}
+
+__initcall(bdi_class_init);
+
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...)
+{
+	char *name;
+	va_list args;
+	int ret = 0;
+	struct device *dev;
+
+	va_start(args, fmt);
+	name = kvasprintf(GFP_KERNEL, fmt, args);
+	va_end(args);
+
+	if (!name)
+		return -ENOMEM;
+
+	dev = device_create(bdi_class, parent, MKDEV(0,0), name);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto exit;
+	}
+
+	bdi->dev = dev;
+	dev_set_drvdata(bdi->dev, bdi);
+
+exit:
+	kfree(name);
+	return ret;
+}
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+	if (bdi->dev) {
+		device_unregister(bdi->dev);
+		bdi->dev = NULL;
+	}
+}
+
+EXPORT_SYMBOL(bdi_register);
+EXPORT_SYMBOL(bdi_unregister);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, j;
 	int err;
 
+	bdi->dev = NULL;
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
@@ -33,6 +136,8 @@ void bdi_destroy(struct backing_dev_info
 {
 	int i;
 
+	bdi_unregister(bdi);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
Index: linux-2.6-2/mm/page-writeback.c
===================================================================
--- linux-2.6-2.orig/mm/page-writeback.c
+++ linux-2.6-2/mm/page-writeback.c
@@ -291,7 +291,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {
Index: linux-2.6-2/lib/percpu_counter.c
===================================================================
--- linux-2.6-2.orig/lib/percpu_counter.c
+++ linux-2.6-2/lib/percpu_counter.c
@@ -102,6 +102,7 @@ void percpu_counter_destroy(struct percp
 		return;
 
 	free_percpu(fbc->counters);
+	fbc->counters = NULL;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);


