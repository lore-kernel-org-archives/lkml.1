Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZEZFTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZEZFTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZEZFTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:19:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:21331 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZEZFTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lIqDH3UyP1HFqK2I65eU1lpsrBUy0WctW3bsN8WxSXkNe3iSlxd/E2hhkpFlmmf2ur
         vDTqrPk8mDzYQ3OiPED6EuhRG+I2kqxs+lLzGejj0zHUioewUDYvgflo3Vd4wcmZN/Mo
         ycIHkmnm21aY1vMtiQwTwmb2FBP32zcQFa5B0=
Subject: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to
	mount debugfs filesystem.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Content-Type: text/plain
Organization: Private
Date: Tue, 26 May 2009 14:19:23 +0900
Message-Id: <1243315163.14685.17.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 Hi all, 
   
 I want to hear your opinions about this proposal for consistency of
 mount directory to mount debugfs filesystem that need  by ftrace infrastructure.
 Um... I appended "RFC" word in the subject because this mail is my proposal just.  


commit 1766a83645706100b1829bb422f852ec757c6f4b
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Tue May 26 13:49:23 2009 +0900

    Fix terminology inconsistency of dir name to mount debugfs filesystem.
    
      Many developers use "/debug/" directory name to mount debugfs filesystem
      for ftrace according to ./Documentation/tracers/ftrace.txt file.
    
      But, two directory names(ex:/debug/, /debugfs/) is existed in kernel source
      like ftrace, DRM, Wireless, Network[sky2]files to mount debugfs filesystem.
      I think that we don't have to select either "/debug/" directory name or
      "/debugfs/" directory name for terminology consistency.
    
      debugfs means debug filesystem for debugging easy to use by greg kroah
      hartman. "/debug/" name is suitable as directory name of debugfs for
      tracing using ftrace like "/sys/" of sysfs(system filesystem).
      -debugfs related reference: http://lwn.net/Articles/115405/
    
      Fix inconsistency of directory name according to duplicated expression
      to mount debugfs.
    
         Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
---
 Documentation/DocBook/debugobjects.tmpl |    2 +-
 drivers/block/pktcdvd.c                 |    2 +-
 drivers/gpu/drm/drm_debugfs.c           |   12 ++++++------
 drivers/gpu/drm/drm_drv.c               |    2 +-
 drivers/gpu/drm/drm_stub.c              |    2 +-
 drivers/net/Kconfig                     |    4 ++--
 drivers/net/wimax/i2400m/i2400m.h       |    2 +-
 drivers/net/wireless/libertas/README    |   12 ++++++------
 include/linux/kernel.h                  |    2 +-
 kernel/trace/Kconfig                    |   10 +++++-----
 kernel/trace/trace.c                    |    2 +-
 11 files changed, 26 insertions(+), 26 deletions(-)


diff --git a/Documentation/DocBook/debugobjects.tmpl b/Documentation/DocBook/debugobjects.tmpl
index 7f5f218..9beb77a 100644
--- a/Documentation/DocBook/debugobjects.tmpl
+++ b/Documentation/DocBook/debugobjects.tmpl
@@ -106,7 +106,7 @@
       number of errors are printk'ed including a full stack trace.
     </para>
     <para>
-      The statistics are available via debugfs/debug_objects/stats.
+      The statistics are available via /debug/debug_objects/stats.
       They provide information about the number of warnings and the
       number of successful fixups along with information about the
       usage of the internal tracking objects and the state of the
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index dc7a8c3..36989b0 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -430,7 +430,7 @@ static void pkt_sysfs_cleanup(void)
 /********************************************************************
   entries in debugfs
 
-  /debugfs/pktcdvd[0-7]/
+  /debug/pktcdvd[0-7]/
 			info
 
  *******************************************************************/
diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index c77c6c6..04a2ccf 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -105,7 +105,7 @@ int drm_debugfs_create_files(struct drm_info_list *files, int count,
 		ent = debugfs_create_file(files[i].name, S_IFREG | S_IRUGO,
 					  root, tmp, &drm_debugfs_fops);
 		if (!ent) {
-			DRM_ERROR("Cannot create /debugfs/dri/%s/%s\n",
+			DRM_ERROR("Cannot create /debug/dri/%s/%s\n",
 				  name, files[i].name);
 			drm_free(tmp, sizeof(struct drm_info_node),
 				 _DRM_DRIVER);
@@ -133,9 +133,9 @@ EXPORT_SYMBOL(drm_debugfs_create_files);
  * \param minor device minor number
  * \param root DRI debugfs dir entry.
  *
- * Create the DRI debugfs root entry "/debugfs/dri", the device debugfs root entry
- * "/debugfs/dri/%minor%/", and each entry in debugfs_list as
- * "/debugfs/dri/%minor%/%name%".
+ * Create the DRI debugfs root entry "/debug/dri", the device debugfs root entry
+ * "/debug/dri/%minor%/", and each entry in debugfs_list as
+ * "/debug/dri/%minor%/%name%".
  */
 int drm_debugfs_init(struct drm_minor *minor, int minor_id,
 		     struct dentry *root)
@@ -148,7 +148,7 @@ int drm_debugfs_init(struct drm_minor *minor, int minor_id,
 	sprintf(name, "%d", minor_id);
 	minor->debugfs_root = debugfs_create_dir(name, root);
 	if (!minor->debugfs_root) {
-		DRM_ERROR("Cannot create /debugfs/dri/%s\n", name);
+		DRM_ERROR("Cannot create /debug/dri/%s\n", name);
 		return -1;
 	}
 
@@ -165,7 +165,7 @@ int drm_debugfs_init(struct drm_minor *minor, int minor_id,
 		ret = dev->driver->debugfs_init(minor);
 		if (ret) {
 			DRM_ERROR("DRM: Driver failed to initialize "
-				  "/debugfs/dri.\n");
+				  "/debug/dri.\n");
 			return ret;
 		}
 	}
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 019b7c5..5472e67 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -339,7 +339,7 @@ static int __init drm_core_init(void)
 
 	drm_debugfs_root = debugfs_create_dir("dri", NULL);
 	if (!drm_debugfs_root) {
-		DRM_ERROR("Cannot create /debugfs/dri\n");
+		DRM_ERROR("Cannot create /debug/dri\n");
 		ret = -1;
 		goto err_p3;
 	}
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index b9631e3..9488769 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -328,7 +328,7 @@ static int drm_get_minor(struct drm_device *dev, struct drm_minor **minor, int t
 #if defined(CONFIG_DEBUG_FS)
 	ret = drm_debugfs_init(new_minor, minor_id, drm_debugfs_root);
 	if (ret) {
-		DRM_ERROR("DRM: Failed to initialize /debugfs/dri.\n");
+		DRM_ERROR("DRM: Failed to initialize /debug/dri.\n");
 		goto err_g2;
 	}
 #endif
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 214a92d..898c269 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2200,7 +2200,7 @@ config SKGE_DEBUG
        depends on SKGE && DEBUG_FS
        help
 	 This option adds the ability to dump driver state for debugging.
-	 The file debugfs/skge/ethX displays the state of the internal
+	 The file /debug/skge/ethX displays the state of the internal
 	 transmit and receive rings.
 
 	 If unsure, say N.
@@ -2226,7 +2226,7 @@ config SKY2_DEBUG
        depends on SKY2 && DEBUG_FS
        help
 	 This option adds the ability to dump driver state for debugging.
-	 The file debugfs/sky2/ethX displays the state of the internal
+	 The file /debug/sky2/ethX displays the state of the internal
 	 transmit and receive rings.
 
 	 If unsure, say N.
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 3ae2df3..2366696 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -389,7 +389,7 @@ struct i2400m {
 	unsigned ready:1;		/* all probing steps done */
 	unsigned rx_reorder:1;		/* RX reorder is enabled */
 	u8 trace_msg_from_user;		/* echo rx msgs to 'trace' pipe */
-					/* typed u8 so debugfs/u8 can tweak */
+					/* typed u8 so /debug/u8 can tweak */
 	enum i2400m_system_state state;
 	wait_queue_head_t state_wq;	/* Woken up when on state updates */
 
diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
index d860fc3..11616ba 100644
--- a/drivers/net/wireless/libertas/README
+++ b/drivers/net/wireless/libertas/README
@@ -72,7 +72,7 @@ rdrf
 	location that is to be read.  This parameter must be specified in
 	hexadecimal (its possible to preceed preceding the number with a "0x").
 
-	Path: /debugfs/libertas_wireless/ethX/registers/
+	Path: /debug/libertas_wireless/ethX/registers/
 
 	Usage:
 		echo "0xa123" > rdmac ; cat rdmac
@@ -95,7 +95,7 @@ wrrf
 sleepparams
 	This command is used to set the sleepclock configurations
 
-	Path: /debugfs/libertas_wireless/ethX/
+	Path: /debug/libertas_wireless/ethX/
 
 	Usage:
 		cat sleepparams: reads the current sleepclock configuration
@@ -115,7 +115,7 @@ subscribed_events
 	The subscribed_events directory contains the interface for the
 	subscribed events API.
 
-	Path: /debugfs/libertas_wireless/ethX/subscribed_events/
+	Path: /debug/libertas_wireless/ethX/subscribed_events/
 
 	Each event is represented by a filename. Each filename consists of the
 	following three fields:
@@ -165,7 +165,7 @@ subscribed_events
 extscan
 	This command is used to do a specific scan.
 
-	Path: /debugfs/libertas_wireless/ethX/
+	Path: /debug/libertas_wireless/ethX/
 
 	Usage: echo "SSID" > extscan
 
@@ -179,7 +179,7 @@ getscantable
 	Display the current contents of the driver scan table (ie. get the
 	scan results).
 
-	Path: /debugfs/libertas_wireless/ethX/
+	Path: /debug/libertas_wireless/ethX/
 
 	Usage:
 		cat getscantable
@@ -188,7 +188,7 @@ setuserscan
 	Initiate a customized scan and retrieve the results
 
 
-	Path: /debugfs/libertas_wireless/ethX/
+	Path: /debug/libertas_wireless/ethX/
 
     Usage:
        echo "[ARGS]" > setuserscan
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..7ffa753 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -406,7 +406,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
  *
  * Use tracing_on/tracing_off when you want to quickly turn on or off
  * tracing. It simply enables or disables the recording of the trace events.
- * This also corresponds to the user space debugfs/tracing/tracing_on
+ * This also corresponds to the user space /debug/tracing/tracing_on
  * file, which gives a means for the kernel and userspace to interact.
  * Place a tracing_off() in the kernel where you want tracing to end.
  * From user space, examine the trace, and then echo 1 > tracing_on
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 417d198..7fcc3d6 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -120,7 +120,7 @@ config IRQSOFF_TRACER
 	  disabled by default and can be runtime (re-)started
 	  via:
 
-	      echo 0 > /debugfs/tracing/tracing_max_latency
+	      echo 0 > /debug/tracing/tracing_max_latency
 
 	  (Note that kernel size and overhead increases with this option
 	  enabled. This option and the preempt-off timing option can be
@@ -141,7 +141,7 @@ config PREEMPT_TRACER
 	  disabled by default and can be runtime (re-)started
 	  via:
 
-	      echo 0 > /debugfs/tracing/tracing_max_latency
+	      echo 0 > /debug/tracing/tracing_max_latency
 
 	  (Note that kernel size and overhead increases with this option
 	  enabled. This option and the irqs-off timing option can be
@@ -213,7 +213,7 @@ config TRACE_BRANCH_PROFILING
 	  This tracer profiles all the the likely and unlikely macros
 	  in the kernel. It will display the results in:
 
-	  /debugfs/tracing/profile_annotated_branch
+	  /debug/tracing/profile_annotated_branch
 
 	  Note: this will add a significant overhead, only turn this
 	  on if you need to profile the system's use of these macros.
@@ -228,7 +228,7 @@ config PROFILE_ALL_BRANCHES
 	  taken in the kernel is recorded whether it hit or miss.
 	  The results will be displayed in:
 
-	  /debugfs/tracing/profile_branch
+	  /debug/tracing/profile_branch
 
 	  This configuration, when enabled, will impose a great overhead
 	  on the system. This should only be enabled when the system
@@ -276,7 +276,7 @@ config STACK_TRACER
 	select KALLSYMS
 	help
 	  This special tracer records the maximum stack footprint of the
-	  kernel and displays it in debugfs/tracing/stack_trace.
+	  kernel and displays it in /debug/tracing/stack_trace.
 
 	  This tracer works by hooking into every function call that the
 	  kernel executes, and keeping a maximum stack depth value and
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cda81ec..b474e8c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -335,7 +335,7 @@ static raw_spinlock_t ftrace_max_lock =
 /*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
- * for later retrieval via /debugfs/tracing/latency_trace)
+ * for later retrieval via /debug/tracing/latency_trace)
  */
 static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (ELS - OS Group - S/W Lab - SAIT - SAMSUNG)
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://intomail.dnip.net/invain/me/
-----------------------------------------------

