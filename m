Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZKHM0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZKHM0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZKHM0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:26:07 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49547 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZKHMWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:36 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Jens Axboe <axboe@kernel.dk>,
       Clemens Ladisch <clemens@ladisch.de>, Corey Minyard <minyard@acm.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Matt Mackall <mpm@selenic.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, Neil Brown <neilb@suse.de>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: [PATCH 14/23] sysctl drivers: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:22:01 -0800
Message-Id: <1257682930-31401-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a wrapper around /proc/sys all of
the binary sysctl support elsewhere in the tree is
dead code.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Corey Minyard <minyard@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Neil Brown <neilb@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/cdrom/cdrom.c             |    8 ++----
 drivers/char/hpet.c               |    9 ++-----
 drivers/char/ipmi/ipmi_poweroff.c |    9 ++-----
 drivers/char/pty.c                |   10 +-------
 drivers/char/random.c             |   42 +------------------------------------
 drivers/char/rtc.c                |    9 ++-----
 drivers/macintosh/mac_hid.c       |   11 ++-------
 drivers/md/md.c                   |   10 ++------
 drivers/parport/procfs.c          |   11 ++-------
 drivers/scsi/scsi_sysctl.c        |    9 ++-----
 10 files changed, 27 insertions(+), 101 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 614da5b..1872b6d 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3594,30 +3594,28 @@ static ctl_table cdrom_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &cdrom_sysctl_handler
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table cdrom_cdrom_table[] = {
 	{
-		.ctl_name	= DEV_CDROM,
 		.procname	= "cdrom",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= cdrom_table,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 /* Make sure that /proc/sys/dev is there */
 static ctl_table cdrom_root_table[] = {
 	{
-		.ctl_name	= CTL_DEV,
 		.procname	= "dev",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= cdrom_cdrom_table,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 static struct ctl_table_header *cdrom_sysctl_header;
 
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 70a770a..a05a611 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -675,36 +675,33 @@ static int hpet_is_known(struct hpet_data *hdp)
 
 static ctl_table hpet_table[] = {
 	{
-	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "max-user-freq",
 	 .data = &hpet_max_freq,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
 	 .proc_handler = &proc_dointvec,
 	 },
-	{.ctl_name = 0}
+	{}
 };
 
 static ctl_table hpet_root[] = {
 	{
-	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "hpet",
 	 .maxlen = 0,
 	 .mode = 0555,
 	 .child = hpet_table,
 	 },
-	{.ctl_name = 0}
+	{}
 };
 
 static ctl_table dev_root[] = {
 	{
-	 .ctl_name = CTL_DEV,
 	 .procname = "dev",
 	 .maxlen = 0,
 	 .mode = 0555,
 	 .child = hpet_root,
 	 },
-	{.ctl_name = 0}
+	{}
 };
 
 static struct ctl_table_header *sysctl_header;
diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index 2e66b5f..aa39722 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -660,8 +660,7 @@ static struct ipmi_smi_watcher smi_watcher = {
 #include <linux/sysctl.h>
 
 static ctl_table ipmi_table[] = {
-	{ .ctl_name	= DEV_IPMI_POWEROFF_POWERCYCLE,
-	  .procname	= "poweroff_powercycle",
+	{ .procname	= "poweroff_powercycle",
 	  .data		= &poweroff_powercycle,
 	  .maxlen	= sizeof(poweroff_powercycle),
 	  .mode		= 0644,
@@ -670,16 +669,14 @@ static ctl_table ipmi_table[] = {
 };
 
 static ctl_table ipmi_dir_table[] = {
-	{ .ctl_name	= DEV_IPMI,
-	  .procname	= "ipmi",
+	{ .procname	= "ipmi",
 	  .mode		= 0555,
 	  .child	= ipmi_table },
 	{ }
 };
 
 static ctl_table ipmi_root_table[] = {
-	{ .ctl_name	= CTL_DEV,
-	  .procname	= "dev",
+	{ .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= ipmi_dir_table },
 	{ }
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 62f282e..d516e9c 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -431,30 +431,25 @@ static struct cdev ptmx_cdev;
 
 static struct ctl_table pty_table[] = {
 	{
-		.ctl_name	= PTY_MAX,
 		.procname	= "max",
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.data		= &pty_limit,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &pty_limit_min,
 		.extra2		= &pty_limit_max,
 	}, {
-		.ctl_name	= PTY_NR,
 		.procname	= "nr",
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.data		= &pty_count,
 		.proc_handler	= &proc_dointvec,
-	}, {
-		.ctl_name	= 0
-	}
+	}, 
+	{}
 };
 
 static struct ctl_table pty_kern_table[] = {
 	{
-		.ctl_name	= KERN_PTY,
 		.procname	= "pty",
 		.mode		= 0555,
 		.child		= pty_table,
@@ -464,7 +459,6 @@ static struct ctl_table pty_kern_table[] = {
 
 static struct ctl_table pty_root_table[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
 		.mode		= 0555,
 		.child		= pty_kern_table,
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 04b505e..bcf680f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1257,40 +1257,9 @@ static int proc_do_uuid(ctl_table *table, int write,
 	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
 }
 
-static int uuid_strategy(ctl_table *table,
-			 void __user *oldval, size_t __user *oldlenp,
-			 void __user *newval, size_t newlen)
-{
-	unsigned char tmp_uuid[16], *uuid;
-	unsigned int len;
-
-	if (!oldval || !oldlenp)
-		return 1;
-
-	uuid = table->data;
-	if (!uuid) {
-		uuid = tmp_uuid;
-		uuid[8] = 0;
-	}
-	if (uuid[8] == 0)
-		generate_random_uuid(uuid);
-
-	if (get_user(len, oldlenp))
-		return -EFAULT;
-	if (len) {
-		if (len > 16)
-			len = 16;
-		if (copy_to_user(oldval, uuid, len) ||
-		    put_user(len, oldlenp))
-			return -EFAULT;
-	}
-	return 1;
-}
-
 static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
 ctl_table random_table[] = {
 	{
-		.ctl_name 	= RANDOM_POOLSIZE,
 		.procname	= "poolsize",
 		.data		= &sysctl_poolsize,
 		.maxlen		= sizeof(int),
@@ -1298,7 +1267,6 @@ ctl_table random_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= RANDOM_ENTROPY_COUNT,
 		.procname	= "entropy_avail",
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
@@ -1306,45 +1274,37 @@ ctl_table random_table[] = {
 		.data		= &input_pool.entropy_count,
 	},
 	{
-		.ctl_name	= RANDOM_READ_THRESH,
 		.procname	= "read_wakeup_threshold",
 		.data		= &random_read_wakeup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &min_read_thresh,
 		.extra2		= &max_read_thresh,
 	},
 	{
-		.ctl_name	= RANDOM_WRITE_THRESH,
 		.procname	= "write_wakeup_threshold",
 		.data		= &random_write_wakeup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &min_write_thresh,
 		.extra2		= &max_write_thresh,
 	},
 	{
-		.ctl_name	= RANDOM_BOOT_ID,
 		.procname	= "boot_id",
 		.data		= &sysctl_bootid,
 		.maxlen		= 16,
 		.mode		= 0444,
 		.proc_handler	= &proc_do_uuid,
-		.strategy	= &uuid_strategy,
 	},
 	{
-		.ctl_name	= RANDOM_UUID,
 		.procname	= "uuid",
 		.maxlen		= 16,
 		.mode		= 0444,
 		.proc_handler	= &proc_do_uuid,
-		.strategy	= &uuid_strategy,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 #endif 	/* CONFIG_SYSCTL */
 
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index bc4ab3e..37bfe23 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -282,34 +282,31 @@ static irqreturn_t rtc_interrupt(int irq, void *dev_id)
  */
 static ctl_table rtc_table[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "max-user-freq",
 		.data		= &rtc_max_user_freq,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table rtc_root[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "rtc",
 		.mode		= 0555,
 		.child		= rtc_table,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table dev_root[] = {
 	{
-		.ctl_name	= CTL_DEV,
 		.procname	= "dev",
 		.mode		= 0555,
 		.child		= rtc_root,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table_header *sysctl_header;
diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index cc9f275..2dd29b4 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -27,7 +27,6 @@ static int mouse_last_keycode;
 /* file(s) in /proc/sys/dev/mac_hid */
 static ctl_table mac_hid_files[] = {
 	{
-		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON_EMULATION,
 		.procname	= "mouse_button_emulation",
 		.data		= &mouse_emulate_buttons,
 		.maxlen		= sizeof(int),
@@ -35,7 +34,6 @@ static ctl_table mac_hid_files[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON2_KEYCODE,
 		.procname	= "mouse_button2_keycode",
 		.data		= &mouse_button2_keycode,
 		.maxlen		= sizeof(int),
@@ -43,38 +41,35 @@ static ctl_table mac_hid_files[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON3_KEYCODE,
 		.procname	= "mouse_button3_keycode",
 		.data		= &mouse_button3_keycode,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 /* dir in /proc/sys/dev */
 static ctl_table mac_hid_dir[] = {
 	{
-		.ctl_name	= DEV_MAC_HID,
 		.procname	= "mac_hid",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= mac_hid_files,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 /* /proc/sys/dev itself, in case that is not there yet */
 static ctl_table mac_hid_root_dir[] = {
 	{
-		.ctl_name	= CTL_DEV,
 		.procname	= "dev",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= mac_hid_dir,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table_header *mac_hid_sysctl_header;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 10eb1fc..e9cad88 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -98,7 +98,6 @@ static struct ctl_table_header *raid_table_header;
 
 static ctl_table raid_table[] = {
 	{
-		.ctl_name	= DEV_RAID_SPEED_LIMIT_MIN,
 		.procname	= "speed_limit_min",
 		.data		= &sysctl_speed_limit_min,
 		.maxlen		= sizeof(int),
@@ -106,36 +105,33 @@ static ctl_table raid_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= DEV_RAID_SPEED_LIMIT_MAX,
 		.procname	= "speed_limit_max",
 		.data		= &sysctl_speed_limit_max,
 		.maxlen		= sizeof(int),
 		.mode		= S_IRUGO|S_IWUSR,
 		.proc_handler	= &proc_dointvec,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table raid_dir_table[] = {
 	{
-		.ctl_name	= DEV_RAID,
 		.procname	= "raid",
 		.maxlen		= 0,
 		.mode		= S_IRUGO|S_IXUGO,
 		.child		= raid_table,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table raid_root_table[] = {
 	{
-		.ctl_name	= CTL_DEV,
 		.procname	= "dev",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= raid_dir_table,
 	},
-	{ .ctl_name = 0 }
+	{  }
 };
 
 static const struct block_device_operations md_fops;
diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index 8eefe56..f808bdb 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -233,10 +233,10 @@ static int do_hardware_modes (ctl_table *table, int write,
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-#define PARPORT_PORT_DIR(CHILD) { .ctl_name = 0, .procname = NULL, .mode = 0555, .child = CHILD }
-#define PARPORT_PARPORT_DIR(CHILD) { .ctl_name = DEV_PARPORT, .procname = "parport", \
+#define PARPORT_PORT_DIR(CHILD) { .procname = NULL, .mode = 0555, .child = CHILD }
+#define PARPORT_PARPORT_DIR(CHILD) { .procname = "parport", \
                                      .mode = 0555, .child = CHILD }
-#define PARPORT_DEV_DIR(CHILD) { .ctl_name = CTL_DEV, .procname = "dev", .mode = 0555, .child = CHILD }
+#define PARPORT_DEV_DIR(CHILD) { .procname = "dev", .mode = 0555, .child = CHILD }
 #define PARPORT_DEVICES_ROOT_DIR  {  .procname = "devices", \
                                     .mode = 0555, .child = NULL }
 
@@ -393,7 +393,6 @@ parport_device_sysctl_template = {
 	},
 	{
 		{
-			.ctl_name	= 0,
 			.procname	= NULL,
 			.data		= NULL,
 			.maxlen		= 0,
@@ -455,7 +454,6 @@ parport_default_sysctl_table = {
 	},
 	{
 		{
-			.ctl_name	= DEV_PARPORT_DEFAULT,
 			.procname	= "default",
 			.mode		= 0555,
 			.child		= parport_default_sysctl_table.vars
@@ -495,7 +493,6 @@ int parport_proc_register(struct parport *port)
 		t->vars[6 + i].extra2 = &port->probe_info[i];
 
 	t->port_dir[0].procname = port->name;
-	t->port_dir[0].ctl_name = 0;
 
 	t->port_dir[0].child = t->vars;
 	t->parport_dir[0].child = t->port_dir;
@@ -534,11 +531,9 @@ int parport_device_proc_register(struct pardevice *device)
 	t->dev_dir[0].child = t->parport_dir;
 	t->parport_dir[0].child = t->port_dir;
 	t->port_dir[0].procname = port->name;
-	t->port_dir[0].ctl_name = 0;
 	t->port_dir[0].child = t->devices_root_dir;
 	t->devices_root_dir[0].child = t->device_dir;
 
-	t->device_dir[0].ctl_name = 0;
 	t->device_dir[0].procname = device->name;
 	t->device_dir[0].child = t->vars;
 	t->vars[0].data = &device->timeslice;
diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 63a30f5..42c31be 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -13,8 +13,7 @@
 
 
 static ctl_table scsi_table[] = {
-	{ .ctl_name	= DEV_SCSI_LOGGING_LEVEL,
-	  .procname	= "logging_level",
+	{ .procname	= "logging_level",
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
 	  .mode		= 0644,
@@ -23,16 +22,14 @@ static ctl_table scsi_table[] = {
 };
 
 static ctl_table scsi_dir_table[] = {
-	{ .ctl_name	= DEV_SCSI,
-	  .procname	= "scsi",
+	{ .procname	= "scsi",
 	  .mode		= 0555,
 	  .child	= scsi_table },
 	{ }
 };
 
 static ctl_table scsi_root_table[] = {
-	{ .ctl_name	= CTL_DEV,
-	  .procname	= "dev",
+	{ .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= scsi_dir_table },
 	{ }
-- 
1.6.5.2.143.g8cc62

