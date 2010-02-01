Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0BAOJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:09:08 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58995 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab0BAOJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:09:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lXjn+fEMDqamQqCAQeffIW1sAi8/GJsh7whxW7AhjaHhv5EPM/gJ8eCscIcxcXm5yY
         cXeT5x32Qu0ZxRxdwhtIojgB5d2BurJfi8tKpnSI6NHQNbjRpwLBgCn5vINEWVnDPK7u
         Cp7540lRT/PzF1LwPhhDL6LRHI+5GwmcVZf7A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 01 Feb 2010 15:08:51 +0100
Message-Id: <20100201140851.15716.90237.sendpatchset@localhost>
In-Reply-To: <20100201140832.15716.393.sendpatchset@localhost>
References: <20100201140832.15716.393.sendpatchset@localhost>
Subject: [PATCH 3/4] ide: remove obsolete /proc/ide/hdx/ settings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove obsolete /proc/ide/hdx/ settings

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c          |    6 
 drivers/ide/ide-disk.h        |    2 
 drivers/ide/ide-disk_proc.c   |   22 --
 drivers/ide/ide-floppy.h      |    2 
 drivers/ide/ide-floppy_proc.c |   13 -
 drivers/ide/ide-gd.c          |    7 
 drivers/ide/ide-proc.c        |  310 ------------------------------------------
 drivers/ide/ide-tape.c        |   57 -------
 include/linux/ide.h           |   32 ----
 9 files changed, 1 insertion(+), 450 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1420,11 +1420,6 @@ static ide_proc_entry_t *ide_cd_proc_ent
 {
 	return idecd_proc;
 }
-
-static const struct ide_proc_devset *ide_cd_proc_devsets(ide_drive_t *drive)
-{
-	return NULL;
-}
 #endif
 
 static const struct cd_list_entry ide_cd_quirks_list[] = {
@@ -1578,7 +1573,6 @@ static struct ide_driver ide_cdrom_drive
 	.do_request		= ide_cd_do_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_cd_proc_entries,
-	.proc_devsets		= ide_cd_proc_devsets,
 #endif
 };
 
Index: b/drivers/ide/ide-disk.h
===================================================================
--- a/drivers/ide/ide-disk.h
+++ b/drivers/ide/ide-disk.h
@@ -19,11 +19,9 @@ int ide_disk_ioctl(ide_drive_t *, struct
 #ifdef CONFIG_IDE_PROC_FS
 /* ide-disk_proc.c */
 extern ide_proc_entry_t ide_disk_proc[];
-extern const struct ide_proc_devset ide_disk_settings[];
 #endif
 #else
 #define ide_disk_proc		NULL
-#define ide_disk_settings	NULL
 #endif
 
 #endif /* __IDE_DISK_H */
Index: b/drivers/ide/ide-disk_proc.c
===================================================================
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -150,25 +150,3 @@ ide_proc_entry_t ide_disk_proc[] = {
 	{ "smart_thresholds", S_IFREG|S_IRUSR, &idedisk_st_proc_fops	},
 	{}
 };
-
-ide_devset_rw_field(bios_cyl, bios_cyl);
-ide_devset_rw_field(bios_head, bios_head);
-ide_devset_rw_field(bios_sect, bios_sect);
-ide_devset_rw_field(failures, failures);
-ide_devset_rw_field(lun, lun);
-ide_devset_rw_field(max_failures, max_failures);
-
-const struct ide_proc_devset ide_disk_settings[] = {
-	IDE_PROC_DEVSET(acoustic,	0,   254),
-	IDE_PROC_DEVSET(address,	0,     2),
-	IDE_PROC_DEVSET(bios_cyl,	0, 65535),
-	IDE_PROC_DEVSET(bios_head,	0,   255),
-	IDE_PROC_DEVSET(bios_sect,	0,    63),
-	IDE_PROC_DEVSET(failures,	0, 65535),
-	IDE_PROC_DEVSET(lun,		0,     7),
-	IDE_PROC_DEVSET(max_failures,	0, 65535),
-	IDE_PROC_DEVSET(multcount,	0,    16),
-	IDE_PROC_DEVSET(nowerr,		0,     1),
-	IDE_PROC_DEVSET(wcache,		0,     1),
-	{ NULL },
-};
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -29,11 +29,9 @@ int ide_floppy_ioctl(ide_drive_t *, stru
 #ifdef CONFIG_IDE_PROC_FS
 /* ide-floppy_proc.c */
 extern ide_proc_entry_t ide_floppy_proc[];
-extern const struct ide_proc_devset ide_floppy_settings[];
 #endif
 #else
 #define ide_floppy_proc		NULL
-#define ide_floppy_settings	NULL
 #endif
 
 #endif /*__IDE_FLOPPY_H */
Index: b/drivers/ide/ide-floppy_proc.c
===================================================================
--- a/drivers/ide/ide-floppy_proc.c
+++ b/drivers/ide/ide-floppy_proc.c
@@ -30,16 +30,3 @@ ide_proc_entry_t ide_floppy_proc[] = {
 	{ "geometry",	S_IFREG|S_IRUGO, &ide_geometry_proc_fops	},
 	{}
 };
-
-ide_devset_rw_field(bios_cyl, bios_cyl);
-ide_devset_rw_field(bios_head, bios_head);
-ide_devset_rw_field(bios_sect, bios_sect);
-ide_devset_rw_field(ticks, pc_delay);
-
-const struct ide_proc_devset ide_floppy_settings[] = {
-	IDE_PROC_DEVSET(bios_cyl,  0, 1023),
-	IDE_PROC_DEVSET(bios_head, 0,  255),
-	IDE_PROC_DEVSET(bios_sect, 0,   63),
-	IDE_PROC_DEVSET(ticks,	   0,  255),
-	{ NULL },
-};
Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -146,12 +146,6 @@ static ide_proc_entry_t *ide_disk_proc_e
 {
 	return (drive->media == ide_disk) ? ide_disk_proc : ide_floppy_proc;
 }
-
-static const struct ide_proc_devset *ide_disk_proc_devsets(ide_drive_t *drive)
-{
-	return (drive->media == ide_disk) ? ide_disk_settings
-					  : ide_floppy_settings;
-}
 #endif
 
 static ide_startstop_t ide_gd_do_request(ide_drive_t *drive,
@@ -174,7 +168,6 @@ static struct ide_driver ide_gd_driver =
 	.do_request		= ide_gd_do_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_disk_proc_entries,
-	.proc_devsets		= ide_disk_proc_devsets,
 #endif
 };
 
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -7,11 +7,6 @@
 
 /*
  * This is the /proc/ide/ filesystem implementation.
- *
- * Drive/Driver settings can be retrieved by reading the drive's
- * "settings" files.  e.g.    "cat /proc/ide0/hda/settings"
- * To write a new value "val" into a specific setting "name", use:
- *   echo "name:val" >/proc/ide/ide0/hda/settings
  */
 
 #include <linux/module.h>
@@ -153,293 +148,6 @@ static const struct file_operations ide_
 	.release	= single_release,
 };
 
-/**
- *	ide_find_setting	-	find a specific setting
- *	@st: setting table pointer
- *	@name: setting name
- *
- *	Scan's the setting table for a matching entry and returns
- *	this or NULL if no entry is found. The caller must hold the
- *	setting semaphore
- */
-
-static
-const struct ide_proc_devset *ide_find_setting(const struct ide_proc_devset *st,
-					       char *name)
-{
-	while (st->name) {
-		if (strcmp(st->name, name) == 0)
-			break;
-		st++;
-	}
-	return st->name ? st : NULL;
-}
-
-/**
- *	ide_read_setting	-	read an IDE setting
- *	@drive: drive to read from
- *	@setting: drive setting
- *
- *	Read a drive setting and return the value. The caller
- *	must hold the ide_setting_mtx when making this call.
- *
- *	BUGS: the data return and error are the same return value
- *	so an error -EINVAL and true return of the same value cannot
- *	be told apart
- */
-
-static int ide_read_setting(ide_drive_t *drive,
-			    const struct ide_proc_devset *setting)
-{
-	const struct ide_devset *ds = setting->setting;
-	int val = -EINVAL;
-
-	if (ds->get)
-		val = ds->get(drive);
-
-	return val;
-}
-
-/**
- *	ide_write_setting	-	read an IDE setting
- *	@drive: drive to read from
- *	@setting: drive setting
- *	@val: value
- *
- *	Write a drive setting if it is possible. The caller
- *	must hold the ide_setting_mtx when making this call.
- *
- *	BUGS: the data return and error are the same return value
- *	so an error -EINVAL and true return of the same value cannot
- *	be told apart
- *
- *	FIXME:  This should be changed to enqueue a special request
- *	to the driver to change settings, and then wait on a sema for completion.
- *	The current scheme of polling is kludgy, though safe enough.
- */
-
-static int ide_write_setting(ide_drive_t *drive,
-			     const struct ide_proc_devset *setting, int val)
-{
-	const struct ide_devset *ds = setting->setting;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-	if (!ds->set)
-		return -EPERM;
-	if ((ds->flags & DS_SYNC)
-	    && (val < setting->min || val > setting->max))
-		return -EINVAL;
-	return ide_devset_execute(drive, ds, val);
-}
-
-ide_devset_get(xfer_rate, current_speed);
-
-static int set_xfer_rate (ide_drive_t *drive, int arg)
-{
-	struct ide_cmd cmd;
-
-	if (arg < XFER_PIO_0 || arg > XFER_UDMA_6)
-		return -EINVAL;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.tf.command = ATA_CMD_SET_FEATURES;
-	cmd.tf.feature = SETFEATURES_XFER;
-	cmd.tf.nsect   = (u8)arg;
-	cmd.valid.out.tf = IDE_VALID_FEATURE | IDE_VALID_NSECT;
-	cmd.valid.in.tf  = IDE_VALID_NSECT;
-	cmd.tf_flags   = IDE_TFLAG_SET_XFER;
-
-	return ide_no_data_taskfile(drive, &cmd);
-}
-
-ide_devset_rw(current_speed, xfer_rate);
-ide_devset_rw_field(init_speed, init_speed);
-ide_devset_rw_flag(nice1, IDE_DFLAG_NICE1);
-ide_devset_rw_field(number, dn);
-
-static const struct ide_proc_devset ide_generic_settings[] = {
-	IDE_PROC_DEVSET(current_speed, 0, 70),
-	IDE_PROC_DEVSET(init_speed, 0, 70),
-	IDE_PROC_DEVSET(io_32bit,  0, 1 + (SUPPORT_VLB_SYNC << 1)),
-	IDE_PROC_DEVSET(keepsettings, 0, 1),
-	IDE_PROC_DEVSET(nice1, 0, 1),
-	IDE_PROC_DEVSET(number, 0, 3),
-	IDE_PROC_DEVSET(pio_mode, 0, 255),
-	IDE_PROC_DEVSET(unmaskirq, 0, 1),
-	IDE_PROC_DEVSET(using_dma, 0, 1),
-	{ NULL },
-};
-
-static void proc_ide_settings_warn(void)
-{
-	printk_once(KERN_WARNING "Warning: /proc/ide/hd?/settings interface is "
-			    "obsolete, and will be removed soon!\n");
-}
-
-static int ide_settings_proc_show(struct seq_file *m, void *v)
-{
-	const struct ide_proc_devset *setting, *g, *d;
-	const struct ide_devset *ds;
-	ide_drive_t	*drive = (ide_drive_t *) m->private;
-	int		rc, mul_factor, div_factor;
-
-	proc_ide_settings_warn();
-
-	mutex_lock(&ide_setting_mtx);
-	g = ide_generic_settings;
-	d = drive->settings;
-	seq_printf(m, "name\t\t\tvalue\t\tmin\t\tmax\t\tmode\n");
-	seq_printf(m, "----\t\t\t-----\t\t---\t\t---\t\t----\n");
-	while (g->name || (d && d->name)) {
-		/* read settings in the alphabetical order */
-		if (g->name && d && d->name) {
-			if (strcmp(d->name, g->name) < 0)
-				setting = d++;
-			else
-				setting = g++;
-		} else if (d && d->name) {
-			setting = d++;
-		} else
-			setting = g++;
-		mul_factor = setting->mulf ? setting->mulf(drive) : 1;
-		div_factor = setting->divf ? setting->divf(drive) : 1;
-		seq_printf(m, "%-24s", setting->name);
-		rc = ide_read_setting(drive, setting);
-		if (rc >= 0)
-			seq_printf(m, "%-16d", rc * mul_factor / div_factor);
-		else
-			seq_printf(m, "%-16s", "write-only");
-		seq_printf(m, "%-16d%-16d", (setting->min * mul_factor + div_factor - 1) / div_factor, setting->max * mul_factor / div_factor);
-		ds = setting->setting;
-		if (ds->get)
-			seq_printf(m, "r");
-		if (ds->set)
-			seq_printf(m, "w");
-		seq_printf(m, "\n");
-	}
-	mutex_unlock(&ide_setting_mtx);
-	return 0;
-}
-
-static int ide_settings_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_settings_proc_show, PDE(inode)->data);
-}
-
-#define MAX_LEN	30
-
-static ssize_t ide_settings_proc_write(struct file *file, const char __user *buffer,
-				       size_t count, loff_t *pos)
-{
-	ide_drive_t	*drive = (ide_drive_t *) PDE(file->f_path.dentry->d_inode)->data;
-	char		name[MAX_LEN + 1];
-	int		for_real = 0, mul_factor, div_factor;
-	unsigned long	n;
-
-	const struct ide_proc_devset *setting;
-	char *buf, *s;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	proc_ide_settings_warn();
-
-	if (count >= PAGE_SIZE)
-		return -EINVAL;
-
-	s = buf = (char *)__get_free_page(GFP_USER);
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, buffer, count)) {
-		free_page((unsigned long)buf);
-		return -EFAULT;
-	}
-
-	buf[count] = '\0';
-
-	/*
-	 * Skip over leading whitespace
-	 */
-	while (count && isspace(*s)) {
-		--count;
-		++s;
-	}
-	/*
-	 * Do one full pass to verify all parameters,
-	 * then do another to actually write the new settings.
-	 */
-	do {
-		char *p = s;
-		n = count;
-		while (n > 0) {
-			unsigned val;
-			char *q = p;
-
-			while (n > 0 && *p != ':') {
-				--n;
-				p++;
-			}
-			if (*p != ':')
-				goto parse_error;
-			if (p - q > MAX_LEN)
-				goto parse_error;
-			memcpy(name, q, p - q);
-			name[p - q] = 0;
-
-			if (n > 0) {
-				--n;
-				p++;
-			} else
-				goto parse_error;
-
-			val = simple_strtoul(p, &q, 10);
-			n -= q - p;
-			p = q;
-			if (n > 0 && !isspace(*p))
-				goto parse_error;
-			while (n > 0 && isspace(*p)) {
-				--n;
-				++p;
-			}
-
-			mutex_lock(&ide_setting_mtx);
-			/* generic settings first, then driver specific ones */
-			setting = ide_find_setting(ide_generic_settings, name);
-			if (!setting) {
-				if (drive->settings)
-					setting = ide_find_setting(drive->settings, name);
-				if (!setting) {
-					mutex_unlock(&ide_setting_mtx);
-					goto parse_error;
-				}
-			}
-			if (for_real) {
-				mul_factor = setting->mulf ? setting->mulf(drive) : 1;
-				div_factor = setting->divf ? setting->divf(drive) : 1;
-				ide_write_setting(drive, setting, val * div_factor / mul_factor);
-			}
-			mutex_unlock(&ide_setting_mtx);
-		}
-	} while (!for_real++);
-	free_page((unsigned long)buf);
-	return count;
-parse_error:
-	free_page((unsigned long)buf);
-	printk("%s(): parse error\n", __func__);
-	return -EINVAL;
-}
-
-static const struct file_operations ide_settings_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_settings_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= ide_settings_proc_write,
-};
-
 static int ide_capacity_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "%llu\n", (long long)0x7fffffff);
@@ -616,7 +324,6 @@ static ide_proc_entry_t generic_drive_en
 	{ "identify",	S_IFREG|S_IRUSR,	 &ide_identify_proc_fops},
 	{ "media",	S_IFREG|S_IRUGO,	 &ide_media_proc_fops	},
 	{ "model",	S_IFREG|S_IRUGO,	 &ide_dmodel_proc_fops	},
-	{ "settings",	S_IFREG|S_IRUSR|S_IWUSR, &ide_settings_proc_fops},
 	{}
 };
 
@@ -645,10 +352,6 @@ static void ide_remove_proc_entries(stru
 
 void ide_proc_register_driver(ide_drive_t *drive, struct ide_driver *driver)
 {
-	mutex_lock(&ide_setting_mtx);
-	drive->settings = driver->proc_devsets(drive);
-	mutex_unlock(&ide_setting_mtx);
-
 	ide_add_proc_entries(drive->proc, driver->proc_entries(drive), drive);
 }
 
@@ -659,23 +362,12 @@ EXPORT_SYMBOL(ide_proc_register_driver);
  *	@drive: drive
  *	@driver: driver
  *
- *	Clean up the driver specific /proc files and IDE settings
- *	for a given drive.
- *
- *	Takes ide_setting_mtx.
+ *	Clean up the driver specific /proc files for a given drive.
  */
 
 void ide_proc_unregister_driver(ide_drive_t *drive, struct ide_driver *driver)
 {
 	ide_remove_proc_entries(drive->proc, driver->proc_entries(drive));
-
-	mutex_lock(&ide_setting_mtx);
-	/*
-	 * ide_setting_mtx protects both the settings list and the use
-	 * of settings (we cannot take a setting out that is being used).
-	 */
-	drive->settings = NULL;
-	mutex_unlock(&ide_setting_mtx);
 }
 EXPORT_SYMBOL(ide_proc_unregister_driver);
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1659,57 +1659,6 @@ static void idetape_get_mode_sense_resul
 		tape->blk_size = 1024;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-#define ide_tape_devset_get(name, field) \
-static int get_##name(ide_drive_t *drive) \
-{ \
-	idetape_tape_t *tape = drive->driver_data; \
-	return tape->field; \
-}
-
-#define ide_tape_devset_set(name, field) \
-static int set_##name(ide_drive_t *drive, int arg) \
-{ \
-	idetape_tape_t *tape = drive->driver_data; \
-	tape->field = arg; \
-	return 0; \
-}
-
-#define ide_tape_devset_rw_field(_name, _field) \
-ide_tape_devset_get(_name, _field) \
-ide_tape_devset_set(_name, _field) \
-IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
-
-#define ide_tape_devset_r_field(_name, _field) \
-ide_tape_devset_get(_name, _field) \
-IDE_DEVSET(_name, 0, get_##_name, NULL)
-
-static int mulf_tdsc(ide_drive_t *drive)	{ return 1000; }
-static int divf_tdsc(ide_drive_t *drive)	{ return   HZ; }
-static int divf_buffer(ide_drive_t *drive)	{ return    2; }
-static int divf_buffer_size(ide_drive_t *drive)	{ return 1024; }
-
-ide_devset_rw_flag(dsc_overlap, IDE_DFLAG_DSC_OVERLAP);
-
-ide_tape_devset_rw_field(tdsc, best_dsc_rw_freq);
-
-ide_tape_devset_r_field(avg_speed, avg_speed);
-ide_tape_devset_r_field(speed, caps[14]);
-ide_tape_devset_r_field(buffer, caps[16]);
-ide_tape_devset_r_field(buffer_size, buffer_size);
-
-static const struct ide_proc_devset idetape_settings[] = {
-	__IDE_PROC_DEVSET(avg_speed,	0, 0xffff, NULL, NULL),
-	__IDE_PROC_DEVSET(buffer,	0, 0xffff, NULL, divf_buffer),
-	__IDE_PROC_DEVSET(buffer_size,	0, 0xffff, NULL, divf_buffer_size),
-	__IDE_PROC_DEVSET(dsc_overlap,	0,      1, NULL, NULL),
-	__IDE_PROC_DEVSET(speed,	0, 0xffff, NULL, NULL),
-	__IDE_PROC_DEVSET(tdsc,		IDETAPE_DSC_RW_MIN, IDETAPE_DSC_RW_MAX,
-					mulf_tdsc, divf_tdsc),
-	{ NULL },
-};
-#endif
-
 /*
  * The function below is called to:
  *
@@ -1849,11 +1798,6 @@ static ide_proc_entry_t *ide_tape_proc_e
 {
 	return idetape_proc;
 }
-
-static const struct ide_proc_devset *ide_tape_proc_devsets(ide_drive_t *drive)
-{
-	return idetape_settings;
-}
 #endif
 
 static int ide_tape_probe(ide_drive_t *);
@@ -1870,7 +1814,6 @@ static struct ide_driver idetape_driver
 	.do_request		= idetape_do_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_tape_proc_entries,
-	.proc_devsets		= ide_tape_proc_devsets,
 #endif
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -494,7 +494,6 @@ struct ide_drive_s {
 	u16			*id;	/* identification info */
 #ifdef CONFIG_IDE_PROC_FS
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
-	const struct ide_proc_devset *settings; /* /proc/ide/ drive settings */
 #endif
 	struct hwif_s		*hwif;	/* actually (ide_hwif_t *) */
 
@@ -907,36 +906,6 @@ ide_decl_devset(using_dma);
  * /proc/ide interface
  */
 
-#define ide_devset_rw_field(_name, _field) \
-ide_devset_get(_name, _field); \
-ide_devset_set(_name, _field); \
-IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
-
-#define ide_devset_rw_flag(_name, _field) \
-ide_devset_get_flag(_name, _field); \
-ide_devset_set_flag(_name, _field); \
-IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
-
-struct ide_proc_devset {
-	const char		*name;
-	const struct ide_devset	*setting;
-	int			min, max;
-	int			(*mulf)(ide_drive_t *);
-	int			(*divf)(ide_drive_t *);
-};
-
-#define __IDE_PROC_DEVSET(_name, _min, _max, _mulf, _divf) { \
-	.name = __stringify(_name), \
-	.setting = &ide_devset_##_name, \
-	.min = _min, \
-	.max = _max, \
-	.mulf = _mulf, \
-	.divf = _divf, \
-}
-
-#define IDE_PROC_DEVSET(_name, _min, _max) \
-__IDE_PROC_DEVSET(_name, _min, _max, NULL, NULL)
-
 typedef struct {
 	const char	*name;
 	mode_t		mode;
@@ -1043,7 +1012,6 @@ struct ide_driver {
 	void		(*shutdown)(ide_drive_t *);
 #ifdef CONFIG_IDE_PROC_FS
 	ide_proc_entry_t *		(*proc_entries)(ide_drive_t *);
-	const struct ide_proc_devset *	(*proc_devsets)(ide_drive_t *);
 #endif
 };
 
