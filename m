Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbYCZWEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbYCZWEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbYCZWEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:04:39 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44240 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758201AbYCZWEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:04:32 -0400
Date: Wed, 26 Mar 2008 17:04:30 -0500
From: Dean Nelson <dcn@sgi.com>
To: jes@sgi.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: [Patch 4/5] run drivers/misc/xp through scripts/Lindent -v3
Message-ID: <20080326220430.GD31138@sgi.com>
References: <20080326215807.GF31340@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=Lindent
In-Reply-To: <20080326215807.GF31340@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ran patches through scripts/Lindent.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/xp/xp.h            |  115 ++++-------
 drivers/misc/xp/xp_main.c       |  109 ++++------
 drivers/misc/xp/xp_sn2.c        |   52 ++--
 drivers/misc/xp/xp_uv.c         |    7 
 drivers/misc/xp/xpc.h           |  366 ++++++++++++++---------------------
 drivers/misc/xp/xpc_channel.c   |  375 +++++++++++++-----------------------
 drivers/misc/xp/xpc_main.c      |  329 +++++++++++++------------------
 drivers/misc/xp/xpc_partition.c |  168 +++++-----------
 drivers/misc/xp/xpnet.c         |   95 +++------
 9 files changed, 658 insertions(+), 958 deletions(-)

Index: linux-2.6/drivers/misc/xp/xp.h
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xp.h	2008-03-26 10:41:15.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xp.h	2008-03-26 10:57:58.792002890 -0500
@@ -6,16 +6,13 @@
  * Copyright (C) 2004-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
-
 /*
  * External Cross Partition (XP) structures and defines.
  */
 
-
 #ifndef _DRIVERS_MISC_XP_XP_H
 #define _DRIVERS_MISC_XP_XP_H
 
-
 #include <linux/cache.h>
 #include <linux/hardirq.h>
 #include <linux/mutex.h>
@@ -35,14 +32,12 @@
 #error architecture is NOT supported
 #endif
 
-
 #ifdef USE_DBUG_ON
 #define DBUG_ON(condition)	BUG_ON(condition)
 #else
 #define DBUG_ON(condition)
 #endif
 
-
 #ifndef is_shub1
 #define is_shub1()	0
 #endif
@@ -59,7 +54,6 @@
 #define is_uv()		0
 #endif
 
-
 /*
  * Define the maximum number of logically defined partitions the system
  * can support. It is constrained by the maximum number of hardware
@@ -78,10 +72,9 @@
 #error  XP_NPARTITIONS exceeds MAXIMUM possible.
 #endif
 
-#define XP_MIN_PARTID		1			/* inclusive */
+#define XP_MIN_PARTID		1	/* inclusive */
 #define XP_MAX_PARTID		(XP_NPARTITIONS - 1)	/* inclusive */
 
-
 /*
  * XPC establishes channel connections between the local partition and any
  * other partition that is currently up. Over these channels, kernel-level
@@ -107,7 +100,6 @@
 #error	XPC_NCHANNELS exceeds MAXIMUM possible.
 #endif
 
-
 /*
  * The format of an XPC message is as follows:
  *
@@ -145,12 +137,10 @@ struct xpc_msg {
 	u64 payload;		/* user defined portion of message */
 };
 
-
 #define XPC_MSG_PAYLOAD_OFFSET	(u64) (&((struct xpc_msg *)0)->payload)
 #define XPC_MSG_SIZE(_payload_size) \
 		L1_CACHE_ALIGN(XPC_MSG_PAYLOAD_OFFSET + (_payload_size))
 
-
 /*
  * Define the return values and values passed to user's callout functions.
  * (It is important to add new value codes at the end just preceding
@@ -237,7 +227,6 @@ enum xp_retval {
 	xpUnknownReason		/* 56: unknown reason (must be last in list) */
 };
 
-
 /* the following are valid xp_set_amo() ops */
 #define XP_AMO_OR	1	/* set variable to (variable | operand) */
 #define XP_AMO_AND	2	/* set variable to (variable & operand) */
@@ -252,7 +241,6 @@ enum xp_retval {
 #define XP_MEMPROT_ALLOW_CPU_MEM	2
 #define XP_MEMPROT_ALLOW_ALL		3	/* Shub 1.1 only */
 
-
 /*
  * Define the callout function types used by XPC to update the user on
  * connection activity and state changes (via the user function registered by
@@ -357,12 +345,11 @@ enum xp_retval {
  * =====================+================================+=====================
  */
 
-typedef void (*xpc_channel_func)(enum xp_retval reason, short partid,
-		int ch_number, void *data, void *key);
-
-typedef void (*xpc_notify_func)(enum xp_retval reason, short partid,
-		int ch_number, void *key);
+typedef void (*xpc_channel_func) (enum xp_retval reason, short partid,
+				  int ch_number, void *data, void *key);
 
+typedef void (*xpc_notify_func) (enum xp_retval reason, short partid,
+				 int ch_number, void *key);
 
 /*
  * The following is a registration entry. There is a global array of these,
@@ -380,50 +367,45 @@ typedef void (*xpc_notify_func)(enum xp_
  */
 struct xpc_registration {
 	struct mutex mutex;
-	xpc_channel_func func;		/* function to call */
-	void *key;			/* pointer to user's key */
-	u16 nentries;			/* #of msg entries in local msg queue */
-	u16 msg_size;			/* message queue's message size */
-	u32 assigned_limit;		/* limit on #of assigned kthreads */
-	u32 idle_limit;			/* limit on #of idle kthreads */
+	xpc_channel_func func;	/* function to call */
+	void *key;		/* pointer to user's key */
+	u16 nentries;		/* #of msg entries in local msg queue */
+	u16 msg_size;		/* message queue's message size */
+	u32 assigned_limit;	/* limit on #of assigned kthreads */
+	u32 idle_limit;		/* limit on #of idle kthreads */
 } ____cacheline_aligned;
 
-
 #define XPC_CHANNEL_REGISTERED(_c)	(xpc_registrations[_c].func != NULL)
 
-
 /* the following are valid xpc_allocate() flags */
-#define XPC_WAIT	0		/* wait flag */
-#define XPC_NOWAIT	1		/* no wait flag */
-
+#define XPC_WAIT	0	/* wait flag */
+#define XPC_NOWAIT	1	/* no wait flag */
 
 struct xpc_interface {
-	void (*connect)(int);
-	void (*disconnect)(int);
-	enum xp_retval (*allocate)(short, int, u32, void **);
-	enum xp_retval (*send)(short, int, void *);
-	enum xp_retval (*send_notify)(short, int, void *,
-						xpc_notify_func, void *);
-	void (*received)(short, int, void *);
-	enum xp_retval (*partid_to_nasids)(short, void *);
+	void (*connect) (int);
+	void (*disconnect) (int);
+	enum xp_retval (*allocate) (short, int, u32, void **);
+	enum xp_retval (*send) (short, int, void *);
+	enum xp_retval (*send_notify) (short, int, void *,
+				       xpc_notify_func, void *);
+	void (*received) (short, int, void *);
+	enum xp_retval (*partid_to_nasids) (short, void *);
 };
 
-
 extern struct xpc_interface xpc_interface;
 
 extern void xpc_set_interface(void (*)(int),
-		void (*)(int),
-		enum xp_retval (*)(short, int, u32, void **),
-		enum xp_retval (*)(short, int, void *),
-		enum xp_retval (*)(short, int, void *, xpc_notify_func,
-								void *),
-		void (*)(short, int, void *),
-		enum xp_retval (*)(short, void *));
+			      void (*)(int),
+			      enum xp_retval (*)(short, int, u32, void **),
+			      enum xp_retval (*)(short, int, void *),
+			      enum xp_retval (*)(short, int, void *,
+						 xpc_notify_func, void *),
+			      void (*)(short, int, void *),
+			      enum xp_retval (*)(short, void *));
 extern void xpc_clear_interface(void);
 
-
 extern enum xp_retval xpc_connect(int, xpc_channel_func, void *, u16,
-						u16, u32, u32);
+				  u16, u32, u32);
 extern void xpc_disconnect(int);
 
 static inline enum xp_retval
@@ -440,7 +422,7 @@ xpc_send(short partid, int ch_number, vo
 
 static inline enum xp_retval
 xpc_send_notify(short partid, int ch_number, void *payload,
-			xpc_notify_func func, void *key)
+		xpc_notify_func func, void *key)
 {
 	return xpc_interface.send_notify(partid, ch_number, payload, func, key);
 }
@@ -460,31 +442,36 @@ xpc_partid_to_nasids(short partid, void 
 extern short xp_partition_id;
 extern u8 xp_region_size;
 extern unsigned long xp_rtc_cycles_per_second;
-extern enum xp_retval (*xp_remote_memcpy)(void *, const void *, size_t);
-extern enum xp_retval (*xp_register_remote_amos)(u64, size_t);
-extern enum xp_retval (*xp_unregister_remote_amos)(u64, size_t);
+extern enum xp_retval (*xp_remote_memcpy) (void *, const void *, size_t);
+extern enum xp_retval (*xp_register_remote_amos) (u64, size_t);
+extern enum xp_retval (*xp_unregister_remote_amos) (u64, size_t);
 extern int xp_sizeof_nasid_mask;
 extern int xp_sizeof_amo;
-extern u64 *(*xp_alloc_amos)(int);
-extern void (*xp_free_amos)(u64 *, int);
-extern enum xp_retval (*xp_set_amo)(u64 *, int, u64, int);
-extern enum xp_retval (*xp_set_amo_with_interrupt)(u64 *, int, u64, int, int,
+extern u64 *(*xp_alloc_amos) (int);
+extern void (*xp_free_amos) (u64 *, int);
+extern enum xp_retval (*xp_set_amo) (u64 *, int, u64, int);
+extern enum xp_retval (*xp_set_amo_with_interrupt) (u64 *, int, u64, int, int,
 						    int, int);
-extern enum xp_retval (*xp_get_amo)(u64 *, int, u64 *);
-extern enum xp_retval (*xp_get_partition_rsvd_page_pa)(u64, u64 *, u64 *,
+extern enum xp_retval (*xp_get_amo) (u64 *, int, u64 *);
+extern enum xp_retval (*xp_get_partition_rsvd_page_pa) (u64, u64 *, u64 *,
 							size_t *);
-extern enum xp_retval (*xp_change_memprotect)(u64, size_t, int, u64 *);
-extern void (*xp_change_memprotect_shub_wars_1_1)(int);
-extern void (*xp_allow_IPI_ops)(void);
-extern void (*xp_disallow_IPI_ops)(void);
+extern enum xp_retval (*xp_change_memprotect) (u64, size_t, int, u64 *);
+extern void (*xp_change_memprotect_shub_wars_1_1) (int);
+extern void (*xp_allow_IPI_ops) (void);
+extern void (*xp_disallow_IPI_ops) (void);
 
-extern int (*xp_cpu_to_nasid)(int);
-extern int (*xp_node_to_nasid)(int);
+extern int (*xp_cpu_to_nasid) (int);
+extern int (*xp_node_to_nasid) (int);
 
 extern u64 xp_nofault_PIOR_target;
 extern int xp_nofault_PIOR(void *);
 extern int xp_error_PIOR(void);
 
+extern struct device *xp;
+extern enum xp_retval xp_init_sn2(void);
+extern enum xp_retval xp_init_uv(void);
+extern void xp_exit_sn2(void);
+extern void xp_exit_uv(void);
 
 static inline int
 xp_partid_mask_words(int npartitions)
@@ -498,6 +485,4 @@ xp_nasid_mask_words(void)
 	return DIV_ROUND_UP(xp_sizeof_nasid_mask, BYTES_PER_WORD);
 }
 
-
 #endif /* _DRIVERS_MISC_XP_XP_H */
-
Index: linux-2.6/drivers/misc/xp/xp_main.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xp_main.c	2008-03-26 10:41:24.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xp_main.c	2008-03-26 10:57:58.820006332 -0500
@@ -6,7 +6,6 @@
  * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
-
 /*
  * Cross Partition (XP) base.
  *
@@ -15,7 +14,6 @@
  *
  */
 
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -28,7 +26,7 @@ struct device_driver xp_dbg_name = {
 };
 
 struct device xp_dbg_subname = {
-	.bus_id = {0},			/* set to "" */
+	.bus_id = {0},		/* set to "" */
 	.driver = &xp_dbg_name
 };
 
@@ -43,66 +41,68 @@ short xp_partition_id;
 u8 xp_region_size;
 unsigned long xp_rtc_cycles_per_second;
 
-enum xp_retval (*xp_remote_memcpy)(void *dst, const void *src, size_t len);
+enum xp_retval (*xp_remote_memcpy) (void *dst, const void *src, size_t len);
 
-enum xp_retval (*xp_register_remote_amos)(u64 paddr, size_t len);
-enum xp_retval (*xp_unregister_remote_amos)(u64 paddr, size_t len);
+enum xp_retval (*xp_register_remote_amos) (u64 paddr, size_t len);
+enum xp_retval (*xp_unregister_remote_amos) (u64 paddr, size_t len);
 
 int xp_sizeof_nasid_mask;
 int xp_sizeof_amo;
 
-u64 *(*xp_alloc_amos)(int n_amos);
-void (*xp_free_amos)(u64 *amos_page, int n_amos);
+u64 *(*xp_alloc_amos) (int n_amos);
+void (*xp_free_amos) (u64 *amos_page, int n_amos);
 
-enum xp_retval (*xp_set_amo)(u64 *amo_va, int op, u64 operand, int remote);
-enum xp_retval (*xp_set_amo_with_interrupt)(u64 *amo_va, int op, u64 operand,
+enum xp_retval (*xp_set_amo) (u64 *amo_va, int op, u64 operand, int remote);
+enum xp_retval (*xp_set_amo_with_interrupt) (u64 *amo_va, int op, u64 operand,
 					     int remote, int nasid,
 					     int phys_cpuid, int vector);
 
-enum xp_retval (*xp_get_amo)(u64 *amo_va, int op, u64 *amo_value_addr);
+enum xp_retval (*xp_get_amo) (u64 *amo_va, int op, u64 *amo_value_addr);
 
-enum xp_retval (*xp_get_partition_rsvd_page_pa)(u64 buf, u64 *cookie,
+enum xp_retval (*xp_get_partition_rsvd_page_pa) (u64 buf, u64 *cookie,
 						 u64 *paddr, size_t *len);
 
-enum xp_retval (*xp_change_memprotect)(u64 paddr, size_t len, int request,
+enum xp_retval (*xp_change_memprotect) (u64 paddr, size_t len, int request,
 					u64 *nasid_array);
-void (*xp_change_memprotect_shub_wars_1_1)(int request);
-void (*xp_allow_IPI_ops)(void);
-void (*xp_disallow_IPI_ops)(void);
-
-int (*xp_cpu_to_nasid)(int cpuid);
-int (*xp_node_to_nasid)(int nid);
+void (*xp_change_memprotect_shub_wars_1_1) (int request);
+void (*xp_allow_IPI_ops) (void);
+void (*xp_disallow_IPI_ops) (void);
 
+int (*xp_cpu_to_nasid) (int cpuid);
+int (*xp_node_to_nasid) (int nid);
 
 /*
  * Initialize the XPC interface to indicate that XPC isn't loaded.
  */
-static enum xp_retval xpc_notloaded(void) { return xpNotLoaded; }
+static enum xp_retval
+xpc_notloaded(void)
+{
+	return xpNotLoaded;
+}
 
 struct xpc_interface xpc_interface = {
-	(void (*)(int)) xpc_notloaded,
-	(void (*)(int)) xpc_notloaded,
-	(enum xp_retval (*)(short, int, u32, void **)) xpc_notloaded,
-	(enum xp_retval (*)(short, int, void *)) xpc_notloaded,
-	(enum xp_retval (*)(short, int, void *, xpc_notify_func, void *))
-							xpc_notloaded,
-	(void (*)(short, int, void *)) xpc_notloaded,
-	(enum xp_retval (*)(short, void *)) xpc_notloaded
+	(void (*)(int))xpc_notloaded,
+	(void (*)(int))xpc_notloaded,
+	(enum xp_retval(*)(short, int, u32, void **))xpc_notloaded,
+	(enum xp_retval(*)(short, int, void *))xpc_notloaded,
+	(enum xp_retval(*)(short, int, void *, xpc_notify_func, void *))
+	    xpc_notloaded,
+	(void (*)(short, int, void *))xpc_notloaded,
+	(enum xp_retval(*)(short, void *))xpc_notloaded
 };
 
-
 /*
  * XPC calls this when it (the XPC module) has been loaded.
  */
 void
-xpc_set_interface(void (*connect)(int),
-		void (*disconnect)(int),
-		enum xp_retval (*allocate)(short, int, u32, void **),
-		enum xp_retval (*send)(short, int, void *),
-		enum xp_retval (*send_notify)(short, int, void *,
-						xpc_notify_func, void *),
-		void (*received)(short, int, void *),
-		enum xp_retval (*partid_to_nasids)(short, void *))
+xpc_set_interface(void (*connect) (int),
+		  void (*disconnect) (int),
+		  enum xp_retval (*allocate) (short, int, u32, void **),
+		  enum xp_retval (*send) (short, int, void *),
+		  enum xp_retval (*send_notify) (short, int, void *,
+						 xpc_notify_func, void *),
+		  void (*received) (short, int, void *),
+		  enum xp_retval (*partid_to_nasids) (short, void *))
 {
 	xpc_interface.connect = connect;
 	xpc_interface.disconnect = disconnect;
@@ -113,35 +113,33 @@ xpc_set_interface(void (*connect)(int),
 	xpc_interface.partid_to_nasids = partid_to_nasids;
 }
 
-
 /*
  * XPC calls this when it (the XPC module) is being unloaded.
  */
 void
 xpc_clear_interface(void)
 {
-	xpc_interface.connect = (void (*)(int)) xpc_notloaded;
-	xpc_interface.disconnect = (void (*)(int)) xpc_notloaded;
-	xpc_interface.allocate = (enum xp_retval (*)(short, int, u32,
-					void **)) xpc_notloaded;
-	xpc_interface.send = (enum xp_retval (*)(short, int, void *))
-					xpc_notloaded;
-	xpc_interface.send_notify = (enum xp_retval (*)(short, int, void *,
-				    xpc_notify_func, void *)) xpc_notloaded;
+	xpc_interface.connect = (void (*)(int))xpc_notloaded;
+	xpc_interface.disconnect = (void (*)(int))xpc_notloaded;
+	xpc_interface.allocate = (enum xp_retval(*)(short, int, u32,
+						    void **))xpc_notloaded;
+	xpc_interface.send = (enum xp_retval(*)(short, int, void *))
+	    xpc_notloaded;
+	xpc_interface.send_notify = (enum xp_retval(*)(short, int, void *,
+						       xpc_notify_func,
+						       void *))xpc_notloaded;
 	xpc_interface.received = (void (*)(short, int, void *))
-					xpc_notloaded;
-	xpc_interface.partid_to_nasids = (enum xp_retval (*)(short, void *))
-					xpc_notloaded;
+	    xpc_notloaded;
+	xpc_interface.partid_to_nasids = (enum xp_retval(*)(short, void *))
+	    xpc_notloaded;
 }
 
-
 /*
  * xpc_registrations[] keeps track of xpc_connect()'s done by the kernel-level
  * users of XPC.
  */
 struct xpc_registration xpc_registrations[XPC_NCHANNELS];
 
-
 /*
  * Register for automatic establishment of a channel connection whenever
  * a partition comes up.
@@ -168,11 +166,10 @@ struct xpc_registration xpc_registration
  */
 enum xp_retval
 xpc_connect(int ch_number, xpc_channel_func func, void *key, u16 payload_size,
-		u16 nentries, u32 assigned_limit, u32 idle_limit)
+	    u16 nentries, u32 assigned_limit, u32 idle_limit)
 {
 	struct xpc_registration *registration;
 
-
 	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
 	DBUG_ON(payload_size == 0 || nentries == 0);
 	DBUG_ON(func == NULL);
@@ -205,7 +202,6 @@ xpc_connect(int ch_number, xpc_channel_f
 	return xpSuccess;
 }
 
-
 /*
  * Remove the registration for automatic connection of the specified channel
  * when a partition comes up.
@@ -224,7 +220,6 @@ xpc_disconnect(int ch_number)
 {
 	struct xpc_registration *registration;
 
-
 	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
 
 	registration = &xpc_registrations[ch_number];
@@ -284,6 +279,7 @@ xp_init(void)
 
 	return 0;
 }
+
 module_init(xp_init);
 
 extern void xp_exit_sn2(void);
@@ -297,8 +293,8 @@ xp_exit(void)
 	else if (is_uv())
 		xp_exit_uv();
 }
-module_exit(xp_exit);
 
+module_exit(xp_exit);
 
 MODULE_AUTHOR("Silicon Graphics, Inc.");
 MODULE_DESCRIPTION("Cross Partition (XP) base");
@@ -330,4 +326,3 @@ EXPORT_SYMBOL(xpc_clear_interface);
 EXPORT_SYMBOL(xpc_set_interface);
 EXPORT_SYMBOL(xpc_connect);
 EXPORT_SYMBOL(xpc_disconnect);
-
Index: linux-2.6/drivers/misc/xp/xp_sn2.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xp_sn2.c	2008-03-26 10:42:14.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xp_sn2.c	2008-03-26 10:57:58.844009283 -0500
@@ -67,7 +67,7 @@ xp_unregister_nofault_code_sn2(void)
 
 	/* unregister the PIO read nofault code region */
 	(void)sn_register_nofault_code(func_addr, err_func_addr,
-					err_func_addr, 1, 0);
+				       err_func_addr, 1, 0);
 }
 
 /*
@@ -155,15 +155,14 @@ xp_free_amos_sn2(u64 *amos_page, int n_a
 {
 	int n_pages = DIV_ROUND_UP(n_amos * xp_sizeof_amo, PAGE_SIZE);
 
-	uncached_free_page(__IA64_UNCACHED_OFFSET | TO_PHYS((u64) amos_page),
+	uncached_free_page(__IA64_UNCACHED_OFFSET | TO_PHYS((u64)amos_page),
 			   n_pages);
 }
 
-
 static enum xp_retval
 xp_set_amo_sn2(u64 *amo_va, int op, u64 operand, int remote)
 {
-	unsigned long irq_flags = irq_flags; /* eliminate compiler warning */
+	unsigned long irq_flags = irq_flags;	/* eliminate compiler warning */
 	int ret = xpSuccess;
 	/* >>> eliminate remote arg and xp_nofault_PIOR() call */
 
@@ -188,7 +187,8 @@ xp_set_amo_sn2(u64 *amo_va, int op, u64 
 		 * it until the heartbeat times out.
 		 */
 		if (xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(amo_va),
-				    xp_nofault_PIOR_target)) != 0)
+							   xp_nofault_PIOR_target))
+		    != 0)
 			ret = xpPioReadError;
 
 		local_irq_restore(irq_flags);
@@ -201,7 +201,7 @@ static enum xp_retval
 xp_set_amo_with_interrupt_sn2(u64 *amo_va, int op, u64 operand, int remote,
 			      int nasid, int phys_cpuid, int vector)
 {
-	unsigned long irq_flags = irq_flags; /* eliminate compiler warning */
+	unsigned long irq_flags = irq_flags;	/* eliminate compiler warning */
 	int ret = xpSuccess;
 
 	if (op == XP_AMO_AND)
@@ -226,7 +226,8 @@ xp_set_amo_with_interrupt_sn2(u64 *amo_v
 		 * it until the heartbeat times out.
 		 */
 		if (xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(amo_va),
-				    xp_nofault_PIOR_target)) != 0)
+							   xp_nofault_PIOR_target))
+		    != 0)
 			ret = xpPioReadError;
 
 		local_irq_restore(irq_flags);
@@ -321,22 +322,28 @@ xp_change_memprotect_shub_wars_1_1_sn2(i
 			nasid = cnodeid_to_nasid(node);
 			/* save current protection values */
 			xpc_prot_vec[node] =
-				(u64)HUB_L((u64 *)GLOBAL_MMR_ADDR(nasid,
-					   SH1_MD_DQLP_MMR_DIR_PRIVEC0));
+			    (u64)HUB_L((u64 *)GLOBAL_MMR_ADDR(nasid,
+							      SH1_MD_DQLP_MMR_DIR_PRIVEC0));
 			/* open up everything */
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
-			      SH1_MD_DQLP_MMR_DIR_PRIVEC0), -1UL);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
-			      SH1_MD_DQRP_MMR_DIR_PRIVEC0), -1UL);
+						     SH1_MD_DQLP_MMR_DIR_PRIVEC0),
+			      -1UL);
+			HUB_S((u64 *)
+			      GLOBAL_MMR_ADDR(nasid,
+					      SH1_MD_DQRP_MMR_DIR_PRIVEC0),
+			      -1UL);
 		}
 	} else if (request == XP_MEMPROT_DISALLOW_ALL) {
 		for_each_online_node(node) {
 			nasid = cnodeid_to_nasid(node);
 			/* restore original protection values */
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
-			      SH1_MD_DQLP_MMR_DIR_PRIVEC0), xpc_prot_vec[node]);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
-			      SH1_MD_DQRP_MMR_DIR_PRIVEC0), xpc_prot_vec[node]);
+						     SH1_MD_DQLP_MMR_DIR_PRIVEC0),
+			      xpc_prot_vec[node]);
+			HUB_S((u64 *)
+			      GLOBAL_MMR_ADDR(nasid,
+					      SH1_MD_DQRP_MMR_DIR_PRIVEC0),
+			      xpc_prot_vec[node]);
 		}
 	} else
 		BUG();
@@ -361,13 +368,13 @@ xp_allow_IPI_ops_sn2(void)
 	/*  >>> The following should get moved into SAL. */
 	if (is_shub2()) {
 		xpc_sh2_IPI_access0 =
-			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
 		xpc_sh2_IPI_access1 =
-			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
 		xpc_sh2_IPI_access2 =
-			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
 		xpc_sh2_IPI_access3 =
-			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
 
 		for_each_online_node(node) {
 			nasid = cnodeid_to_nasid(node);
@@ -382,7 +389,7 @@ xp_allow_IPI_ops_sn2(void)
 		}
 	} else {
 		xpc_sh1_IPI_access =
-			(u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
+		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
 
 		for_each_online_node(node) {
 			nasid = cnodeid_to_nasid(node);
@@ -455,7 +462,7 @@ xp_init_sn2(void)
 	 * reflect its existence.
 	 */
 	BUG_ON(offsetof(AMO_t, variable) != 0);
-	BUG_ON(sizeof(((AMO_t *)NULL)->variable) != sizeof(u64));
+	BUG_ON(sizeof(((AMO_t *) NULL)->variable) != sizeof(u64));
 	xp_sizeof_amo = sizeof(AMO_t);
 	xp_alloc_amos = xp_alloc_amos_sn2;
 	xp_free_amos = xp_free_amos_sn2;
@@ -467,7 +474,7 @@ xp_init_sn2(void)
 
 	xp_change_memprotect = xp_change_memprotect_sn2;
 	xp_change_memprotect_shub_wars_1_1 =
-				xp_change_memprotect_shub_wars_1_1_sn2;
+	    xp_change_memprotect_shub_wars_1_1_sn2;
 	xp_allow_IPI_ops = xp_allow_IPI_ops_sn2;
 	xp_disallow_IPI_ops = xp_disallow_IPI_ops_sn2;
 
@@ -484,4 +491,3 @@ xp_exit_sn2(void)
 
 	xp_unregister_nofault_code_sn2();
 }
-
Index: linux-2.6/drivers/misc/xp/xp_uv.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xp_uv.c	2008-03-26 10:40:10.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xp_uv.c	2008-03-26 10:57:58.868012234 -0500
@@ -154,8 +154,8 @@ xp_init_uv(void)
 {
 	BUG_ON(!is_uv());
 
-	xp_partition_id = 0;		/* >>> not correct value */
-	xp_region_size = 0;		/* >>> not correct value */
+	xp_partition_id = 0;	/* >>> not correct value */
+	xp_region_size = 0;	/* >>> not correct value */
 	xp_rtc_cycles_per_second = 0;	/* >>> not correct value */
 
 	xp_remote_memcpy = xp_remote_memcpy_uv;
@@ -174,7 +174,7 @@ xp_init_uv(void)
 
 	xp_change_memprotect = xp_change_memprotect_uv;
 	xp_change_memprotect_shub_wars_1_1 =
-				xp_change_memprotect_shub_wars_1_1_uv;
+	    xp_change_memprotect_shub_wars_1_1_uv;
 	xp_allow_IPI_ops = xp_allow_IPI_ops_uv;
 	xp_disallow_IPI_ops = xp_disallow_IPI_ops_uv;
 
@@ -191,4 +191,3 @@ xp_exit_uv(void)
 
 	xp_unregister_nofault_code_uv();
 }
-
Index: linux-2.6/drivers/misc/xp/xpc.h
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpc.h	2008-03-26 10:41:38.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xpc.h	2008-03-26 10:57:58.884014201 -0500
@@ -6,7 +6,6 @@
  * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
-
 /*
  * Cross Partition Communication (XPC) structures and macros.
  */
@@ -14,7 +13,6 @@
 #ifndef _DRIVERS_MISC_XP_XPC_H
 #define _DRIVERS_MISC_XP_XPC_H
 
-
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
 #include <linux/device.h>
@@ -32,7 +30,6 @@
 #endif
 #include "xp.h"
 
-
 /*
  * XPC Version numbers consist of a major and minor number. XPC can always
  * talk to versions with same major #, and never talk to versions with a
@@ -42,7 +39,6 @@
 #define XPC_VERSION_MAJOR(_v)		((_v) >> 4)
 #define XPC_VERSION_MINOR(_v)		((_v) & 0xf)
 
-
 /*
  * The next macros define word or bit representations for given
  * C-brick nasid in either the SAL provided bit array representing
@@ -66,7 +62,6 @@
 /* define the process name of the discovery thread */
 #define XPC_DISCOVERY_THREAD_NAME	"xpc_discovery"
 
-
 /*
  * the reserved page
  *
@@ -120,7 +115,7 @@ struct xpc_rsvd_page {
 	u64 SAL_nasids_size;	/* SAL: size of each nasid mask in bytes */
 };
 
-#define XPC_RP_VERSION _XPC_VERSION(2,0) /* version 2.0 of the reserved page */
+#define XPC_RP_VERSION _XPC_VERSION(2,0)	/* version 2.0 of the reserved page */
 
 #define XPC_SUPPORTS_RP_STAMP(_version) \
 			(_version >= _XPC_VERSION(1,1))
@@ -137,14 +132,12 @@ xpc_compare_stamps(struct timespec *stam
 {
 	int ret;
 
-
 	if ((ret = stamp1->tv_sec - stamp2->tv_sec) == 0) {
 		ret = stamp1->tv_nsec - stamp2->tv_nsec;
 	}
 	return ret;
 }
 
-
 /*
  * Define the structures by which XPC variables can be exported to other
  * partitions. (There are two: struct xpc_vars and struct xpc_vars_part)
@@ -173,12 +166,11 @@ struct xpc_vars {
 	u64 heartbeating_to_mask[BITS_TO_LONGS(XP_MAX_NPARTITIONS)];
 };
 
-#define XPC_V_VERSION _XPC_VERSION(4,0) /* version 4.0 of the cross vars */
+#define XPC_V_VERSION _XPC_VERSION(4,0)	/* version 4.0 of the cross vars */
 
 #define XPC_SUPPORTS_DISENGAGE_REQUEST(_version) \
 			(_version >= _XPC_VERSION(3,1))
 
-
 static inline int
 xpc_hb_allowed(short partid, struct xpc_vars *vars)
 {
@@ -214,7 +206,6 @@ xpc_disallow_all_hbs(struct xpc_vars *va
 		vars->heartbeating_to_mask[i] = 0;
 }
 
-
 /*
  * The AMOs page(s) consists of a number of AMO variables which are divided into
  * four groups, The first group consists of one AMO per partition, each of which
@@ -254,7 +245,7 @@ static inline int
 xpc_disengage_request_amos(int npartitions)
 {
 	return xpc_engaged_partitions_amos(npartitions) +
-					xp_partid_mask_words(npartitions);
+	    xp_partid_mask_words(npartitions);
 }
 
 /* get total number of AMOs */
@@ -262,10 +253,9 @@ static inline int
 xpc_number_of_amos(int npartitions)
 {
 	return xpc_disengage_request_amos(npartitions) +
-					xp_partid_mask_words(npartitions);
+	    xp_partid_mask_words(npartitions);
 }
 
-
 /*
  * The following structure describes the per partition specific variables.
  *
@@ -300,9 +290,8 @@ struct xpc_vars_part {
  * MAGIC2 indicates that this partition has pulled the remote partititions
  * per partition variables that pertain to this partition.
  */
-#define XPC_VP_MAGIC1	0x0053524156435058L  /* 'XPCVARS\0'L (little endian) */
-#define XPC_VP_MAGIC2	0x0073726176435058L  /* 'XPCvars\0'L (little endian) */
-
+#define XPC_VP_MAGIC1	0x0053524156435058L	/* 'XPCVARS\0'L (little endian) */
+#define XPC_VP_MAGIC2	0x0073726176435058L	/* 'XPCvars\0'L (little endian) */
 
 /* the reserved page sizes and offsets */
 
@@ -316,7 +305,6 @@ struct xpc_vars_part {
 				 xp_nasid_mask_words())
 #define XPC_RP_VARS_PART(_rp)	(struct xpc_vars_part *)((u8 *)XPC_RP_VARS(_rp) + XPC_RP_VARS_SIZE)
 
-
 /*
  * Functions registered by add_timer() or called by kernel_thread() only
  * allow for a single 64-bit argument. The following macros can be used to
@@ -330,8 +318,6 @@ struct xpc_vars_part {
 #define XPC_UNPACK_ARG1(_args)	(((u64) _args) & 0xffffffff)
 #define XPC_UNPACK_ARG2(_args)	((((u64) _args) >> 32) & 0xffffffff)
 
-
-
 /*
  * Define a Get/Put value pair (pointers) used with a message queue.
  */
@@ -343,8 +329,6 @@ struct xpc_gp {
 #define XPC_GP_SIZE \
 		L1_CACHE_ALIGN(sizeof(struct xpc_gp) * XPC_NCHANNELS)
 
-
-
 /*
  * Define a structure that contains arguments associated with opening and
  * closing a channel.
@@ -360,20 +344,15 @@ struct xpc_openclose_args {
 #define XPC_OPENCLOSE_ARGS_SIZE \
 	      L1_CACHE_ALIGN(sizeof(struct xpc_openclose_args) * XPC_NCHANNELS)
 
-
-
 /* struct xpc_msg flags */
 
 #define	XPC_M_DONE		0x01	/* msg has been received/consumed */
 #define	XPC_M_READY		0x02	/* msg is ready to be sent */
 #define	XPC_M_INTERRUPT		0x04	/* send interrupt when msg consumed */
 
-
 #define XPC_MSG_ADDRESS(_payload) \
 		((struct xpc_msg *)((u8 *)(_payload) - XPC_MSG_PAYLOAD_OFFSET))
 
-
-
 /*
  * Defines notify entry.
  *
@@ -381,19 +360,17 @@ struct xpc_openclose_args {
  * and consumed by the intended recipient.
  */
 struct xpc_notify {
-	volatile u8 type;		/* type of notification */
+	volatile u8 type;	/* type of notification */
 
 	/* the following two fields are only used if type == XPC_N_CALL */
-	xpc_notify_func func;		/* user's notify function */
-	void *key;			/* pointer to user's key */
+	xpc_notify_func func;	/* user's notify function */
+	void *key;		/* pointer to user's key */
 };
 
 /* struct xpc_notify type of notification */
 
 #define	XPC_N_CALL		0x01	/* notify function provided by user */
 
-
-
 /*
  * Define the structure that manages all the stuff required by a channel. In
  * particular, they are used to manage the messages sent across the channel.
@@ -473,48 +450,48 @@ struct xpc_notify {
  *	messages.
  */
 struct xpc_channel {
-	short partid;			/* ID of remote partition connected */
-	spinlock_t lock;		/* lock for updating this structure */
-	u32 flags;			/* general flags */
-
-	enum xp_retval reason;		/* reason why channel is disconnect'g */
-	int reason_line;		/* line# disconnect initiated from */
-
-	u16 number;			/* channel # */
-
-	u16 msg_size;			/* sizeof each msg entry */
-	u16 local_nentries;		/* #of msg entries in local msg queue */
-	u16 remote_nentries;		/* #of msg entries in remote msg queue*/
+	short partid;		/* ID of remote partition connected */
+	spinlock_t lock;	/* lock for updating this structure */
+	u32 flags;		/* general flags */
+
+	enum xp_retval reason;	/* reason why channel is disconnect'g */
+	int reason_line;	/* line# disconnect initiated from */
+
+	u16 number;		/* channel # */
+
+	u16 msg_size;		/* sizeof each msg entry */
+	u16 local_nentries;	/* #of msg entries in local msg queue */
+	u16 remote_nentries;	/* #of msg entries in remote msg queue */
 
 	void *local_msgqueue_base;	/* base address of kmalloc'd space */
 	struct xpc_msg *local_msgqueue;	/* local message queue */
 	void *remote_msgqueue_base;	/* base address of kmalloc'd space */
-	struct xpc_msg *remote_msgqueue;/* cached copy of remote partition's */
-					/* local message queue */
-	u64 remote_msgqueue_pa;		/* phys addr of remote partition's */
-					/* local message queue */
+	struct xpc_msg *remote_msgqueue;	/* cached copy of remote partition's */
+	/* local message queue */
+	u64 remote_msgqueue_pa;	/* phys addr of remote partition's */
+	/* local message queue */
 
-	atomic_t references;		/* #of external references to queues */
+	atomic_t references;	/* #of external references to queues */
 
-	atomic_t n_on_msg_allocate_wq;   /* #on msg allocation wait queue */
-	wait_queue_head_t msg_allocate_wq; /* msg allocation wait queue */
+	atomic_t n_on_msg_allocate_wq;	/* #on msg allocation wait queue */
+	wait_queue_head_t msg_allocate_wq;	/* msg allocation wait queue */
 
-	u8 delayed_IPI_flags;		/* IPI flags received, but delayed */
-					/* action until channel disconnected */
+	u8 delayed_IPI_flags;	/* IPI flags received, but delayed */
+	/* action until channel disconnected */
 
 	/* queue of msg senders who want to be notified when msg received */
 
-	atomic_t n_to_notify;		/* #of msg senders to notify */
-	struct xpc_notify *notify_queue;/* notify queue for messages sent */
+	atomic_t n_to_notify;	/* #of msg senders to notify */
+	struct xpc_notify *notify_queue;	/* notify queue for messages sent */
 
-	xpc_channel_func func;		/* user's channel function */
-	void *key;			/* pointer to user's key */
+	xpc_channel_func func;	/* user's channel function */
+	void *key;		/* pointer to user's key */
 
 	struct mutex msg_to_pull_mutex;	/* next msg to pull serialization */
-	struct completion wdisconnect_wait; /* wait for channel disconnect */
+	struct completion wdisconnect_wait;	/* wait for channel disconnect */
 
-	struct xpc_openclose_args *local_openclose_args; /* args passed on */
-					/* opening or closing of channel */
+	struct xpc_openclose_args *local_openclose_args;	/* args passed on */
+	/* opening or closing of channel */
 
 	/* various flavors of local and remote Get/Put values */
 
@@ -522,13 +499,13 @@ struct xpc_channel {
 	struct xpc_gp remote_GP;	/* remote Get/Put values */
 	struct xpc_gp w_local_GP;	/* working local Get/Put values */
 	struct xpc_gp w_remote_GP;	/* working remote Get/Put values */
-	s64 next_msg_to_pull;		/* Put value of next msg to pull */
+	s64 next_msg_to_pull;	/* Put value of next msg to pull */
 
 	/* kthread management related fields */
 
 	atomic_t kthreads_assigned;	/* #of kthreads assigned to channel */
 	u32 kthreads_assigned_limit;	/* limit on #of kthreads assigned */
-	atomic_t kthreads_idle;		/* #of kthreads idle waiting for work */
+	atomic_t kthreads_idle;	/* #of kthreads idle waiting for work */
 	u32 kthreads_idle_limit;	/* limit on #of kthreads idle */
 	atomic_t kthreads_active;	/* #of kthreads actively working */
 
@@ -536,37 +513,34 @@ struct xpc_channel {
 
 } ____cacheline_aligned;
 
-
 /* struct xpc_channel flags */
 
-#define	XPC_C_WASCONNECTED	0x00000001 /* channel was connected */
+#define	XPC_C_WASCONNECTED	0x00000001	/* channel was connected */
 
-#define	XPC_C_ROPENREPLY	0x00000002 /* remote open channel reply */
-#define	XPC_C_OPENREPLY		0x00000004 /* local open channel reply */
-#define	XPC_C_ROPENREQUEST	0x00000008 /* remote open channel request */
-#define	XPC_C_OPENREQUEST	0x00000010 /* local open channel request */
+#define	XPC_C_ROPENREPLY	0x00000002	/* remote open channel reply */
+#define	XPC_C_OPENREPLY		0x00000004	/* local open channel reply */
+#define	XPC_C_ROPENREQUEST	0x00000008	/* remote open channel request */
+#define	XPC_C_OPENREQUEST	0x00000010	/* local open channel request */
 
-#define	XPC_C_SETUP		0x00000020 /* channel's msgqueues are alloc'd */
-#define	XPC_C_CONNECTEDCALLOUT	0x00000040 /* connected callout initiated */
+#define	XPC_C_SETUP		0x00000020	/* channel's msgqueues are alloc'd */
+#define	XPC_C_CONNECTEDCALLOUT	0x00000040	/* connected callout initiated */
 #define	XPC_C_CONNECTEDCALLOUT_MADE \
-				0x00000080 /* connected callout completed */
-#define	XPC_C_CONNECTED		0x00000100 /* local channel is connected */
-#define	XPC_C_CONNECTING	0x00000200 /* channel is being connected */
-
-#define	XPC_C_RCLOSEREPLY	0x00000400 /* remote close channel reply */
-#define	XPC_C_CLOSEREPLY	0x00000800 /* local close channel reply */
-#define	XPC_C_RCLOSEREQUEST	0x00001000 /* remote close channel request */
-#define	XPC_C_CLOSEREQUEST	0x00002000 /* local close channel request */
+				0x00000080	/* connected callout completed */
+#define	XPC_C_CONNECTED		0x00000100	/* local channel is connected */
+#define	XPC_C_CONNECTING	0x00000200	/* channel is being connected */
+
+#define	XPC_C_RCLOSEREPLY	0x00000400	/* remote close channel reply */
+#define	XPC_C_CLOSEREPLY	0x00000800	/* local close channel reply */
+#define	XPC_C_RCLOSEREQUEST	0x00001000	/* remote close channel request */
+#define	XPC_C_CLOSEREQUEST	0x00002000	/* local close channel request */
 
-#define	XPC_C_DISCONNECTED	0x00004000 /* channel is disconnected */
-#define	XPC_C_DISCONNECTING	0x00008000 /* channel is being disconnected */
+#define	XPC_C_DISCONNECTED	0x00004000	/* channel is disconnected */
+#define	XPC_C_DISCONNECTING	0x00008000	/* channel is being disconnected */
 #define	XPC_C_DISCONNECTINGCALLOUT \
-				0x00010000 /* disconnecting callout initiated */
+				0x00010000	/* disconnecting callout initiated */
 #define	XPC_C_DISCONNECTINGCALLOUT_MADE \
-				0x00020000 /* disconnecting callout completed */
-#define	XPC_C_WDISCONNECT	0x00040000 /* waiting for channel disconnect */
-
-
+				0x00020000	/* disconnecting callout completed */
+#define	XPC_C_WDISCONNECT	0x00040000	/* waiting for channel disconnect */
 
 /*
  * Manages channels on a partition basis. There is one of these structures
@@ -577,36 +551,34 @@ struct xpc_partition {
 
 	/* XPC HB infrastructure */
 
-	u8 remote_rp_version;		/* version# of partition's rsvd pg */
+	u8 remote_rp_version;	/* version# of partition's rsvd pg */
 	short remote_npartitions;	/* value of XPC_NPARTITIONS */
-	u32 flags;			/* general flags */
-	struct timespec remote_rp_stamp;/* time when rsvd pg was initialized */
-	u64 remote_rp_pa;		/* phys addr of partition's rsvd pg */
-	u64 remote_vars_pa;		/* phys addr of partition's vars */
+	u32 flags;		/* general flags */
+	struct timespec remote_rp_stamp;	/* time when rsvd pg was initialized */
+	u64 remote_rp_pa;	/* phys addr of partition's rsvd pg */
+	u64 remote_vars_pa;	/* phys addr of partition's vars */
 	u64 remote_vars_part_pa;	/* phys addr of partition's vars part */
-	u64 last_heartbeat;		/* HB at last read */
+	u64 last_heartbeat;	/* HB at last read */
 	u64 remote_amos_page_pa;	/* phys addr of partition's amos page */
-	int remote_act_nasid;		/* active part's act/deact nasid */
+	int remote_act_nasid;	/* active part's act/deact nasid */
 	int remote_act_phys_cpuid;	/* active part's act/deact phys cpuid */
-	u32 act_IRQ_rcvd;		/* IRQs since activation */
-	spinlock_t lock;		/* protect updating of act_state and */
-					/* the general flags */
-	u8 act_state;			/* from XPC HB viewpoint */
-	u8 remote_vars_version;		/* version# of partition's vars */
-	enum xp_retval reason;		/* reason partition is deactivating */
-	int reason_line;		/* line# deactivation initiated from */
-	int reactivate_nasid;		/* nasid in partition to reactivate */
+	u32 act_IRQ_rcvd;	/* IRQs since activation */
+	spinlock_t lock;	/* protect updating of act_state and */
+	/* the general flags */
+	u8 act_state;		/* from XPC HB viewpoint */
+	u8 remote_vars_version;	/* version# of partition's vars */
+	enum xp_retval reason;	/* reason partition is deactivating */
+	int reason_line;	/* line# deactivation initiated from */
+	int reactivate_nasid;	/* nasid in partition to reactivate */
 
-	unsigned long disengage_request_timeout; /* timeout in jiffies */
+	unsigned long disengage_request_timeout;	/* timeout in jiffies */
 	struct timer_list disengage_request_timer;
 
-
 	/* XPC infrastructure referencing and teardown control */
 
 	volatile u8 setup_state;	/* infrastructure setup state */
 	wait_queue_head_t teardown_wq;	/* kthread waiting to teardown infra */
-	atomic_t references;		/* #of references to infrastructure */
-
+	atomic_t references;	/* #of references to infrastructure */
 
 	/*
 	 * NONE OF THE PRECEDING FIELDS OF THIS STRUCTURE WILL BE CLEARED WHEN
@@ -615,55 +587,51 @@ struct xpc_partition {
 	 * 'nchannels' FIELD MUST BE THE FIRST OF THE FIELDS TO BE CLEARED.)
 	 */
 
-
-	u8 nchannels;		   /* #of defined channels supported */
-	atomic_t nchannels_active; /* #of channels that are not DISCONNECTED */
-	atomic_t nchannels_engaged;/* #of channels engaged with remote part */
-	struct xpc_channel *channels;/* array of channel structures */
-
-	void *local_GPs_base;	  /* base address of kmalloc'd space */
-	struct xpc_gp *local_GPs; /* local Get/Put values */
-	void *remote_GPs_base;    /* base address of kmalloc'd space */
-	struct xpc_gp *remote_GPs;/* copy of remote partition's local Get/Put */
-				  /* values */
-	u64 remote_GPs_pa;	  /* phys address of remote partition's local */
-				  /* Get/Put values */
-
+	u8 nchannels;		/* #of defined channels supported */
+	atomic_t nchannels_active;	/* #of channels that are not DISCONNECTED */
+	atomic_t nchannels_engaged;	/* #of channels engaged with remote part */
+	struct xpc_channel *channels;	/* array of channel structures */
+
+	void *local_GPs_base;	/* base address of kmalloc'd space */
+	struct xpc_gp *local_GPs;	/* local Get/Put values */
+	void *remote_GPs_base;	/* base address of kmalloc'd space */
+	struct xpc_gp *remote_GPs;	/* copy of remote partition's local Get/Put */
+	/* values */
+	u64 remote_GPs_pa;	/* phys address of remote partition's local */
+	/* Get/Put values */
 
 	/* fields used to pass args when opening or closing a channel */
 
-	void *local_openclose_args_base;  /* base address of kmalloc'd space */
-	struct xpc_openclose_args *local_openclose_args;  /* local's args */
-	void *remote_openclose_args_base; /* base address of kmalloc'd space */
-	struct xpc_openclose_args *remote_openclose_args; /* copy of remote's */
-					  /* args */
-	u64 remote_openclose_args_pa;	  /* phys addr of remote's args */
-
+	void *local_openclose_args_base;	/* base address of kmalloc'd space */
+	struct xpc_openclose_args *local_openclose_args;	/* local's args */
+	void *remote_openclose_args_base;	/* base address of kmalloc'd space */
+	struct xpc_openclose_args *remote_openclose_args;	/* copy of remote's */
+	/* args */
+	u64 remote_openclose_args_pa;	/* phys addr of remote's args */
 
 	/* IPI sending, receiving and handling related fields */
 
-	int remote_IPI_nasid;	    /* nasid of where to send IPIs */
-	int remote_IPI_phys_cpuid;  /* phys CPU ID of where to send IPIs */
-	u64 *remote_IPI_amo_va;	    /* address of remote IPI AMO variable */
-
-	u64 *local_IPI_amo_va;      /* address of IPI AMO variable */
-	u64 local_IPI_amo;	    /* IPI amo flags yet to be handled */
-	char IPI_owner[8];	    /* IPI owner's name */
-	struct timer_list dropped_IPI_timer; /* dropped IPI timer */
-
-	spinlock_t IPI_lock;	    /* IPI handler lock */
+	int remote_IPI_nasid;	/* nasid of where to send IPIs */
+	int remote_IPI_phys_cpuid;	/* phys CPU ID of where to send IPIs */
+	u64 *remote_IPI_amo_va;	/* address of remote IPI AMO variable */
+
+	u64 *local_IPI_amo_va;	/* address of IPI AMO variable */
+	u64 local_IPI_amo;	/* IPI amo flags yet to be handled */
+	char IPI_owner[8];	/* IPI owner's name */
+	struct timer_list dropped_IPI_timer;	/* dropped IPI timer */
 
+	spinlock_t IPI_lock;	/* IPI handler lock */
 
 	/* channel manager related fields */
 
 	atomic_t channel_mgr_requests;	/* #of requests to activate chan mgr */
-	wait_queue_head_t channel_mgr_wq; /* channel mgr's wait queue */
+	wait_queue_head_t channel_mgr_wq;	/* channel mgr's wait queue */
 
 } ____cacheline_aligned;
 
 /* struct xpc_partition flags */
 
-#define	XPC_P_RAMOSREGISTERED	0x00000001 /* remote AMOs were registered */
+#define	XPC_P_RAMOSREGISTERED	0x00000001	/* remote AMOs were registered */
 
 /* struct xpc_partition act_state values (for XPC HB) */
 
@@ -673,11 +641,9 @@ struct xpc_partition {
 #define XPC_P_AS_ACTIVE		0x03	/* xpc_partition_up() was called */
 #define XPC_P_AS_DEACTIVATING	0x04	/* partition deactivation initiated */
 
-
 #define XPC_DEACTIVATE_PARTITION(_p, _reason) \
 			xpc_deactivate_partition(__LINE__, (_p), (_reason))
 
-
 /* struct xpc_partition setup_state values */
 
 #define XPC_P_SS_UNSET		0x00	/* infrastructure was never setup */
@@ -685,8 +651,6 @@ struct xpc_partition {
 #define XPC_P_SS_WTEARDOWN	0x02	/* waiting to teardown infrastructure */
 #define XPC_P_SS_TORNDOWN	0x03	/* infrastructure is torndown */
 
-
-
 /*
  * struct xpc_partition IPI_timer #of seconds to wait before checking for
  * dropped IPIs. These occur whenever an IPI amo write doesn't complete until
@@ -694,22 +658,17 @@ struct xpc_partition {
  */
 #define XPC_DROPPED_IPI_WAIT_INTERVAL	(0.25 * HZ)
 
-
 /* number of seconds to wait for other partitions to disengage */
 #define XPC_DISENGAGE_REQUEST_DEFAULT_TIMELIMIT	90
 
 /* interval in seconds to print 'waiting disengagement' messages */
 #define XPC_DISENGAGE_PRINTMSG_INTERVAL		10
 
-
 #define XPC_PARTID(_p)	((short) ((_p) - &xpc_partitions[0]))
 
-
-
 /* found in xp_main.c */
 extern struct xpc_registration xpc_registrations[];
 
-
 /* found in xpc_main.c */
 extern struct device *xpc_part;
 extern struct device *xpc_chan;
@@ -722,7 +681,6 @@ extern void xpc_activate_kthreads(struct
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
 
-
 /* found in xpc_partition.c */
 extern int xpc_exiting;
 extern struct xpc_vars *xpc_vars;
@@ -737,7 +695,7 @@ extern int xpc_identify_act_IRQ_sender(v
 extern int xpc_partition_disengaged(struct xpc_partition *);
 extern enum xp_retval xpc_mark_partition_active(struct xpc_partition *);
 extern void xpc_deactivate_partition(const int, struct xpc_partition *,
-						enum xp_retval);
+				     enum xp_retval);
 extern void xpc_mark_partition_inactive(struct xpc_partition *);
 extern enum xp_retval xpc_register_remote_amos(struct xpc_partition *);
 extern void xpc_unregister_remote_amos(struct xpc_partition *);
@@ -745,14 +703,13 @@ extern void xpc_discovery(void);
 extern void xpc_check_remote_hb(void);
 extern enum xp_retval xpc_initiate_partid_to_nasids(short, void *);
 
-
 /* found in xpc_channel.c */
 extern void xpc_initiate_connect(int);
 extern void xpc_initiate_disconnect(int);
 extern enum xp_retval xpc_initiate_allocate(short, int, u32, void **);
 extern enum xp_retval xpc_initiate_send(short, int, void *);
 extern enum xp_retval xpc_initiate_send_notify(short, int, void *,
-						xpc_notify_func, void *);
+					       xpc_notify_func, void *);
 extern void xpc_initiate_received(short, int, void *);
 extern enum xp_retval xpc_setup_infrastructure(struct xpc_partition *);
 extern enum xp_retval xpc_pull_remote_vars_part(struct xpc_partition *);
@@ -760,13 +717,11 @@ extern void xpc_process_channel_activity
 extern void xpc_connected_callout(struct xpc_channel *);
 extern void xpc_deliver_msg(struct xpc_channel *);
 extern void xpc_disconnect_channel(const int, struct xpc_channel *,
-					enum xp_retval, unsigned long *);
+				   enum xp_retval, unsigned long *);
 extern void xpc_disconnect_callout(struct xpc_channel *, enum xp_retval);
 extern void xpc_partition_going_down(struct xpc_partition *, enum xp_retval);
 extern void xpc_teardown_infrastructure(struct xpc_partition *);
 
-
-
 static inline void
 xpc_wakeup_channel_mgr(struct xpc_partition *part)
 {
@@ -775,8 +730,6 @@ xpc_wakeup_channel_mgr(struct xpc_partit
 	}
 }
 
-
-
 /*
  * These next two inlines are used to keep us from tearing down a channel's
  * msg queues while a thread may be referencing them.
@@ -798,12 +751,9 @@ xpc_msgqueue_deref(struct xpc_channel *c
 	}
 }
 
-
-
 #define XPC_DISCONNECT_CHANNEL(_ch, _reason, _irqflgs) \
 		xpc_disconnect_channel(__LINE__, _ch, _reason, _irqflgs)
 
-
 /*
  * These two inlines are used to keep us from tearing down a partition's
  * setup infrastructure while a thread may be referencing it.
@@ -813,7 +763,6 @@ xpc_part_deref(struct xpc_partition *par
 {
 	s32 refs = atomic_dec_return(&part->references);
 
-
 	DBUG_ON(refs < 0);
 	if (refs == 0 && part->setup_state == XPC_P_SS_WTEARDOWN) {
 		wake_up(&part->teardown_wq);
@@ -825,7 +774,6 @@ xpc_part_ref(struct xpc_partition *part)
 {
 	int setup;
 
-
 	atomic_inc(&part->references);
 	setup = (part->setup_state == XPC_P_SS_SETUP);
 	if (!setup) {
@@ -834,8 +782,6 @@ xpc_part_ref(struct xpc_partition *part)
 	return setup;
 }
 
-
-
 /*
  * The following macro is to be used for the setting of the reason and
  * reason_line fields in both the struct xpc_channel and struct xpc_partition
@@ -847,8 +793,6 @@ xpc_part_ref(struct xpc_partition *part)
 		(_p)->reason_line = _line; \
 	}
 
-
-
 /*
  * This next set of inlines are used to keep track of when a partition is
  * potentially engaged in accessing memory belonging to another partition.
@@ -858,8 +802,9 @@ static inline void
 xpc_mark_partition_engaged(struct xpc_partition *part)
 {
 	u64 *amo_va = __va(part->remote_amos_page_pa +
-			(xpc_engaged_partitions_amos(part->remote_npartitions) +
-			BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
+			   (xpc_engaged_partitions_amos
+			    (part->remote_npartitions) +
+			    BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
 
 	/* set bit corresponding to our partid in remote partition's AMO */
 	(void)xp_set_amo(amo_va, XP_AMO_OR, BIT_MASK(xp_partition_id), 1);
@@ -869,8 +814,9 @@ static inline void
 xpc_mark_partition_disengaged(struct xpc_partition *part)
 {
 	u64 *amo_va = __va(part->remote_amos_page_pa +
-			(xpc_engaged_partitions_amos(part->remote_npartitions) +
-			BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
+			   (xpc_engaged_partitions_amos
+			    (part->remote_npartitions) +
+			    BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
 
 	/* clear bit corresponding to our partid in remote partition's AMO */
 	(void)xp_set_amo(amo_va, XP_AMO_AND, ~BIT_MASK(xp_partition_id), 1);
@@ -880,8 +826,8 @@ static inline void
 xpc_request_partition_disengage(struct xpc_partition *part)
 {
 	u64 *amo_va = __va(part->remote_amos_page_pa +
-			(xpc_disengage_request_amos(part->remote_npartitions) +
-			BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
+			   (xpc_disengage_request_amos(part->remote_npartitions)
+			    + BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
 
 	/* set bit corresponding to our partid in remote partition's AMO */
 	(void)xp_set_amo(amo_va, XP_AMO_OR, BIT_MASK(xp_partition_id), 1);
@@ -891,8 +837,8 @@ static inline void
 xpc_cancel_partition_disengage_request(struct xpc_partition *part)
 {
 	u64 *amo_va = __va(part->remote_amos_page_pa +
-			(xpc_disengage_request_amos(part->remote_npartitions) +
-			BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
+			   (xpc_disengage_request_amos(part->remote_npartitions)
+			    + BIT_WORD(xp_partition_id)) * xp_sizeof_amo);
 
 	/* clear bit corresponding to our partid in remote partition's AMO */
 	(void)xp_set_amo(amo_va, XP_AMO_AND, ~BIT_MASK(xp_partition_id), 1);
@@ -904,14 +850,15 @@ xpc_any_partition_engaged(void)
 	enum xp_retval ret;
 	int w_index;
 	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
-			xpc_engaged_partitions_amos(xpc_vars->npartitions) *
-			xp_sizeof_amo);
+			      xpc_engaged_partitions_amos(xpc_vars->
+							  npartitions) *
+			      xp_sizeof_amo);
 	u64 amo;
 
 	for (w_index = 0; w_index < xp_partid_mask_words(xpc_vars->npartitions);
 	     w_index++) {
 		ret = xp_get_amo(amo_va, XP_AMO_LOAD, &amo);
-		BUG_ON(ret != xpSuccess);  /* should never happen */
+		BUG_ON(ret != xpSuccess);	/* should never happen */
 		if (amo != 0)
 			return 1;
 
@@ -925,13 +872,14 @@ xpc_partition_engaged(short partid)
 {
 	enum xp_retval ret;
 	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
-			(xpc_engaged_partitions_amos(xpc_vars->npartitions) +
-			BIT_WORD(partid)) * xp_sizeof_amo);
+			      (xpc_engaged_partitions_amos
+			       (xpc_vars->npartitions) +
+			       BIT_WORD(partid)) * xp_sizeof_amo);
 	u64 amo;
 
 	/* return our partition's AMO variable ANDed with partid mask */
 	ret = xp_get_amo(amo_va, XP_AMO_LOAD, &amo);
-	BUG_ON(ret != xpSuccess);  /* should never happen */
+	BUG_ON(ret != xpSuccess);	/* should never happen */
 	return (amo & BIT_MASK(partid));
 }
 
@@ -940,13 +888,14 @@ xpc_partition_disengage_requested(short 
 {
 	enum xp_retval ret;
 	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
-			(xpc_disengage_request_amos(xpc_vars->npartitions) +
-			BIT_WORD(partid)) * xp_sizeof_amo);
+			      (xpc_disengage_request_amos
+			       (xpc_vars->npartitions) +
+			       BIT_WORD(partid)) * xp_sizeof_amo);
 	u64 amo;
 
 	/* return our partition's AMO variable ANDed with partid mask */
 	ret = xp_get_amo(amo_va, XP_AMO_LOAD, &amo);
-	BUG_ON(ret != xpSuccess);  /* should never happen */
+	BUG_ON(ret != xpSuccess);	/* should never happen */
 	return (amo & BIT_MASK(partid));
 }
 
@@ -955,12 +904,13 @@ xpc_clear_partition_engaged(short partid
 {
 	enum xp_retval ret;
 	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
-			(xpc_engaged_partitions_amos(xpc_vars->npartitions) +
-			BIT_WORD(partid)) * xp_sizeof_amo);
+			      (xpc_engaged_partitions_amos
+			       (xpc_vars->npartitions) +
+			       BIT_WORD(partid)) * xp_sizeof_amo);
 
 	/* clear bit corresponding to partid in our partition's AMO */
 	ret = xp_set_amo(amo_va, XP_AMO_AND, ~BIT_MASK(partid), 0);
-	BUG_ON(ret != xpSuccess);  /* should never happen */
+	BUG_ON(ret != xpSuccess);	/* should never happen */
 }
 
 static inline void
@@ -968,16 +918,15 @@ xpc_clear_partition_disengage_request(sh
 {
 	enum xp_retval ret;
 	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page +
-			(xpc_disengage_request_amos(xpc_vars->npartitions) +
-			BIT_WORD(partid)) * xp_sizeof_amo);
+			      (xpc_disengage_request_amos
+			       (xpc_vars->npartitions) +
+			       BIT_WORD(partid)) * xp_sizeof_amo);
 
 	/* clear bit corresponding to partid in our partition's AMO */
 	ret = xp_set_amo(amo_va, XP_AMO_AND, ~BIT_MASK(partid), 0);
-	BUG_ON(ret != xpSuccess);  /* should never happen */
+	BUG_ON(ret != xpSuccess);	/* should never happen */
 }
 
-
-
 /*
  * The following set of macros and inlines are used for the sending and
  * receiving of IPIs (also known as IRQs). There are two flavors of IPIs,
@@ -1000,13 +949,13 @@ xpc_activate_IRQ_send(u64 amos_page_pa, 
 	/* SN nodes are always even numbered nasids */
 	u64 *amo_va = (u64 *)__va(amos_page_pa +
 				  (xpc_activate_irq_amos(npartitions) +
-				  BIT_WORD(from_nasid/2)) * xp_sizeof_amo);
+				   BIT_WORD(from_nasid / 2)) * xp_sizeof_amo);
 
 	ret = xp_set_amo_with_interrupt(amo_va, XP_AMO_OR,
-					BIT_MASK(from_nasid/2),
+					BIT_MASK(from_nasid / 2),
 					remote_amo, to_nasid,
 					to_phys_cpuid, SGI_XPC_ACTIVATE);
-	BUG_ON(!remote_amo && ret != xpSuccess); /* should never happen*/
+	BUG_ON(!remote_amo && ret != xpSuccess);	/* should never happen */
 }
 
 static inline void
@@ -1043,7 +992,6 @@ xpc_IPI_send_disengage(struct xpc_partit
 			      part->remote_npartitions);
 }
 
-
 /*
  * IPIs associated with SGI_XPC_NOTIFY IRQ.
  */
@@ -1057,12 +1005,11 @@ xpc_IPI_send_disengage(struct xpc_partit
 
 static inline void
 xpc_notify_IRQ_send(struct xpc_channel *ch, u8 ipi_flag, char *ipi_flag_string,
-			unsigned long *irq_flags)
+		    unsigned long *irq_flags)
 {
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	enum xp_retval ret;
 
-
 	if (unlikely(part->act_state == XPC_P_AS_DEACTIVATING))
 		return;
 
@@ -1082,7 +1029,6 @@ xpc_notify_IRQ_send(struct xpc_channel *
 	}
 }
 
-
 /*
  * Make it look like the remote partition, which is associated with the
  * specified channel, sent us an IPI. This faked IPI will be handled
@@ -1093,21 +1039,21 @@ xpc_notify_IRQ_send(struct xpc_channel *
 
 static inline void
 xpc_notify_IRQ_send_local(struct xpc_channel *ch, u8 ipi_flag,
-				char *ipi_flag_string)
+			  char *ipi_flag_string)
 {
 	enum xp_retval ret;
 	u64 *amo_va = xpc_partitions[ch->partid].local_IPI_amo_va;
 
 	/* set IPI flag corresponding to channel in partition's local AMO */
-	ret = xp_set_amo(amo_va, XP_AMO_OR, ((u64)ipi_flag << (ch->number * 8)),
-			 0);
-	BUG_ON(ret != xpSuccess);  /* should never happen */
+	ret =
+	    xp_set_amo(amo_va, XP_AMO_OR, ((u64)ipi_flag << (ch->number * 8)),
+		       0);
+	BUG_ON(ret != xpSuccess);	/* should never happen */
 
 	dev_dbg(xpc_chan, "%s sent local from partid=%d, channel=%d\n",
 		ipi_flag_string, ch->partid, ch->number);
 }
 
-
 /*
  * The sending and receiving of IPIs includes the setting of an AMO variable
  * to indicate the reason the IPI was sent. The 64-bit variable is divided
@@ -1122,7 +1068,6 @@ xpc_notify_IRQ_send_local(struct xpc_cha
 #define	XPC_IPI_OPENREPLY	0x08
 #define	XPC_IPI_MSGREQUEST	0x10
 
-
 /* given an AMO variable and a channel#, get its associated IPI flags */
 #define XPC_GET_IPI_FLAGS(_amo, _c)	((u8) (((_amo) >> ((_c) * 8)) & 0xff))
 #define XPC_SET_IPI_FLAGS(_amo, _c, _f)	(_amo) |= ((u64) (_f) << ((_c) * 8))
@@ -1130,13 +1075,11 @@ xpc_notify_IRQ_send_local(struct xpc_cha
 #define	XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(_amo) ((_amo) & 0x0f0f0f0f0f0f0f0fUL)
 #define XPC_ANY_MSG_IPI_FLAGS_SET(_amo)       ((_amo) & 0x1010101010101010UL)
 
-
 static inline void
 xpc_IPI_send_closerequest(struct xpc_channel *ch, unsigned long *irq_flags)
 {
 	struct xpc_openclose_args *args = ch->local_openclose_args;
 
-
 	args->reason = ch->reason;
 
 	XPC_NOTIFY_IRQ_SEND(ch, XPC_IPI_CLOSEREQUEST, irq_flags);
@@ -1153,7 +1096,6 @@ xpc_IPI_send_openrequest(struct xpc_chan
 {
 	struct xpc_openclose_args *args = ch->local_openclose_args;
 
-
 	args->msg_size = ch->msg_size;
 	args->local_nentries = ch->local_nentries;
 
@@ -1165,7 +1107,6 @@ xpc_IPI_send_openreply(struct xpc_channe
 {
 	struct xpc_openclose_args *args = ch->local_openclose_args;
 
-
 	args->remote_nentries = ch->remote_nentries;
 	args->local_nentries = ch->local_nentries;
 	args->local_msgqueue_pa = __pa(ch->local_msgqueue);
@@ -1185,21 +1126,17 @@ xpc_IPI_send_local_msgrequest(struct xpc
 	XPC_NOTIFY_IRQ_SEND_LOCAL(ch, XPC_IPI_MSGREQUEST);
 }
 
-
 static inline u64 *
 xpc_IPI_init(int index)
 {
 	enum xp_retval ret;
-	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page + index *
-				xp_sizeof_amo);
+	u64 *amo_va = (u64 *)((u64)xpc_vars->amos_page + index * xp_sizeof_amo);
 
 	ret = xp_get_amo(amo_va, XP_AMO_CLEAR, NULL);
-	BUG_ON(ret != xpSuccess);  /* should never happen */
+	BUG_ON(ret != xpSuccess);	/* should never happen */
 	return amo_va;
 }
 
-
-
 /*
  * Check to see if there is any channel activity to/from the specified
  * partition.
@@ -1211,9 +1148,8 @@ xpc_check_for_channel_activity(struct xp
 	u64 IPI_amo;
 	unsigned long irq_flags;
 
-
 	ret = xp_get_amo(part->local_IPI_amo_va, XP_AMO_CLEAR, &IPI_amo);
-	BUG_ON(ret != xpSuccess);  /* should never happen */
+	BUG_ON(ret != xpSuccess);	/* should never happen */
 	if (IPI_amo == 0) {
 		return;
 	}
@@ -1228,6 +1164,4 @@ xpc_check_for_channel_activity(struct xp
 	xpc_wakeup_channel_mgr(part);
 }
 
-
 #endif /* _DRIVERS_MISC_XP_XPC_H */
-
Index: linux-2.6/drivers/misc/xp/xpc_channel.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpc_channel.c	2008-03-26 10:41:46.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xpc_channel.c	2008-03-26 10:57:58.908017152 -0500
@@ -6,7 +6,6 @@
  * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
-
 /*
  * Cross Partition Communication (XPC) channel support.
  *
@@ -15,7 +14,6 @@
  *
  */
 
-
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -29,7 +27,6 @@
 #define cmpxchg_rel(ptr,o,n)	cmpxchg(ptr,o,n)
 #endif
 
-
 /*
  * Guarantee that the kzalloc'd memory is cacheline aligned.
  */
@@ -41,7 +38,7 @@ xpc_kzalloc_cacheline_aligned(size_t siz
 	if (*base == NULL) {
 		return NULL;
 	}
-	if ((u64) *base == L1_CACHE_ALIGN((u64) *base)) {
+	if ((u64)*base == L1_CACHE_ALIGN((u64)*base)) {
 		return *base;
 	}
 	kfree(*base);
@@ -51,10 +48,9 @@ xpc_kzalloc_cacheline_aligned(size_t siz
 	if (*base == NULL) {
 		return NULL;
 	}
-	return (void *) L1_CACHE_ALIGN((u64) *base);
+	return (void *)L1_CACHE_ALIGN((u64)*base);
 }
 
-
 /*
  * Set up the initial values for the XPartition Communication channels.
  */
@@ -64,7 +60,6 @@ xpc_initialize_channels(struct xpc_parti
 	int ch_number;
 	struct xpc_channel *ch;
 
-
 	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
 		ch = &part->channels[ch_number];
 
@@ -74,7 +69,7 @@ xpc_initialize_channels(struct xpc_parti
 
 		ch->local_GP = &part->local_GPs[ch_number];
 		ch->local_openclose_args =
-					&part->local_openclose_args[ch_number];
+		    &part->local_openclose_args[ch_number];
 
 		atomic_set(&ch->kthreads_assigned, 0);
 		atomic_set(&ch->kthreads_idle, 0);
@@ -93,7 +88,6 @@ xpc_initialize_channels(struct xpc_parti
 	}
 }
 
-
 /*
  * Setup the infrastructure necessary to support XPartition Communication
  * between the specified remote partition and the local one.
@@ -105,7 +99,6 @@ xpc_setup_infrastructure(struct xpc_part
 	struct timer_list *timer;
 	short partid = XPC_PARTID(part);
 
-
 	/*
 	 * Zero out MOST of the entry for this partition. Only the fields
 	 * starting with `nchannels' will be zeroed. The preceding fields must
@@ -113,14 +106,14 @@ xpc_setup_infrastructure(struct xpc_part
 	 * referenced during this memset() operation.
 	 */
 	memset(&part->nchannels, 0, sizeof(struct xpc_partition) -
-				offsetof(struct xpc_partition, nchannels));
+	       offsetof(struct xpc_partition, nchannels));
 
 	/*
 	 * Allocate all of the channel structures as a contiguous chunk of
 	 * memory.
 	 */
 	part->channels = kzalloc(sizeof(struct xpc_channel) * XPC_NCHANNELS,
-								GFP_KERNEL);
+				 GFP_KERNEL);
 	if (part->channels == NULL) {
 		dev_err(xpc_chan, "can't get memory for channels\n");
 		return xpNoMemory;
@@ -128,11 +121,11 @@ xpc_setup_infrastructure(struct xpc_part
 
 	part->nchannels = XPC_NCHANNELS;
 
-
 	/* allocate all the required GET/PUT values */
 
 	part->local_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
-					GFP_KERNEL, &part->local_GPs_base);
+							GFP_KERNEL,
+							&part->local_GPs_base);
 	if (part->local_GPs == NULL) {
 		kfree(part->channels);
 		part->channels = NULL;
@@ -142,7 +135,9 @@ xpc_setup_infrastructure(struct xpc_part
 	}
 
 	part->remote_GPs = xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE,
-					GFP_KERNEL, &part->remote_GPs_base);
+							 GFP_KERNEL,
+							 &part->
+							 remote_GPs_base);
 	if (part->remote_GPs == NULL) {
 		dev_err(xpc_chan, "can't get memory for remote get/put "
 			"values\n");
@@ -153,12 +148,11 @@ xpc_setup_infrastructure(struct xpc_part
 		return xpNoMemory;
 	}
 
-
 	/* allocate all the required open and close args */
 
-	part->local_openclose_args = xpc_kzalloc_cacheline_aligned(
-					XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
-					&part->local_openclose_args_base);
+	part->local_openclose_args =
+	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
+					  &part->local_openclose_args_base);
 	if (part->local_openclose_args == NULL) {
 		dev_err(xpc_chan, "can't get memory for local connect args\n");
 		kfree(part->remote_GPs_base);
@@ -170,9 +164,9 @@ xpc_setup_infrastructure(struct xpc_part
 		return xpNoMemory;
 	}
 
-	part->remote_openclose_args = xpc_kzalloc_cacheline_aligned(
-					XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
-					&part->remote_openclose_args_base);
+	part->remote_openclose_args =
+	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE, GFP_KERNEL,
+					  &part->remote_openclose_args_base);
 	if (part->remote_openclose_args == NULL) {
 		dev_err(xpc_chan, "can't get memory for remote connect args\n");
 		kfree(part->local_openclose_args_base);
@@ -186,13 +180,11 @@ xpc_setup_infrastructure(struct xpc_part
 		return xpNoMemory;
 	}
 
-
 	xpc_initialize_channels(part, partid);
 
 	atomic_set(&part->nchannels_active, 0);
 	atomic_set(&part->nchannels_engaged, 0);
 
-
 	/* local_IPI_amo were set to 0 by an earlier memset() */
 
 	/* Initialize this partitions AMO structure */
@@ -205,7 +197,7 @@ xpc_setup_infrastructure(struct xpc_part
 
 	sprintf(part->IPI_owner, "xpc%02d", partid);
 	ret = request_irq(SGI_XPC_NOTIFY, xpc_notify_IRQ_handler, IRQF_SHARED,
-				part->IPI_owner, (void *) (u64) partid);
+			  part->IPI_owner, (void *)(u64)partid);
 	if (ret != 0) {
 		dev_err(xpc_chan, "can't register NOTIFY IRQ handler, "
 			"errno=%d\n", -ret);
@@ -225,8 +217,8 @@ xpc_setup_infrastructure(struct xpc_part
 	/* Setup a timer to check for dropped IPIs */
 	timer = &part->dropped_IPI_timer;
 	init_timer(timer);
-	timer->function = (void (*)(unsigned long)) xpc_dropped_IPI_check;
-	timer->data = (unsigned long) part;
+	timer->function = (void (*)(unsigned long))xpc_dropped_IPI_check;
+	timer->data = (unsigned long)part;
 	timer->expires = jiffies + XPC_DROPPED_IPI_WAIT_INTERVAL;
 	add_timer(timer);
 
@@ -236,7 +228,6 @@ xpc_setup_infrastructure(struct xpc_part
 	 */
 	part->setup_state = XPC_P_SS_SETUP;
 
-
 	/*
 	 * Setup the per partition specific variables required by the
 	 * remote partition to establish channel connections with us.
@@ -246,7 +237,7 @@ xpc_setup_infrastructure(struct xpc_part
 	 */
 	xpc_vars_part[partid].GPs_pa = __pa(part->local_GPs);
 	xpc_vars_part[partid].openclose_args_pa =
-					__pa(part->local_openclose_args);
+	    __pa(part->local_openclose_args);
 	xpc_vars_part[partid].IPI_amo_pa = __pa(part->local_IPI_amo_va);
 	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
 	xpc_vars_part[partid].IPI_nasid = xp_cpu_to_nasid(cpuid);
@@ -257,7 +248,6 @@ xpc_setup_infrastructure(struct xpc_part
 	return xpSuccess;
 }
 
-
 /*
  * Create a wrapper that hides the underlying mechanism for pulling a cacheline
  * (or multiple cachelines) from a remote partition.
@@ -268,13 +258,12 @@ xpc_setup_infrastructure(struct xpc_part
  */
 static enum xp_retval
 xpc_pull_remote_cachelines(struct xpc_partition *part, void *dst,
-				const void *src, size_t cnt)
+			   const void *src, size_t cnt)
 {
 	enum xp_retval ret;
 
-
-	DBUG_ON((u64) src != L1_CACHE_ALIGN((u64) src));
-	DBUG_ON((u64) dst != L1_CACHE_ALIGN((u64) dst));
+	DBUG_ON((u64)src != L1_CACHE_ALIGN((u64)src));
+	DBUG_ON((u64)dst != L1_CACHE_ALIGN((u64)dst));
 	DBUG_ON(cnt != L1_CACHE_ALIGN(cnt));
 
 	if (part->act_state == XPC_P_AS_DEACTIVATING) {
@@ -290,7 +279,6 @@ xpc_pull_remote_cachelines(struct xpc_pa
 	return ret;
 }
 
-
 /*
  * Pull the remote per partition specific variables from the specified
  * partition.
@@ -300,41 +288,40 @@ xpc_pull_remote_vars_part(struct xpc_par
 {
 	u8 buffer[L1_CACHE_BYTES * 2];
 	struct xpc_vars_part *pulled_entry_cacheline =
-			(struct xpc_vars_part *) L1_CACHE_ALIGN((u64) buffer);
+	    (struct xpc_vars_part *)L1_CACHE_ALIGN((u64)buffer);
 	struct xpc_vars_part *pulled_entry;
 	u64 remote_entry_cacheline_pa, remote_entry_pa;
 	short partid = XPC_PARTID(part);
 	enum xp_retval ret;
 
-
 	/* pull the cacheline that contains the variables we're interested in */
 
 	DBUG_ON(part->remote_vars_part_pa !=
-				L1_CACHE_ALIGN(part->remote_vars_part_pa));
+		L1_CACHE_ALIGN(part->remote_vars_part_pa));
 	DBUG_ON(sizeof(struct xpc_vars_part) != L1_CACHE_BYTES / 2);
 
 	remote_entry_pa = part->remote_vars_part_pa +
-			xp_partition_id * sizeof(struct xpc_vars_part);
+	    xp_partition_id * sizeof(struct xpc_vars_part);
 
 	remote_entry_cacheline_pa = (remote_entry_pa & ~(L1_CACHE_BYTES - 1));
 
-	pulled_entry = (struct xpc_vars_part *) ((u64) pulled_entry_cacheline +
-				(remote_entry_pa & (L1_CACHE_BYTES - 1)));
+	pulled_entry = (struct xpc_vars_part *)((u64)pulled_entry_cacheline +
+						(remote_entry_pa &
+						 (L1_CACHE_BYTES - 1)));
 
 	ret = xpc_pull_remote_cachelines(part, pulled_entry_cacheline,
-					(void *) remote_entry_cacheline_pa,
-					L1_CACHE_BYTES);
+					 (void *)remote_entry_cacheline_pa,
+					 L1_CACHE_BYTES);
 	if (ret != xpSuccess) {
 		dev_dbg(xpc_chan, "failed to pull XPC vars_part from "
 			"partition %d, ret=%d\n", partid, ret);
 		return ret;
 	}
 
-
 	/* see if they've been set up yet */
 
 	if (pulled_entry->magic != XPC_VP_MAGIC1 &&
-				pulled_entry->magic != XPC_VP_MAGIC2) {
+	    pulled_entry->magic != XPC_VP_MAGIC2) {
 
 		if (pulled_entry->magic != 0) {
 			dev_dbg(xpc_chan, "partition %d's XPC vars_part for "
@@ -353,8 +340,8 @@ xpc_pull_remote_vars_part(struct xpc_par
 		/* validate the variables */
 
 		if (pulled_entry->GPs_pa == 0 ||
-				pulled_entry->openclose_args_pa == 0 ||
-					pulled_entry->IPI_amo_pa == 0) {
+		    pulled_entry->openclose_args_pa == 0 ||
+		    pulled_entry->IPI_amo_pa == 0) {
 
 			dev_err(xpc_chan, "partition %d's XPC vars_part for "
 				"partition %d are not valid\n", partid,
@@ -366,7 +353,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 
 		part->remote_GPs_pa = pulled_entry->GPs_pa;
 		part->remote_openclose_args_pa =
-					pulled_entry->openclose_args_pa;
+		    pulled_entry->openclose_args_pa;
 		part->remote_IPI_amo_va = __va(pulled_entry->IPI_amo_pa);
 		part->remote_IPI_nasid = pulled_entry->IPI_nasid;
 		part->remote_IPI_phys_cpuid = pulled_entry->IPI_phys_cpuid;
@@ -387,7 +374,6 @@ xpc_pull_remote_vars_part(struct xpc_par
 	return xpSuccess;
 }
 
-
 /*
  * Get the IPI flags and pull the openclose args and/or remote GPs as needed.
  */
@@ -398,7 +384,6 @@ xpc_get_IPI_flags(struct xpc_partition *
 	u64 IPI_amo;
 	enum xp_retval ret;
 
-
 	/*
 	 * See if there are any IPI flags to be handled.
 	 */
@@ -409,12 +394,12 @@ xpc_get_IPI_flags(struct xpc_partition *
 	}
 	spin_unlock_irqrestore(&part->IPI_lock, irq_flags);
 
-
 	if (XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(IPI_amo)) {
 		ret = xpc_pull_remote_cachelines(part,
-					part->remote_openclose_args,
-					(void *) part->remote_openclose_args_pa,
-					XPC_OPENCLOSE_ARGS_SIZE);
+						 part->remote_openclose_args,
+						 (void *)part->
+						 remote_openclose_args_pa,
+						 XPC_OPENCLOSE_ARGS_SIZE);
 		if (ret != xpSuccess) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
 
@@ -429,8 +414,8 @@ xpc_get_IPI_flags(struct xpc_partition *
 
 	if (XPC_ANY_MSG_IPI_FLAGS_SET(IPI_amo)) {
 		ret = xpc_pull_remote_cachelines(part, part->remote_GPs,
-						(void *) part->remote_GPs_pa,
-						XPC_GP_SIZE);
+						 (void *)part->remote_GPs_pa,
+						 XPC_GP_SIZE);
 		if (ret != xpSuccess) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
 
@@ -445,7 +430,6 @@ xpc_get_IPI_flags(struct xpc_partition *
 	return IPI_amo;
 }
 
-
 /*
  * Allocate the local message queue and the notify queue.
  */
@@ -460,8 +444,9 @@ xpc_allocate_local_msgqueue(struct xpc_c
 
 		nbytes = nentries * ch->msg_size;
 		ch->local_msgqueue = xpc_kzalloc_cacheline_aligned(nbytes,
-						GFP_KERNEL,
-						&ch->local_msgqueue_base);
+								   GFP_KERNEL,
+								   &ch->
+								   local_msgqueue_base);
 		if (ch->local_msgqueue == NULL) {
 			continue;
 		}
@@ -491,7 +476,6 @@ xpc_allocate_local_msgqueue(struct xpc_c
 	return xpNoMemory;
 }
 
-
 /*
  * Allocate the cached remote message queue.
  */
@@ -502,15 +486,15 @@ xpc_allocate_remote_msgqueue(struct xpc_
 	int nentries;
 	size_t nbytes;
 
-
 	DBUG_ON(ch->remote_nentries <= 0);
 
 	for (nentries = ch->remote_nentries; nentries > 0; nentries--) {
 
 		nbytes = nentries * ch->msg_size;
 		ch->remote_msgqueue = xpc_kzalloc_cacheline_aligned(nbytes,
-						GFP_KERNEL,
-						&ch->remote_msgqueue_base);
+								    GFP_KERNEL,
+								    &ch->
+								    remote_msgqueue_base);
 		if (ch->remote_msgqueue == NULL) {
 			continue;
 		}
@@ -532,7 +516,6 @@ xpc_allocate_remote_msgqueue(struct xpc_
 	return xpNoMemory;
 }
 
-
 /*
  * Allocate message queues and other stuff associated with a channel.
  *
@@ -544,7 +527,6 @@ xpc_allocate_msgqueues(struct xpc_channe
 	unsigned long irq_flags;
 	enum xp_retval ret;
 
-
 	DBUG_ON(ch->flags & XPC_C_SETUP);
 
 	if ((ret = xpc_allocate_local_msgqueue(ch)) != xpSuccess) {
@@ -566,7 +548,6 @@ xpc_allocate_msgqueues(struct xpc_channe
 	return xpSuccess;
 }
 
-
 /*
  * Process a connect message from a remote partition.
  *
@@ -578,11 +559,10 @@ xpc_process_connect(struct xpc_channel *
 {
 	enum xp_retval ret;
 
-
 	DBUG_ON(!spin_is_locked(&ch->lock));
 
 	if (!(ch->flags & XPC_C_OPENREQUEST) ||
-				!(ch->flags & XPC_C_ROPENREQUEST)) {
+	    !(ch->flags & XPC_C_ROPENREQUEST)) {
 		/* nothing more to do for now */
 		return;
 	}
@@ -619,14 +599,13 @@ xpc_process_connect(struct xpc_channel *
 	ch->flags = (XPC_C_CONNECTED | XPC_C_SETUP);	/* clear all else */
 
 	dev_info(xpc_chan, "channel %d to partition %d connected\n",
-		ch->number, ch->partid);
+		 ch->number, ch->partid);
 
 	spin_unlock_irqrestore(&ch->lock, *irq_flags);
 	xpc_create_kthreads(ch, 1, 0);
 	spin_lock_irqsave(&ch->lock, *irq_flags);
 }
 
-
 /*
  * Notify those who wanted to be notified upon delivery of their message.
  */
@@ -637,7 +616,6 @@ xpc_notify_senders(struct xpc_channel *c
 	u8 notify_type;
 	s64 get = ch->w_remote_GP.get - 1;
 
-
 	while (++get < put && atomic_read(&ch->n_to_notify) > 0) {
 
 		notify = &ch->notify_queue[get % ch->local_nentries];
@@ -650,8 +628,7 @@ xpc_notify_senders(struct xpc_channel *c
 		 */
 		notify_type = notify->type;
 		if (notify_type == 0 ||
-				cmpxchg(&notify->type, notify_type, 0) !=
-								notify_type) {
+		    cmpxchg(&notify->type, notify_type, 0) != notify_type) {
 			continue;
 		}
 
@@ -662,21 +639,20 @@ xpc_notify_senders(struct xpc_channel *c
 		if (notify->func != NULL) {
 			dev_dbg(xpc_chan, "notify->func() called, notify=0x%p, "
 				"msg_number=%" U64_ELL "d, partid=%d, "
-				"channel=%d\n", (void *) notify, get,
+				"channel=%d\n", (void *)notify, get,
 				ch->partid, ch->number);
 
 			notify->func(reason, ch->partid, ch->number,
-								notify->key);
+				     notify->key);
 
 			dev_dbg(xpc_chan, "notify->func() returned, "
 				"notify=0x%p, msg_number=%" U64_ELL "d, "
-				"partid=%d, channel=%d\n", (void *) notify,
+				"partid=%d, channel=%d\n", (void *)notify,
 				get, ch->partid, ch->number);
 		}
 	}
 }
 
-
 /*
  * Free up message queues and other stuff that were allocated for the specified
  * channel.
@@ -724,7 +700,6 @@ xpc_free_msgqueues(struct xpc_channel *c
 	}
 }
 
-
 /*
  * spin_lock_irqsave() is expected to be held on entry.
  */
@@ -734,7 +709,6 @@ xpc_process_disconnect(struct xpc_channe
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	u32 channel_was_connected = (ch->flags & XPC_C_WASCONNECTED);
 
-
 	DBUG_ON(!spin_is_locked(&ch->lock));
 
 	if (!(ch->flags & XPC_C_DISCONNECTING)) {
@@ -746,11 +720,11 @@ xpc_process_disconnect(struct xpc_channe
 	/* make sure all activity has settled down first */
 
 	if (atomic_read(&ch->kthreads_assigned) > 0 ||
-				atomic_read(&ch->references) > 0) {
+	    atomic_read(&ch->references) > 0) {
 		return;
 	}
 	DBUG_ON((ch->flags & XPC_C_CONNECTEDCALLOUT_MADE) &&
-			!(ch->flags & XPC_C_DISCONNECTINGCALLOUT_MADE));
+		!(ch->flags & XPC_C_DISCONNECTINGCALLOUT_MADE));
 
 	if (part->act_state == XPC_P_AS_DEACTIVATING) {
 		/* can't proceed until the other side disengages from us */
@@ -800,7 +774,7 @@ xpc_process_disconnect(struct xpc_channe
 
 	if (channel_was_connected) {
 		dev_info(xpc_chan, "channel %d to partition %d disconnected, "
-			"reason=%d\n", ch->number, ch->partid, ch->reason);
+			 "reason=%d\n", ch->number, ch->partid, ch->reason);
 	}
 
 	if (ch->flags & XPC_C_WDISCONNECT) {
@@ -811,35 +785,31 @@ xpc_process_disconnect(struct xpc_channe
 			/* time to take action on any delayed IPI flags */
 			spin_lock(&part->IPI_lock);
 			XPC_SET_IPI_FLAGS(part->local_IPI_amo, ch->number,
-							ch->delayed_IPI_flags);
+					  ch->delayed_IPI_flags);
 			spin_unlock(&part->IPI_lock);
 		}
 		ch->delayed_IPI_flags = 0;
 	}
 }
 
-
 /*
  * Process a change in the channel's remote connection state.
  */
 static void
 xpc_process_openclose_IPI(struct xpc_partition *part, int ch_number,
-				u8 IPI_flags)
+			  u8 IPI_flags)
 {
 	unsigned long irq_flags;
 	struct xpc_openclose_args *args =
-				&part->remote_openclose_args[ch_number];
+	    &part->remote_openclose_args[ch_number];
 	struct xpc_channel *ch = &part->channels[ch_number];
 	enum xp_retval reason;
 
-
-
 	spin_lock_irqsave(&ch->lock, irq_flags);
 
-again:
+      again:
 
-	if ((ch->flags & XPC_C_DISCONNECTED) &&
-					(ch->flags & XPC_C_WDISCONNECT)) {
+	if ((ch->flags & XPC_C_DISCONNECTED) && (ch->flags & XPC_C_WDISCONNECT)) {
 		/*
 		 * Delay processing IPI flags until thread waiting disconnect
 		 * has had a chance to see that the channel is disconnected.
@@ -849,7 +819,6 @@ again:
 		return;
 	}
 
-
 	if (IPI_flags & XPC_IPI_CLOSEREQUEST) {
 
 		dev_dbg(xpc_chan, "XPC_IPI_CLOSEREQUEST (reason=%d) received "
@@ -881,13 +850,14 @@ again:
 		if (ch->flags & XPC_C_DISCONNECTED) {
 			if (!(IPI_flags & XPC_IPI_OPENREQUEST)) {
 				if ((XPC_GET_IPI_FLAGS(part->local_IPI_amo,
-					 ch_number) & XPC_IPI_OPENREQUEST)) {
+						       ch_number) &
+				     XPC_IPI_OPENREQUEST)) {
 
 					DBUG_ON(ch->delayed_IPI_flags != 0);
 					spin_lock(&part->IPI_lock);
 					XPC_SET_IPI_FLAGS(part->local_IPI_amo,
-							ch_number,
-							XPC_IPI_CLOSEREQUEST);
+							  ch_number,
+							  XPC_IPI_CLOSEREQUEST);
 					spin_unlock(&part->IPI_lock);
 				}
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
@@ -928,7 +898,6 @@ again:
 		xpc_process_disconnect(ch, &irq_flags);
 	}
 
-
 	if (IPI_flags & XPC_IPI_CLOSEREPLY) {
 
 		dev_dbg(xpc_chan, "XPC_IPI_CLOSEREPLY received from partid=%d,"
@@ -944,12 +913,13 @@ again:
 
 		if (!(ch->flags & XPC_C_RCLOSEREQUEST)) {
 			if ((XPC_GET_IPI_FLAGS(part->local_IPI_amo, ch_number)
-						& XPC_IPI_CLOSEREQUEST)) {
+			     & XPC_IPI_CLOSEREQUEST)) {
 
 				DBUG_ON(ch->delayed_IPI_flags != 0);
 				spin_lock(&part->IPI_lock);
 				XPC_SET_IPI_FLAGS(part->local_IPI_amo,
-						ch_number, XPC_IPI_CLOSEREPLY);
+						  ch_number,
+						  XPC_IPI_CLOSEREPLY);
 				spin_unlock(&part->IPI_lock);
 			}
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
@@ -964,7 +934,6 @@ again:
 		}
 	}
 
-
 	if (IPI_flags & XPC_IPI_OPENREQUEST) {
 
 		dev_dbg(xpc_chan, "XPC_IPI_OPENREQUEST (msg_size=%d, "
@@ -973,7 +942,7 @@ again:
 			ch->partid, ch->number);
 
 		if (part->act_state == XPC_P_AS_DEACTIVATING ||
-					(ch->flags & XPC_C_ROPENREQUEST)) {
+		    (ch->flags & XPC_C_ROPENREQUEST)) {
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
 		}
@@ -984,9 +953,9 @@ again:
 			return;
 		}
 		DBUG_ON(!(ch->flags & (XPC_C_DISCONNECTED |
-							XPC_C_OPENREQUEST)));
+				       XPC_C_OPENREQUEST)));
 		DBUG_ON(ch->flags & (XPC_C_ROPENREQUEST | XPC_C_ROPENREPLY |
-					XPC_C_OPENREPLY | XPC_C_CONNECTED));
+				     XPC_C_OPENREPLY | XPC_C_CONNECTED));
 
 		/*
 		 * The meaningful OPENREQUEST connection state fields are:
@@ -1002,11 +971,10 @@ again:
 		ch->flags |= (XPC_C_ROPENREQUEST | XPC_C_CONNECTING);
 		ch->remote_nentries = args->local_nentries;
 
-
 		if (ch->flags & XPC_C_OPENREQUEST) {
 			if (args->msg_size != ch->msg_size) {
 				XPC_DISCONNECT_CHANNEL(ch, xpUnequalMsgSizes,
-								&irq_flags);
+						       &irq_flags);
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
 				return;
 			}
@@ -1022,7 +990,6 @@ again:
 		xpc_process_connect(ch, &irq_flags);
 	}
 
-
 	if (IPI_flags & XPC_IPI_OPENREPLY) {
 
 		dev_dbg(xpc_chan, "XPC_IPI_OPENREPLY (local_msgqueue_pa=0x%"
@@ -1037,7 +1004,7 @@ again:
 		}
 		if (!(ch->flags & XPC_C_OPENREQUEST)) {
 			XPC_DISCONNECT_CHANNEL(ch, xpOpenCloseError,
-								&irq_flags);
+					       &irq_flags);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return;
 		}
@@ -1048,7 +1015,7 @@ again:
 		/*
 		 * The meaningful OPENREPLY connection state fields are:
 		 *      local_msgqueue_pa = physical address of remote
-		 *			    partition's local_msgqueue
+		 *                          partition's local_msgqueue
 		 *      local_nentries = remote partition's local_nentries
 		 *      remote_nentries = remote partition's remote_nentries
 		 */
@@ -1084,7 +1051,6 @@ again:
 	spin_unlock_irqrestore(&ch->lock, irq_flags);
 }
 
-
 /*
  * Attempt to establish a channel connection to a remote partition.
  */
@@ -1094,7 +1060,6 @@ xpc_connect_channel(struct xpc_channel *
 	unsigned long irq_flags;
 	struct xpc_registration *registration = &xpc_registrations[ch->number];
 
-
 	if (mutex_trylock(&registration->mutex) == 0) {
 		return xpRetry;
 	}
@@ -1115,7 +1080,6 @@ xpc_connect_channel(struct xpc_channel *
 		return ch->reason;
 	}
 
-
 	/* add info from the channel connect registration to the channel */
 
 	ch->kthreads_assigned_limit = registration->assigned_limit;
@@ -1145,7 +1109,7 @@ xpc_connect_channel(struct xpc_channel *
 			 */
 			mutex_unlock(&registration->mutex);
 			XPC_DISCONNECT_CHANNEL(ch, xpUnequalMsgSizes,
-								&irq_flags);
+					       &irq_flags);
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
 			return xpUnequalMsgSizes;
 		}
@@ -1160,7 +1124,6 @@ xpc_connect_channel(struct xpc_channel *
 
 	mutex_unlock(&registration->mutex);
 
-
 	/* initiate the connection */
 
 	ch->flags |= (XPC_C_OPENREQUEST | XPC_C_CONNECTING);
@@ -1173,7 +1136,6 @@ xpc_connect_channel(struct xpc_channel *
 	return xpSuccess;
 }
 
-
 /*
  * Clear some of the msg flags in the local message queue.
  */
@@ -1183,16 +1145,15 @@ xpc_clear_local_msgqueue_flags(struct xp
 	struct xpc_msg *msg;
 	s64 get;
 
-
 	get = ch->w_remote_GP.get;
 	do {
-		msg = (struct xpc_msg *) ((u64) ch->local_msgqueue +
-				(get % ch->local_nentries) * ch->msg_size);
+		msg = (struct xpc_msg *)((u64)ch->local_msgqueue +
+					 (get % ch->local_nentries) *
+					 ch->msg_size);
 		msg->flags = 0;
-	} while (++get < (volatile s64) ch->remote_GP.get);
+	} while (++get < (volatile s64)ch->remote_GP.get);
 }
 
-
 /*
  * Clear some of the msg flags in the remote message queue.
  */
@@ -1202,43 +1163,39 @@ xpc_clear_remote_msgqueue_flags(struct x
 	struct xpc_msg *msg;
 	s64 put;
 
-
 	put = ch->w_remote_GP.put;
 	do {
-		msg = (struct xpc_msg *) ((u64) ch->remote_msgqueue +
-				(put % ch->remote_nentries) * ch->msg_size);
+		msg = (struct xpc_msg *)((u64)ch->remote_msgqueue +
+					 (put % ch->remote_nentries) *
+					 ch->msg_size);
 		msg->flags = 0;
-	} while (++put < (volatile s64) ch->remote_GP.put);
+	} while (++put < (volatile s64)ch->remote_GP.put);
 }
 
-
 static void
 xpc_process_msg_IPI(struct xpc_partition *part, int ch_number)
 {
 	struct xpc_channel *ch = &part->channels[ch_number];
 	int nmsgs_sent;
 
-
 	ch->remote_GP = part->remote_GPs[ch_number];
 
-
 	/* See what, if anything, has changed for each connected channel */
 
 	xpc_msgqueue_ref(ch);
 
 	if (ch->w_remote_GP.get == ch->remote_GP.get &&
-				ch->w_remote_GP.put == ch->remote_GP.put) {
+	    ch->w_remote_GP.put == ch->remote_GP.put) {
 		/* nothing changed since GPs were last pulled */
 		xpc_msgqueue_deref(ch);
 		return;
 	}
 
-	if (!(ch->flags & XPC_C_CONNECTED)){
+	if (!(ch->flags & XPC_C_CONNECTED)) {
 		xpc_msgqueue_deref(ch);
 		return;
 	}
 
-
 	/*
 	 * First check to see if messages recently sent by us have been
 	 * received by the other side. (The remote GET value will have
@@ -1260,7 +1217,7 @@ xpc_process_msg_IPI(struct xpc_partition
 			 * received and delivered by the other side.
 			 */
 			xpc_notify_senders(ch, xpMsgDelivered,
-							ch->remote_GP.get);
+					   ch->remote_GP.get);
 		}
 
 		/*
@@ -1284,7 +1241,6 @@ xpc_process_msg_IPI(struct xpc_partition
 		}
 	}
 
-
 	/*
 	 * Now check for newly sent messages by the other side. (The remote
 	 * PUT value will have changed since we last looked at it.)
@@ -1318,7 +1274,6 @@ xpc_process_msg_IPI(struct xpc_partition
 	xpc_msgqueue_deref(ch);
 }
 
-
 void
 xpc_process_channel_activity(struct xpc_partition *part)
 {
@@ -1328,7 +1283,6 @@ xpc_process_channel_activity(struct xpc_
 	int ch_number;
 	u32 ch_flags;
 
-
 	IPI_amo = xpc_get_IPI_flags(part);
 
 	/*
@@ -1341,7 +1295,6 @@ xpc_process_channel_activity(struct xpc_
 	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
 		ch = &part->channels[ch_number];
 
-
 		/*
 		 * Process any open or close related IPI flags, and then deal
 		 * with connecting or disconnecting the channel as required.
@@ -1369,7 +1322,7 @@ xpc_process_channel_activity(struct xpc_
 		if (!(ch_flags & XPC_C_CONNECTED)) {
 			if (!(ch_flags & XPC_C_OPENREQUEST)) {
 				DBUG_ON(ch_flags & XPC_C_SETUP);
-				(void) xpc_connect_channel(ch);
+				(void)xpc_connect_channel(ch);
 			} else {
 				spin_lock_irqsave(&ch->lock, irq_flags);
 				xpc_process_connect(ch, &irq_flags);
@@ -1378,7 +1331,6 @@ xpc_process_channel_activity(struct xpc_
 			continue;
 		}
 
-
 		/*
 		 * Process any message related IPI flags, this may involve the
 		 * activation of kthreads to deliver any pending messages sent
@@ -1391,7 +1343,6 @@ xpc_process_channel_activity(struct xpc_
 	}
 }
 
-
 /*
  * XPC's heartbeat code calls this function to inform XPC that a partition is
  * going down.  XPC responds by tearing down the XPartition Communication
@@ -1408,7 +1359,6 @@ xpc_partition_going_down(struct xpc_part
 	int ch_number;
 	struct xpc_channel *ch;
 
-
 	dev_dbg(xpc_chan, "deactivating partition %d, reason=%d\n",
 		XPC_PARTID(part), reason);
 
@@ -1417,7 +1367,6 @@ xpc_partition_going_down(struct xpc_part
 		return;
 	}
 
-
 	/* disconnect channels associated with the partition going down */
 
 	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
@@ -1437,7 +1386,6 @@ xpc_partition_going_down(struct xpc_part
 	xpc_part_deref(part);
 }
 
-
 /*
  * Teardown the infrastructure necessary to support XPartition Communication
  * between the specified remote partition and the local one.
@@ -1447,7 +1395,6 @@ xpc_teardown_infrastructure(struct xpc_p
 {
 	short partid = XPC_PARTID(part);
 
-
 	/*
 	 * We start off by making this partition inaccessible to local
 	 * processes by marking it as no longer setup. Then we make it
@@ -1464,9 +1411,7 @@ xpc_teardown_infrastructure(struct xpc_p
 
 	xpc_vars_part[partid].magic = 0;
 
-
-	free_irq(SGI_XPC_NOTIFY, (void *) (u64) partid);
-
+	free_irq(SGI_XPC_NOTIFY, (void *)(u64)partid);
 
 	/*
 	 * Before proceeding with the teardown we have to wait until all
@@ -1474,7 +1419,6 @@ xpc_teardown_infrastructure(struct xpc_p
 	 */
 	wait_event(part->teardown_wq, (atomic_read(&part->references) == 0));
 
-
 	/* now we can begin tearing down the infrastructure */
 
 	part->setup_state = XPC_P_SS_TORNDOWN;
@@ -1495,7 +1439,6 @@ xpc_teardown_infrastructure(struct xpc_p
 	part->local_IPI_amo_va = NULL;
 }
 
-
 /*
  * Called by XP at the time of channel connection registration to cause
  * XPC to establish connections to all currently active partitions.
@@ -1507,7 +1450,6 @@ xpc_initiate_connect(int ch_number)
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
-
 	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
 
 	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
@@ -1526,7 +1468,6 @@ xpc_initiate_connect(int ch_number)
 	}
 }
 
-
 void
 xpc_connected_callout(struct xpc_channel *ch)
 {
@@ -1537,14 +1478,13 @@ xpc_connected_callout(struct xpc_channel
 			"partid=%d, channel=%d\n", ch->partid, ch->number);
 
 		ch->func(xpConnected, ch->partid, ch->number,
-				(void *) (u64) ch->local_nentries, ch->key);
+			 (void *)(u64)ch->local_nentries, ch->key);
 
 		dev_dbg(xpc_chan, "ch->func() returned, reason=xpConnected, "
 			"partid=%d, channel=%d\n", ch->partid, ch->number);
 	}
 }
 
-
 /*
  * Called by XP at the time of channel connection unregistration to cause
  * XPC to teardown all current connections for the specified channel.
@@ -1566,7 +1506,6 @@ xpc_initiate_disconnect(int ch_number)
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
-
 	DBUG_ON(ch_number < 0 || ch_number >= XPC_NCHANNELS);
 
 	/* initiate the channel disconnect for every active partition */
@@ -1583,7 +1522,7 @@ xpc_initiate_disconnect(int ch_number)
 				ch->flags |= XPC_C_WDISCONNECT;
 
 				XPC_DISCONNECT_CHANNEL(ch, xpUnregistering,
-								&irq_flags);
+						       &irq_flags);
 			}
 
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
@@ -1596,7 +1535,6 @@ xpc_initiate_disconnect(int ch_number)
 	xpc_disconnect_wait(ch_number);
 }
 
-
 /*
  * To disconnect a channel, and reflect it back to all who may be waiting.
  *
@@ -1608,11 +1546,10 @@ xpc_initiate_disconnect(int ch_number)
  */
 void
 xpc_disconnect_channel(const int line, struct xpc_channel *ch,
-			enum xp_retval reason, unsigned long *irq_flags)
+		       enum xp_retval reason, unsigned long *irq_flags)
 {
 	u32 channel_was_connected = (ch->flags & XPC_C_CONNECTED);
 
-
 	DBUG_ON(!spin_is_locked(&ch->lock));
 
 	if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED)) {
@@ -1628,8 +1565,8 @@ xpc_disconnect_channel(const int line, s
 	ch->flags |= (XPC_C_CLOSEREQUEST | XPC_C_DISCONNECTING);
 	/* some of these may not have been set */
 	ch->flags &= ~(XPC_C_OPENREQUEST | XPC_C_OPENREPLY |
-			XPC_C_ROPENREQUEST | XPC_C_ROPENREPLY |
-			XPC_C_CONNECTING | XPC_C_CONNECTED);
+		       XPC_C_ROPENREQUEST | XPC_C_ROPENREPLY |
+		       XPC_C_CONNECTING | XPC_C_CONNECTED);
 
 	xpc_IPI_send_closerequest(ch, irq_flags);
 
@@ -1644,7 +1581,7 @@ xpc_disconnect_channel(const int line, s
 		wake_up_all(&ch->idle_wq);
 
 	} else if ((ch->flags & XPC_C_CONNECTEDCALLOUT_MADE) &&
-			!(ch->flags & XPC_C_DISCONNECTINGCALLOUT)) {
+		   !(ch->flags & XPC_C_DISCONNECTINGCALLOUT)) {
 		/* start a kthread that will do the xpDisconnecting callout */
 		xpc_create_kthreads(ch, 1, 1);
 	}
@@ -1657,7 +1594,6 @@ xpc_disconnect_channel(const int line, s
 	spin_lock_irqsave(&ch->lock, *irq_flags);
 }
 
-
 void
 xpc_disconnect_callout(struct xpc_channel *ch, enum xp_retval reason)
 {
@@ -1678,7 +1614,6 @@ xpc_disconnect_callout(struct xpc_channe
 	}
 }
 
-
 /*
  * Wait for a message entry to become available for the specified channel,
  * but don't wait any longer than 1 jiffy.
@@ -1688,7 +1623,6 @@ xpc_allocate_msg_wait(struct xpc_channel
 {
 	enum xp_retval ret;
 
-
 	if (ch->flags & XPC_C_DISCONNECTING) {
 		DBUG_ON(ch->reason == xpInterrupted);
 		return ch->reason;
@@ -1710,20 +1644,18 @@ xpc_allocate_msg_wait(struct xpc_channel
 	return ret;
 }
 
-
 /*
  * Allocate an entry for a message from the message queue associated with the
  * specified channel.
  */
 static enum xp_retval
 xpc_allocate_msg(struct xpc_channel *ch, u32 flags,
-			struct xpc_msg **address_of_msg)
+		 struct xpc_msg **address_of_msg)
 {
 	struct xpc_msg *msg;
 	enum xp_retval ret;
 	s64 put;
 
-
 	/* this reference will be dropped in xpc_send_msg() */
 	xpc_msgqueue_ref(ch);
 
@@ -1736,7 +1668,6 @@ xpc_allocate_msg(struct xpc_channel *ch,
 		return xpNotConnected;
 	}
 
-
 	/*
 	 * Get the next available message entry from the local message queue.
 	 * If none are available, we'll make sure that we grab the latest
@@ -1746,9 +1677,9 @@ xpc_allocate_msg(struct xpc_channel *ch,
 
 	while (1) {
 
-		put = (volatile s64) ch->w_local_GP.put;
-		if (put - (volatile s64) ch->w_remote_GP.get <
-							ch->local_nentries) {
+		put = (volatile s64)ch->w_local_GP.put;
+		if (put - (volatile s64)ch->w_remote_GP.get <
+		    ch->local_nentries) {
 
 			/* There are available message entries. We need to try
 			 * to secure one for ourselves. We'll do this by trying
@@ -1756,15 +1687,13 @@ xpc_allocate_msg(struct xpc_channel *ch,
 			 * doesn't beat us to it. If they do, we'll have to
 			 * try again.
 			 */
-			if (cmpxchg(&ch->w_local_GP.put, put, put + 1) ==
-									put) {
+			if (cmpxchg(&ch->w_local_GP.put, put, put + 1) == put) {
 				/* we got the entry referenced by put */
 				break;
 			}
 			continue;	/* try again */
 		}
 
-
 		/*
 		 * There aren't any available msg entries at this time.
 		 *
@@ -1790,25 +1719,22 @@ xpc_allocate_msg(struct xpc_channel *ch,
 		}
 	}
 
-
 	/* get the message's address and initialize it */
-	msg = (struct xpc_msg *) ((u64) ch->local_msgqueue +
-				(put % ch->local_nentries) * ch->msg_size);
-
+	msg = (struct xpc_msg *)((u64)ch->local_msgqueue +
+				 (put % ch->local_nentries) * ch->msg_size);
 
 	DBUG_ON(msg->flags != 0);
 	msg->number = put;
 
 	dev_dbg(xpc_chan, "w_local_GP.put changed to %" U64_ELL "d; msg=0x%p, "
 		"msg_number=%" U64_ELL "d, partid=%d, channel=%d\n", put + 1,
-		(void *) msg, msg->number, ch->partid, ch->number);
+		(void *)msg, msg->number, ch->partid, ch->number);
 
 	*address_of_msg = msg;
 
 	return xpSuccess;
 }
 
-
 /*
  * Allocate an entry for a message from the message queue associated with the
  * specified channel. NOTE that this routine can sleep waiting for a message
@@ -1829,7 +1755,6 @@ xpc_initiate_allocate(short partid, int 
 	enum xp_retval ret = xpUnknownReason;
 	struct xpc_msg *msg = NULL;
 
-
 	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 
@@ -1847,7 +1772,6 @@ xpc_initiate_allocate(short partid, int 
 	return ret;
 }
 
-
 /*
  * Now we actually send the messages that are ready to be sent by advancing
  * the local message queue's Put value and then send an IPI to the recipient
@@ -1860,16 +1784,16 @@ xpc_send_msgs(struct xpc_channel *ch, s6
 	s64 put = initial_put + 1;
 	int send_IPI = 0;
 
-
 	while (1) {
 
 		while (1) {
-			if (put == (volatile s64) ch->w_local_GP.put) {
+			if (put == (volatile s64)ch->w_local_GP.put) {
 				break;
 			}
 
-			msg = (struct xpc_msg *) ((u64) ch->local_msgqueue +
-			       (put % ch->local_nentries) * ch->msg_size);
+			msg = (struct xpc_msg *)((u64)ch->local_msgqueue +
+						 (put % ch->local_nentries) *
+						 ch->msg_size);
 
 			if (!(msg->flags & XPC_M_READY)) {
 				break;
@@ -1884,9 +1808,9 @@ xpc_send_msgs(struct xpc_channel *ch, s6
 		}
 
 		if (cmpxchg_rel(&ch->local_GP->put, initial_put, put) !=
-								initial_put) {
+		    initial_put) {
 			/* someone else beat us to it */
-			DBUG_ON((volatile s64) ch->local_GP->put < initial_put);
+			DBUG_ON((volatile s64)ch->local_GP->put < initial_put);
 			break;
 		}
 
@@ -1910,7 +1834,6 @@ xpc_send_msgs(struct xpc_channel *ch, s6
 	}
 }
 
-
 /*
  * Common code that does the actual sending of the message by advancing the
  * local message queue's Put value and sends an IPI to the partition the
@@ -1918,16 +1841,15 @@ xpc_send_msgs(struct xpc_channel *ch, s6
  */
 static enum xp_retval
 xpc_send_msg(struct xpc_channel *ch, struct xpc_msg *msg, u8 notify_type,
-			xpc_notify_func func, void *key)
+	     xpc_notify_func func, void *key)
 {
 	enum xp_retval ret = xpSuccess;
 	struct xpc_notify *notify = notify;
 	s64 put, msg_number = msg->number;
 
-
 	DBUG_ON(notify_type == XPC_N_CALL && func == NULL);
-	DBUG_ON((((u64) msg - (u64) ch->local_msgqueue) / ch->msg_size) !=
-					msg_number % ch->local_nentries);
+	DBUG_ON((((u64)msg - (u64)ch->local_msgqueue) / ch->msg_size) !=
+		msg_number % ch->local_nentries);
 	DBUG_ON(msg->flags & XPC_M_READY);
 
 	if (ch->flags & XPC_C_DISCONNECTING) {
@@ -1961,7 +1883,7 @@ xpc_send_msg(struct xpc_channel *ch, str
 			 * the notify entry.
 			 */
 			if (cmpxchg(&notify->type, notify_type, 0) ==
-								notify_type) {
+			    notify_type) {
 				atomic_dec(&ch->n_to_notify);
 				ret = ch->reason;
 			}
@@ -1992,7 +1914,6 @@ xpc_send_msg(struct xpc_channel *ch, str
 	return ret;
 }
 
-
 /*
  * Send a message previously allocated using xpc_initiate_allocate() on the
  * specified channel connected to the specified partition.
@@ -2020,8 +1941,7 @@ xpc_initiate_send(short partid, int ch_n
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
 	enum xp_retval ret;
 
-
-	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *) msg,
+	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *)msg,
 		partid, ch_number);
 
 	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
@@ -2033,7 +1953,6 @@ xpc_initiate_send(short partid, int ch_n
 	return ret;
 }
 
-
 /*
  * Send a message previously allocated using xpc_initiate_allocate on the
  * specified channel connected to the specified partition.
@@ -2066,14 +1985,13 @@ xpc_initiate_send(short partid, int ch_n
  */
 enum xp_retval
 xpc_initiate_send_notify(short partid, int ch_number, void *payload,
-				xpc_notify_func func, void *key)
+			 xpc_notify_func func, void *key)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
 	enum xp_retval ret;
 
-
-	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *) msg,
+	dev_dbg(xpc_chan, "msg=0x%p, partid=%d, channel=%d\n", (void *)msg,
 		partid, ch_number);
 
 	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
@@ -2082,11 +2000,10 @@ xpc_initiate_send_notify(short partid, i
 	DBUG_ON(func == NULL);
 
 	ret = xpc_send_msg(&part->channels[ch_number], msg, XPC_N_CALL,
-								func, key);
+			   func, key);
 	return ret;
 }
 
-
 static struct xpc_msg *
 xpc_pull_remote_msg(struct xpc_channel *ch, s64 get)
 {
@@ -2096,7 +2013,6 @@ xpc_pull_remote_msg(struct xpc_channel *
 	u64 msg_offset;
 	enum xp_retval ret;
 
-
 	if (mutex_lock_interruptible(&ch->msg_to_pull_mutex) != 0) {
 		/* we were interrupted by a signal */
 		return NULL;
@@ -2109,22 +2025,22 @@ xpc_pull_remote_msg(struct xpc_channel *
 		msg_index = ch->next_msg_to_pull % ch->remote_nentries;
 
 		DBUG_ON(ch->next_msg_to_pull >=
-					(volatile s64) ch->w_remote_GP.put);
-		nmsgs =  (volatile s64) ch->w_remote_GP.put -
-						ch->next_msg_to_pull;
+			(volatile s64)ch->w_remote_GP.put);
+		nmsgs = (volatile s64)ch->w_remote_GP.put -
+		    ch->next_msg_to_pull;
 		if (msg_index + nmsgs > ch->remote_nentries) {
 			/* ignore the ones that wrap the msg queue for now */
 			nmsgs = ch->remote_nentries - msg_index;
 		}
 
 		msg_offset = msg_index * ch->msg_size;
-		msg = (struct xpc_msg *) ((u64) ch->remote_msgqueue +
-								msg_offset);
-		remote_msg = (struct xpc_msg *) (ch->remote_msgqueue_pa +
-								msg_offset);
+		msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
+		remote_msg = (struct xpc_msg *)(ch->remote_msgqueue_pa +
+						msg_offset);
 
 		if ((ret = xpc_pull_remote_cachelines(part, msg, remote_msg,
-				nmsgs * ch->msg_size)) != xpSuccess) {
+						      nmsgs * ch->msg_size)) !=
+		    xpSuccess) {
 
 			dev_dbg(xpc_chan, "failed to pull %d msgs starting with"
 				" msg %" U64_ELL "d from partition %d, "
@@ -2138,7 +2054,7 @@ xpc_pull_remote_msg(struct xpc_channel *
 			return NULL;
 		}
 
-		mb();	/* >>> this may not be needed, we're not sure */
+		mb();		/* >>> this may not be needed, we're not sure */
 
 		ch->next_msg_to_pull += nmsgs;
 	}
@@ -2147,12 +2063,11 @@ xpc_pull_remote_msg(struct xpc_channel *
 
 	/* return the message we were looking for */
 	msg_offset = (get % ch->remote_nentries) * ch->msg_size;
-	msg = (struct xpc_msg *) ((u64) ch->remote_msgqueue + msg_offset);
+	msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
 
 	return msg;
 }
 
-
 /*
  * Get a message to be delivered.
  */
@@ -2162,14 +2077,13 @@ xpc_get_deliverable_msg(struct xpc_chann
 	struct xpc_msg *msg = NULL;
 	s64 get;
 
-
 	do {
-		if ((volatile u32) ch->flags & XPC_C_DISCONNECTING) {
+		if ((volatile u32)ch->flags & XPC_C_DISCONNECTING) {
 			break;
 		}
 
-		get = (volatile s64) ch->w_local_GP.get;
-		if (get == (volatile s64) ch->w_remote_GP.put) {
+		get = (volatile s64)ch->w_local_GP.get;
+		if (get == (volatile s64)ch->w_remote_GP.put) {
 			break;
 		}
 
@@ -2203,7 +2117,6 @@ xpc_get_deliverable_msg(struct xpc_chann
 	return msg;
 }
 
-
 /*
  * Deliver a message to its intended recipient.
  */
@@ -2212,7 +2125,6 @@ xpc_deliver_msg(struct xpc_channel *ch)
 {
 	struct xpc_msg *msg;
 
-
 	if ((msg = xpc_get_deliverable_msg(ch)) != NULL) {
 
 		/*
@@ -2227,16 +2139,16 @@ xpc_deliver_msg(struct xpc_channel *ch)
 		if (ch->func != NULL) {
 			dev_dbg(xpc_chan, "ch->func() called, msg=0x%p, "
 				"msg_number=%" U64_ELL "d, partid=%d, "
-				"channel=%d\n", (void *) msg, msg->number,
+				"channel=%d\n", (void *)msg, msg->number,
 				ch->partid, ch->number);
 
 			/* deliver the message to its intended recipient */
 			ch->func(xpMsgReceived, ch->partid, ch->number,
-					&msg->payload, ch->key);
+				 &msg->payload, ch->key);
 
 			dev_dbg(xpc_chan, "ch->func() returned, msg=0x%p, "
 				"msg_number=%" U64_ELL "d, partid=%d, "
-				"channel=%d\n", (void *) msg, msg->number,
+				"channel=%d\n", (void *)msg, msg->number,
 				ch->partid, ch->number);
 		}
 
@@ -2244,7 +2156,6 @@ xpc_deliver_msg(struct xpc_channel *ch)
 	}
 }
 
-
 /*
  * Now we actually acknowledge the messages that have been delivered and ack'd
  * by advancing the cached remote message queue's Get value and if requested
@@ -2257,16 +2168,16 @@ xpc_acknowledge_msgs(struct xpc_channel 
 	s64 get = initial_get + 1;
 	int send_IPI = 0;
 
-
 	while (1) {
 
 		while (1) {
-			if (get == (volatile s64) ch->w_local_GP.get) {
+			if (get == (volatile s64)ch->w_local_GP.get) {
 				break;
 			}
 
-			msg = (struct xpc_msg *) ((u64) ch->remote_msgqueue +
-			       (get % ch->remote_nentries) * ch->msg_size);
+			msg = (struct xpc_msg *)((u64)ch->remote_msgqueue +
+						 (get % ch->remote_nentries) *
+						 ch->msg_size);
 
 			if (!(msg->flags & XPC_M_DONE)) {
 				break;
@@ -2282,10 +2193,9 @@ xpc_acknowledge_msgs(struct xpc_channel 
 		}
 
 		if (cmpxchg_rel(&ch->local_GP->get, initial_get, get) !=
-								initial_get) {
+		    initial_get) {
 			/* someone else beat us to it */
-			DBUG_ON((volatile s64) ch->local_GP->get <=
-								initial_get);
+			DBUG_ON((volatile s64)ch->local_GP->get <= initial_get);
 			break;
 		}
 
@@ -2309,7 +2219,6 @@ xpc_acknowledge_msgs(struct xpc_channel 
 	}
 }
 
-
 /*
  * Acknowledge receipt of a delivered message.
  *
@@ -2335,18 +2244,17 @@ xpc_initiate_received(short partid, int 
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
 	s64 get, msg_number = msg->number;
 
-
 	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 	DBUG_ON(ch_number < 0 || ch_number >= part->nchannels);
 
 	ch = &part->channels[ch_number];
 
 	dev_dbg(xpc_chan, "msg=0x%p, msg_number=%" U64_ELL "d, partid=%d, "
-		"channel=%d\n", (void *) msg, msg_number, ch->partid,
+		"channel=%d\n", (void *)msg, msg_number, ch->partid,
 		ch->number);
 
-	DBUG_ON((((u64) msg - (u64) ch->remote_msgqueue) / ch->msg_size) !=
-					msg_number % ch->remote_nentries);
+	DBUG_ON((((u64)msg - (u64)ch->remote_msgqueue) / ch->msg_size) !=
+		msg_number % ch->remote_nentries);
 	DBUG_ON(msg->flags & XPC_M_DONE);
 
 	msg->flags |= XPC_M_DONE;
@@ -2369,4 +2277,3 @@ xpc_initiate_received(short partid, int 
 	/* the call to xpc_msgqueue_ref() was done by xpc_deliver_msg()  */
 	xpc_msgqueue_deref(ch);
 }
-
Index: linux-2.6/drivers/misc/xp/xpc_main.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpc_main.c	2008-03-26 10:41:52.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xpc_main.c	2008-03-26 10:57:58.932020103 -0500
@@ -6,7 +6,6 @@
  * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
-
 /*
  * Cross Partition Communication (XPC) support - standard version.
  *
@@ -44,7 +43,6 @@
  *
  */
 
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -67,7 +65,6 @@
 #include <asm/uaccess.h>
 #include "xpc.h"
 
-
 /* define two XPC debug device structures to be used with dev_dbg() et al */
 
 struct device_driver xpc_dbg_name = {
@@ -87,10 +84,8 @@ struct device xpc_chan_dbg_subname = {
 struct device *xpc_part = &xpc_part_dbg_subname;
 struct device *xpc_chan = &xpc_chan_dbg_subname;
 
-
 static int xpc_kdebug_ignore;
 
-
 /* systune related variables for /proc/sys directories */
 
 static int xpc_hb_interval = XPC_HB_DEFAULT_INTERVAL;
@@ -107,56 +102,51 @@ static int xpc_disengage_request_max_tim
 
 static ctl_table xpc_sys_xpc_hb_dir[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "hb_interval",
-		.data		= &xpc_hb_interval,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &xpc_hb_min_interval,
-		.extra2		= &xpc_hb_max_interval
-	},
+	 .ctl_name = CTL_UNNUMBERED,
+	 .procname = "hb_interval",
+	 .data = &xpc_hb_interval,
+	 .maxlen = sizeof(int),
+	 .mode = 0644,
+	 .proc_handler = &proc_dointvec_minmax,
+	 .strategy = &sysctl_intvec,
+	 .extra1 = &xpc_hb_min_interval,
+	 .extra2 = &xpc_hb_max_interval},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "hb_check_interval",
-		.data		= &xpc_hb_check_interval,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &xpc_hb_check_min_interval,
-		.extra2		= &xpc_hb_check_max_interval
-	},
+	 .ctl_name = CTL_UNNUMBERED,
+	 .procname = "hb_check_interval",
+	 .data = &xpc_hb_check_interval,
+	 .maxlen = sizeof(int),
+	 .mode = 0644,
+	 .proc_handler = &proc_dointvec_minmax,
+	 .strategy = &sysctl_intvec,
+	 .extra1 = &xpc_hb_check_min_interval,
+	 .extra2 = &xpc_hb_check_max_interval},
 	{}
 };
 static ctl_table xpc_sys_xpc_dir[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "hb",
-		.mode		= 0555,
-		.child		= xpc_sys_xpc_hb_dir
-	},
+	 .ctl_name = CTL_UNNUMBERED,
+	 .procname = "hb",
+	 .mode = 0555,
+	 .child = xpc_sys_xpc_hb_dir},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "disengage_request_timelimit",
-		.data		= &xpc_disengage_request_timelimit,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &xpc_disengage_request_min_timelimit,
-		.extra2		= &xpc_disengage_request_max_timelimit
-	},
+	 .ctl_name = CTL_UNNUMBERED,
+	 .procname = "disengage_request_timelimit",
+	 .data = &xpc_disengage_request_timelimit,
+	 .maxlen = sizeof(int),
+	 .mode = 0644,
+	 .proc_handler = &proc_dointvec_minmax,
+	 .strategy = &sysctl_intvec,
+	 .extra1 = &xpc_disengage_request_min_timelimit,
+	 .extra2 = &xpc_disengage_request_max_timelimit},
 	{}
 };
 static ctl_table xpc_sys_dir[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "xpc",
-		.mode		= 0555,
-		.child		= xpc_sys_xpc_dir
-	},
+	 .ctl_name = CTL_UNNUMBERED,
+	 .procname = "xpc",
+	 .mode = 0555,
+	 .child = xpc_sys_xpc_dir},
 	{}
 };
 static struct ctl_table_header *xpc_sysctl;
@@ -178,13 +168,10 @@ static DECLARE_COMPLETION(xpc_hb_checker
 /* notification that the xpc_discovery thread has exited */
 static DECLARE_COMPLETION(xpc_discovery_exited);
 
-
 static struct timer_list xpc_hb_timer;
 
-
 static void xpc_kthread_waitmsgs(struct xpc_partition *, struct xpc_channel *);
 
-
 static int xpc_system_reboot(struct notifier_block *, unsigned long, void *);
 static struct notifier_block xpc_reboot_notifier = {
 	.notifier_call = xpc_system_reboot,
@@ -195,25 +182,22 @@ static struct notifier_block xpc_die_not
 	.notifier_call = xpc_system_die,
 };
 
-
 /*
  * Timer function to enforce the timelimit on the partition disengage request.
  */
 static void
 xpc_timeout_partition_disengage_request(unsigned long data)
 {
-	struct xpc_partition *part = (struct xpc_partition *) data;
-
+	struct xpc_partition *part = (struct xpc_partition *)data;
 
 	DBUG_ON(jiffies < part->disengage_request_timeout);
 
-	(void) xpc_partition_disengaged(part);
+	(void)xpc_partition_disengaged(part);
 
 	DBUG_ON(part->disengage_request_timeout != 0);
 	DBUG_ON(xpc_partition_engaged(XPC_PARTID(part)) != 0);
 }
 
-
 /*
  * Notify the heartbeat check thread that an IRQ has been received.
  */
@@ -225,7 +209,6 @@ xpc_act_IRQ_handler(int irq, void *dev_i
 	return IRQ_HANDLED;
 }
 
-
 /*
  * Timer to produce the heartbeat.  The timer structures function is
  * already set when this is initially called.  A tunable is used to
@@ -244,7 +227,6 @@ xpc_hb_beater(unsigned long dummy)
 	add_timer(&xpc_hb_timer);
 }
 
-
 /*
  * This thread is responsible for nearly all of the partition
  * activation/deactivation.
@@ -254,8 +236,7 @@ xpc_hb_checker(void *ignore)
 {
 	int last_IRQ_count = 0;
 	int new_IRQ_count;
-	int force_IRQ=0;
-
+	int force_IRQ = 0;
 
 	/* this thread was marked active by xpc_hb_init() */
 
@@ -267,14 +248,13 @@ xpc_hb_checker(void *ignore)
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
 	xpc_hb_beater(0);
 
-	while (!(volatile int) xpc_exiting) {
+	while (!(volatile int)xpc_exiting) {
 
 		dev_dbg(xpc_part, "woke up with %d ticks rem; %d IRQs have "
 			"been received\n",
-			(int) (xpc_hb_check_timeout - jiffies),
+			(int)(xpc_hb_check_timeout - jiffies),
 			atomic_read(&xpc_act_IRQ_rcvd) - last_IRQ_count);
 
-
 		/* checking of remote heartbeats is skewed by IRQ handling */
 		if (jiffies >= xpc_hb_check_timeout) {
 			dev_dbg(xpc_part, "checking remote heartbeats\n");
@@ -288,7 +268,6 @@ xpc_hb_checker(void *ignore)
 			force_IRQ = 1;
 		}
 
-
 		/* check for outstanding IRQs */
 		new_IRQ_count = atomic_read(&xpc_act_IRQ_rcvd);
 		if (last_IRQ_count < new_IRQ_count || force_IRQ != 0) {
@@ -300,30 +279,30 @@ xpc_hb_checker(void *ignore)
 			last_IRQ_count += xpc_identify_act_IRQ_sender();
 			if (last_IRQ_count < new_IRQ_count) {
 				/* retry once to help avoid missing AMO */
-				(void) xpc_identify_act_IRQ_sender();
+				(void)xpc_identify_act_IRQ_sender();
 			}
 			last_IRQ_count = new_IRQ_count;
 
 			xpc_hb_check_timeout = jiffies +
-					   (xpc_hb_check_interval * HZ);
+			    (xpc_hb_check_interval * HZ);
 		}
 
 		/* wait for IRQ or timeout */
-		(void) wait_event_interruptible(xpc_act_IRQ_wq,
-			    (last_IRQ_count < atomic_read(&xpc_act_IRQ_rcvd) ||
-					jiffies >= xpc_hb_check_timeout ||
-						(volatile int) xpc_exiting));
+		(void)wait_event_interruptible(xpc_act_IRQ_wq,
+					       (last_IRQ_count <
+						atomic_read(&xpc_act_IRQ_rcvd)
+						|| jiffies >=
+						xpc_hb_check_timeout
+						|| (volatile int)xpc_exiting));
 	}
 
 	dev_dbg(xpc_part, "heartbeat checker is exiting\n");
 
-
 	/* mark this thread as having exited */
 	complete(&xpc_hb_checker_exited);
 	return 0;
 }
 
-
 /*
  * This thread will attempt to discover other partitions to activate
  * based on info provided by SAL. This new thread is short lived and
@@ -343,7 +322,6 @@ xpc_initiate_discovery(void *ignore)
 	return 0;
 }
 
-
 /*
  * Establish first contact with the remote partititon. This involves pulling
  * the XPC per partition variables from the remote partition and waiting for
@@ -354,7 +332,6 @@ xpc_make_first_contact(struct xpc_partit
 {
 	enum xp_retval ret;
 
-
 	while ((ret = xpc_pull_remote_vars_part(part)) != xpSuccess) {
 		if (ret != xpRetry) {
 			XPC_DEACTIVATE_PARTITION(part, ret);
@@ -365,7 +342,7 @@ xpc_make_first_contact(struct xpc_partit
 			"partition %d\n", XPC_PARTID(part));
 
 		/* wait a 1/4 of a second or so */
-		(void) msleep_interruptible(250);
+		(void)msleep_interruptible(250);
 
 		if (part->act_state == XPC_P_AS_DEACTIVATING) {
 			return part->reason;
@@ -375,7 +352,6 @@ xpc_make_first_contact(struct xpc_partit
 	return xpc_mark_partition_active(part);
 }
 
-
 /*
  * The first kthread assigned to a newly activated partition is the one
  * created by XPC HB with which it calls xpc_partition_up(). XPC hangs on to
@@ -392,12 +368,11 @@ static void
 xpc_channel_mgr(struct xpc_partition *part)
 {
 	while (part->act_state != XPC_P_AS_DEACTIVATING ||
-			atomic_read(&part->nchannels_active) > 0 ||
-					!xpc_partition_disengaged(part)) {
+	       atomic_read(&part->nchannels_active) > 0 ||
+	       !xpc_partition_disengaged(part)) {
 
 		xpc_process_channel_activity(part);
 
-
 		/*
 		 * Wait until we've been requested to activate kthreads or
 		 * all of the channel's message queues have been torn down or
@@ -412,18 +387,25 @@ xpc_channel_mgr(struct xpc_partition *pa
 		 * wake him up.
 		 */
 		atomic_dec(&part->channel_mgr_requests);
-		(void) wait_event_interruptible(part->channel_mgr_wq,
-				(atomic_read(&part->channel_mgr_requests) > 0 ||
-				(volatile u64) part->local_IPI_amo != 0 ||
-				((volatile u8) part->act_state ==
-							XPC_P_AS_DEACTIVATING &&
-				atomic_read(&part->nchannels_active) == 0 &&
-				xpc_partition_disengaged(part))));
+		(void)wait_event_interruptible(part->channel_mgr_wq,
+					       (atomic_read
+						(&part->channel_mgr_requests) >
+						0
+						|| (volatile u64)part->
+						local_IPI_amo != 0
+						|| ((volatile u8)part->
+						    act_state ==
+						    XPC_P_AS_DEACTIVATING
+						    && atomic_read(&part->
+								   nchannels_active)
+						    == 0
+						    &&
+						    xpc_partition_disengaged
+						    (part))));
 		atomic_set(&part->channel_mgr_requests, 1);
 	}
 }
 
-
 /*
  * When XPC HB determines that a partition has come up, it will create a new
  * kthread and that kthread will call this function to attempt to set up the
@@ -457,7 +439,7 @@ xpc_partition_up(struct xpc_partition *p
 	 * has been dismantled.
 	 */
 
-	(void) xpc_part_ref(part);	/* this will always succeed */
+	(void)xpc_part_ref(part);	/* this will always succeed */
 
 	if (xpc_make_first_contact(part) == xpSuccess) {
 		xpc_channel_mgr(part);
@@ -468,17 +450,15 @@ xpc_partition_up(struct xpc_partition *p
 	xpc_teardown_infrastructure(part);
 }
 
-
 static int
 xpc_activating(void *__partid)
 {
-	short partid = (u64) __partid;
+	short partid = (u64)__partid;
 	struct xpc_partition *part = &xpc_partitions[partid];
 	unsigned long irq_flags;
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
 	int ret;
 
-
 	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 
 	spin_lock_irqsave(&part->lock, irq_flags);
@@ -508,7 +488,7 @@ xpc_activating(void *__partid)
 	ret = sched_setscheduler(current, SCHED_FIFO, &param);
 	if (ret != 0) {
 		dev_warn(xpc_part, "unable to set pid %d to a realtime "
-			"priority, ret=%d\n", current->pid, ret);
+			 "priority, ret=%d\n", current->pid, ret);
 	}
 
 	/* allow this thread and its children to run on any CPU */
@@ -522,8 +502,7 @@ xpc_activating(void *__partid)
 	ret = xpc_register_remote_amos(part);
 	if (ret != xpSuccess) {
 		dev_warn(xpc_part, "xpc_activating() failed to register remote "
-				 "AMOs for partition %d, ret=%d\n", partid,
-				 ret);
+			 "AMOs for partition %d, ret=%d\n", partid, ret);
 
 		spin_lock_irqsave(&part->lock, irq_flags);
 		part->act_state = XPC_P_AS_INACTIVE;
@@ -536,7 +515,6 @@ xpc_activating(void *__partid)
 	xpc_allow_hb(partid, xpc_vars);
 	xpc_IPI_send_activated(part);
 
-
 	/*
 	 * xpc_partition_up() holds this thread and marks this partition as
 	 * XPC_P_AS_ACTIVE by calling xpc_hb_mark_active().
@@ -556,7 +534,6 @@ xpc_activating(void *__partid)
 	return 0;
 }
 
-
 void
 xpc_activate_partition(struct xpc_partition *part)
 {
@@ -564,7 +541,6 @@ xpc_activate_partition(struct xpc_partit
 	unsigned long irq_flags;
 	pid_t pid;
 
-
 	spin_lock_irqsave(&part->lock, irq_flags);
 
 	DBUG_ON(part->act_state != XPC_P_AS_INACTIVE);
@@ -574,7 +550,7 @@ xpc_activate_partition(struct xpc_partit
 
 	spin_unlock_irqrestore(&part->lock, irq_flags);
 
-	pid = kernel_thread(xpc_activating, (void *) ((u64) partid), 0);
+	pid = kernel_thread(xpc_activating, (void *)((u64)partid), 0);
 
 	if (unlikely(pid <= 0)) {
 		spin_lock_irqsave(&part->lock, irq_flags);
@@ -584,7 +560,6 @@ xpc_activate_partition(struct xpc_partit
 	}
 }
 
-
 /*
  * Handle the receipt of a SGI_XPC_NOTIFY IRQ by seeing whether the specified
  * partition actually sent it. Since SGI_XPC_NOTIFY IRQs may be shared by more
@@ -604,10 +579,9 @@ xpc_activate_partition(struct xpc_partit
 irqreturn_t
 xpc_notify_IRQ_handler(int irq, void *dev_id)
 {
-	short partid = (short) (u64) dev_id;
+	short partid = (short)(u64)dev_id;
 	struct xpc_partition *part = &xpc_partitions[partid];
 
-
 	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 
 	if (xpc_part_ref(part)) {
@@ -618,7 +592,6 @@ xpc_notify_IRQ_handler(int irq, void *de
 	return IRQ_HANDLED;
 }
 
-
 /*
  * Check to see if xpc_notify_IRQ_handler() dropped any IPIs on the floor
  * because the write to their associated IPI amo completed after the IRQ/IPI
@@ -631,13 +604,12 @@ xpc_dropped_IPI_check(struct xpc_partiti
 		xpc_check_for_channel_activity(part);
 
 		part->dropped_IPI_timer.expires = jiffies +
-						XPC_DROPPED_IPI_WAIT_INTERVAL;
+		    XPC_DROPPED_IPI_WAIT_INTERVAL;
 		add_timer(&part->dropped_IPI_timer);
 		xpc_part_deref(part);
 	}
 }
 
-
 void
 xpc_activate_kthreads(struct xpc_channel *ch, int needed)
 {
@@ -645,7 +617,6 @@ xpc_activate_kthreads(struct xpc_channel
 	int assigned = atomic_read(&ch->kthreads_assigned);
 	int wakeup;
 
-
 	DBUG_ON(needed <= 0);
 
 	if (idle > 0) {
@@ -676,7 +647,6 @@ xpc_activate_kthreads(struct xpc_channel
 	xpc_create_kthreads(ch, needed, 0);
 }
 
-
 /*
  * This function is where XPC's kthreads wait for messages to deliver.
  */
@@ -686,15 +656,14 @@ xpc_kthread_waitmsgs(struct xpc_partitio
 	do {
 		/* deliver messages to their intended recipients */
 
-		while ((volatile s64) ch->w_local_GP.get <
-				(volatile s64) ch->w_remote_GP.put &&
-					!((volatile u32) ch->flags &
-						XPC_C_DISCONNECTING)) {
+		while ((volatile s64)ch->w_local_GP.get <
+		       (volatile s64)ch->w_remote_GP.put &&
+		       !((volatile u32)ch->flags & XPC_C_DISCONNECTING)) {
 			xpc_deliver_msg(ch);
 		}
 
 		if (atomic_inc_return(&ch->kthreads_idle) >
-						ch->kthreads_idle_limit) {
+		    ch->kthreads_idle_limit) {
 			/* too many idle kthreads on this channel */
 			atomic_dec(&ch->kthreads_idle);
 			break;
@@ -703,18 +672,20 @@ xpc_kthread_waitmsgs(struct xpc_partitio
 		dev_dbg(xpc_chan, "idle kthread calling "
 			"wait_event_interruptible_exclusive()\n");
 
-		(void) wait_event_interruptible_exclusive(ch->idle_wq,
-				((volatile s64) ch->w_local_GP.get <
-					(volatile s64) ch->w_remote_GP.put ||
-				((volatile u32) ch->flags &
-						XPC_C_DISCONNECTING)));
+		(void)wait_event_interruptible_exclusive(ch->idle_wq,
+							 ((volatile s64)ch->
+							  w_local_GP.get <
+							  (volatile s64)ch->
+							  w_remote_GP.put
+							  || ((volatile u32)ch->
+							      flags &
+							      XPC_C_DISCONNECTING)));
 
 		atomic_dec(&ch->kthreads_idle);
 
-	} while (!((volatile u32) ch->flags & XPC_C_DISCONNECTING));
+	} while (!((volatile u32)ch->flags & XPC_C_DISCONNECTING));
 }
 
-
 static int
 xpc_daemonize_kthread(void *args)
 {
@@ -725,7 +696,6 @@ xpc_daemonize_kthread(void *args)
 	int n_needed;
 	unsigned long irq_flags;
 
-
 	daemonize("xpc%02dc%d", partid, ch_number);
 
 	dev_dbg(xpc_chan, "kthread starting, partid=%d, channel=%d\n",
@@ -756,8 +726,7 @@ xpc_daemonize_kthread(void *args)
 			 * need one less than total #of messages to deliver.
 			 */
 			n_needed = ch->w_remote_GP.put - ch->w_local_GP.get - 1;
-			if (n_needed > 0 &&
-					!(ch->flags & XPC_C_DISCONNECTING)) {
+			if (n_needed > 0 && !(ch->flags & XPC_C_DISCONNECTING)) {
 				xpc_activate_kthreads(ch, n_needed);
 			}
 		} else {
@@ -771,7 +740,7 @@ xpc_daemonize_kthread(void *args)
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
 	if ((ch->flags & XPC_C_CONNECTEDCALLOUT_MADE) &&
-			!(ch->flags & XPC_C_DISCONNECTINGCALLOUT)) {
+	    !(ch->flags & XPC_C_DISCONNECTINGCALLOUT)) {
 		ch->flags |= XPC_C_DISCONNECTINGCALLOUT;
 		spin_unlock_irqrestore(&ch->lock, irq_flags);
 
@@ -798,7 +767,6 @@ xpc_daemonize_kthread(void *args)
 	return 0;
 }
 
-
 /*
  * For each partition that XPC has established communications with, there is
  * a minimum of one kernel thread assigned to perform any operation that
@@ -813,14 +781,13 @@ xpc_daemonize_kthread(void *args)
  */
 void
 xpc_create_kthreads(struct xpc_channel *ch, int needed,
-			int ignore_disconnecting)
+		    int ignore_disconnecting)
 {
 	unsigned long irq_flags;
 	pid_t pid;
 	u64 args = XPC_PACK_ARGS(ch->partid, ch->number);
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 
-
 	while (needed-- > 0) {
 
 		/*
@@ -832,7 +799,7 @@ xpc_create_kthreads(struct xpc_channel *
 			if (!atomic_inc_not_zero(&ch->kthreads_assigned)) {
 				/* kthreads assigned had gone to zero */
 				BUG_ON(!(ch->flags &
-					XPC_C_DISCONNECTINGCALLOUT_MADE));
+					 XPC_C_DISCONNECTINGCALLOUT_MADE));
 				break;
 			}
 
@@ -843,10 +810,10 @@ xpc_create_kthreads(struct xpc_channel *
 			if (atomic_inc_return(&part->nchannels_engaged) == 1)
 				xpc_mark_partition_engaged(part);
 		}
-		(void) xpc_part_ref(part);
+		(void)xpc_part_ref(part);
 		xpc_msgqueue_ref(ch);
 
-		pid = kernel_thread(xpc_daemonize_kthread, (void *) args, 0);
+		pid = kernel_thread(xpc_daemonize_kthread, (void *)args, 0);
 		if (pid < 0) {
 			/* the fork failed */
 
@@ -869,7 +836,7 @@ xpc_create_kthreads(struct xpc_channel *
 			xpc_part_deref(part);
 
 			if (atomic_read(&ch->kthreads_assigned) <
-						ch->kthreads_idle_limit) {
+			    ch->kthreads_idle_limit) {
 				/*
 				 * Flag this as an error only if we have an
 				 * insufficient #of kthreads for the channel
@@ -877,7 +844,7 @@ xpc_create_kthreads(struct xpc_channel *
 				 */
 				spin_lock_irqsave(&ch->lock, irq_flags);
 				XPC_DISCONNECT_CHANNEL(ch, xpLackOfResources,
-								&irq_flags);
+						       &irq_flags);
 				spin_unlock_irqrestore(&ch->lock, irq_flags);
 			}
 			break;
@@ -885,7 +852,6 @@ xpc_create_kthreads(struct xpc_channel *
 	}
 }
 
-
 void
 xpc_disconnect_wait(int ch_number)
 {
@@ -895,7 +861,6 @@ xpc_disconnect_wait(int ch_number)
 	struct xpc_channel *ch;
 	int wakeup_channel_mgr;
 
-
 	/* now wait for all callouts to the caller's function to cease */
 	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 		part = &xpc_partitions[partid];
@@ -921,7 +886,8 @@ xpc_disconnect_wait(int ch_number)
 			if (part->act_state != XPC_P_AS_DEACTIVATING) {
 				spin_lock(&part->IPI_lock);
 				XPC_SET_IPI_FLAGS(part->local_IPI_amo,
-					ch->number, ch->delayed_IPI_flags);
+						  ch->number,
+						  ch->delayed_IPI_flags);
 				spin_unlock(&part->IPI_lock);
 				wakeup_channel_mgr = 1;
 			}
@@ -939,7 +905,6 @@ xpc_disconnect_wait(int ch_number)
 	}
 }
 
-
 static void
 xpc_do_exit(enum xp_retval reason)
 {
@@ -948,7 +913,6 @@ xpc_do_exit(enum xp_retval reason)
 	struct xpc_partition *part;
 	unsigned long printmsg_time, disengage_request_timeout = 0;
 
-
 	/* a 'rmmod XPC' and a 'reboot' cannot both end up here together */
 	DBUG_ON(xpc_exiting == 1);
 
@@ -969,10 +933,8 @@ xpc_do_exit(enum xp_retval reason)
 	/* wait for the heartbeat checker thread to exit */
 	wait_for_completion(&xpc_hb_checker_exited);
 
-
 	/* sleep for a 1/3 of a second or so */
-	(void) msleep_interruptible(300);
-
+	(void)msleep_interruptible(300);
 
 	/* wait for all partitions to become inactive */
 
@@ -982,12 +944,11 @@ xpc_do_exit(enum xp_retval reason)
 	do {
 		active_part_count = 0;
 
-		for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID;
-		     partid++) {
+		for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 			part = &xpc_partitions[partid];
 
 			if (xpc_partition_disengaged(part) &&
-					part->act_state == XPC_P_AS_INACTIVE) {
+			    part->act_state == XPC_P_AS_INACTIVE) {
 				xpc_unregister_remote_amos(part);
 				continue;
 			}
@@ -997,47 +958,46 @@ xpc_do_exit(enum xp_retval reason)
 			XPC_DEACTIVATE_PARTITION(part, reason);
 
 			if (part->disengage_request_timeout >
-						disengage_request_timeout) {
+			    disengage_request_timeout) {
 				disengage_request_timeout =
-						part->disengage_request_timeout;
+				    part->disengage_request_timeout;
 			}
 		}
 
 		if (xpc_any_partition_engaged()) {
 			if (time_after(jiffies, printmsg_time)) {
 				dev_info(xpc_part, "waiting for remote "
-					"partitions to disengage, timeout in "
-					"%ld seconds\n",
-					(disengage_request_timeout - jiffies)
-									/ HZ);
+					 "partitions to disengage, timeout in "
+					 "%ld seconds\n",
+					 (disengage_request_timeout - jiffies)
+					 / HZ);
 				printmsg_time = jiffies +
-					(XPC_DISENGAGE_PRINTMSG_INTERVAL * HZ);
+				    (XPC_DISENGAGE_PRINTMSG_INTERVAL * HZ);
 				printed_waiting_msg = 1;
 			}
 
 		} else if (active_part_count > 0) {
 			if (printed_waiting_msg) {
 				dev_info(xpc_part, "waiting for local partition"
-					" to disengage\n");
+					 " to disengage\n");
 				printed_waiting_msg = 0;
 			}
 
 		} else {
 			if (!xpc_disengage_request_timedout) {
 				dev_info(xpc_part, "all partitions have "
-					"disengaged\n");
+					 "disengaged\n");
 			}
 			break;
 		}
 
 		/* sleep for a 1/3 of a second or so */
-		(void) msleep_interruptible(300);
+		(void)msleep_interruptible(300);
 
 	} while (1);
 
 	DBUG_ON(xpc_any_partition_engaged());
 
-
 	/* indicate to others that our reserved page is uninitialized */
 	xpc_rsvd_page->vars_pa = 0;
 
@@ -1047,17 +1007,16 @@ xpc_do_exit(enum xp_retval reason)
 
 	if (reason == xpUnloading) {
 		/* take ourselves off of the reboot_notifier_list */
-		(void) unregister_reboot_notifier(&xpc_reboot_notifier);
+		(void)unregister_reboot_notifier(&xpc_reboot_notifier);
 
 		/* take ourselves off of the die_notifier list */
-		(void) unregister_die_notifier(&xpc_die_notifier);
+		(void)unregister_die_notifier(&xpc_die_notifier);
 	}
 
 	/* close down protections for IPI operations */
 	xp_disallow_IPI_ops();
 	xp_change_memprotect_shub_wars_1_1(XP_MEMPROT_DISALLOW_ALL);
 
-
 	/* clear the interface to XPC's functions */
 	xpc_clear_interface();
 
@@ -1068,7 +1027,6 @@ xpc_do_exit(enum xp_retval reason)
 	kfree(xpc_remote_copy_buffer_base);
 }
 
-
 /*
  * This function is called when the system is being rebooted.
  */
@@ -1077,7 +1035,6 @@ xpc_system_reboot(struct notifier_block 
 {
 	enum xp_retval reason;
 
-
 	switch (event) {
 	case SYS_RESTART:
 		reason = xpSystemReboot;
@@ -1096,7 +1053,6 @@ xpc_system_reboot(struct notifier_block 
 	return NOTIFY_DONE;
 }
 
-
 #ifdef CONFIG_IA64
 /*
  * Notify other partitions to disengage from all references to our memory.
@@ -1108,17 +1064,15 @@ xpc_die_disengage(void)
 	short partid;
 	long time, printmsg_time, disengage_request_timeout;
 
-
 	/* keep xpc_hb_checker thread from doing anything (just in case) */
 	xpc_exiting = 1;
 
-	xpc_disallow_all_hbs(xpc_vars); /* indicate we're deactivated */
+	xpc_disallow_all_hbs(xpc_vars);	/* indicate we're deactivated */
 
 	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 		part = &xpc_partitions[partid];
 
-		if (!XPC_SUPPORTS_DISENGAGE_REQUEST(part->
-							remote_vars_version)) {
+		if (!XPC_SUPPORTS_DISENGAGE_REQUEST(part->remote_vars_version)) {
 
 			/* just in case it was left set by an earlier XPC */
 			xpc_clear_partition_engaged(partid);
@@ -1126,7 +1080,7 @@ xpc_die_disengage(void)
 		}
 
 		if (xpc_partition_engaged(partid) ||
-					part->act_state != XPC_P_AS_INACTIVE) {
+		    part->act_state != XPC_P_AS_INACTIVE) {
 			xpc_request_partition_disengage(part);
 			xpc_mark_partition_disengaged(part);
 			xpc_IPI_send_disengage(part);
@@ -1135,9 +1089,9 @@ xpc_die_disengage(void)
 
 	time = rtc_time();
 	printmsg_time = time +
-		(XPC_DISENGAGE_PRINTMSG_INTERVAL * xp_rtc_cycles_per_second);
+	    (XPC_DISENGAGE_PRINTMSG_INTERVAL * xp_rtc_cycles_per_second);
 	disengage_request_timeout = time +
-		(xpc_disengage_request_timelimit * xp_rtc_cycles_per_second);
+	    (xpc_disengage_request_timelimit * xp_rtc_cycles_per_second);
 
 	/* wait for all other partitions to disengage from us */
 
@@ -1153,8 +1107,8 @@ xpc_die_disengage(void)
 			     partid++) {
 				if (xpc_partition_engaged(partid)) {
 					dev_info(xpc_part, "disengage from "
-						"remote partition %d timed "
-						"out\n", partid);
+						 "remote partition %d timed "
+						 "out\n", partid);
 				}
 			}
 			break;
@@ -1162,18 +1116,17 @@ xpc_die_disengage(void)
 
 		if (time >= printmsg_time) {
 			dev_info(xpc_part, "waiting for remote partitions to "
-				"disengage, timeout in %ld seconds\n",
-				(disengage_request_timeout - time) /
-						xp_rtc_cycles_per_second);
+				 "disengage, timeout in %ld seconds\n",
+				 (disengage_request_timeout - time) /
+				 xp_rtc_cycles_per_second);
 			printmsg_time = time +
-					(XPC_DISENGAGE_PRINTMSG_INTERVAL *
-						xp_rtc_cycles_per_second);
+			    (XPC_DISENGAGE_PRINTMSG_INTERVAL *
+			     xp_rtc_cycles_per_second);
 		}
 	}
 }
 #endif /* CONFIG_IA64 */
 
-
 /*
  * This function is called when the system is being restarted or halted due
  * to some sort of system failure. If this is the case we need to notify the
@@ -1185,7 +1138,7 @@ xpc_die_disengage(void)
 static int
 xpc_system_die(struct notifier_block *nb, unsigned long event, void *unused)
 {
-#ifdef CONFIG_IA64 /* >>> will deal with notify_die events on X86_64 shortly */
+#ifdef CONFIG_IA64		/* >>> will deal with notify_die events on X86_64 shortly */
 	switch (event) {
 	case DIE_MACHINE_RESTART:
 	case DIE_MACHINE_HALT:
@@ -1220,7 +1173,6 @@ xpc_system_die(struct notifier_block *nb
 	return NOTIFY_DONE;
 }
 
-
 int __init
 xpc_init(void)
 {
@@ -1257,7 +1209,7 @@ xpc_init(void)
 	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 		part = &xpc_partitions[partid];
 
-		DBUG_ON((u64) part != L1_CACHE_ALIGN((u64) part));
+		DBUG_ON((u64)part != L1_CACHE_ALIGN((u64)part));
 
 		part->act_IRQ_rcvd = 0;
 		spin_lock_init(&part->lock);
@@ -1266,8 +1218,8 @@ xpc_init(void)
 
 		init_timer(&part->disengage_request_timer);
 		part->disengage_request_timer.function =
-				xpc_timeout_partition_disengage_request;
-		part->disengage_request_timer.data = (unsigned long) part;
+		    xpc_timeout_partition_disengage_request;
+		part->disengage_request_timer.data = (unsigned long)part;
 
 		part->setup_state = XPC_P_SS_UNSET;
 		init_waitqueue_head(&part->teardown_wq);
@@ -1294,7 +1246,7 @@ xpc_init(void)
 	 * but rather immediately process the interrupt.
 	 */
 	ret = request_irq(SGI_XPC_ACTIVATE, xpc_act_IRQ_handler, 0,
-							"xpc hb", NULL);
+			  "xpc hb", NULL);
 	if (ret != 0) {
 		dev_err(xpc_part, "can't register ACTIVATE IRQ handler, "
 			"errno=%d\n", -ret);
@@ -1332,7 +1284,8 @@ xpc_init(void)
 	buf_size = max(XPC_RP_VARS_SIZE,
 		       XPC_RP_HEADER_SIZE + xp_sizeof_nasid_mask);
 	xpc_remote_copy_buffer = xpc_kmalloc_cacheline_aligned(buf_size,
-				     GFP_KERNEL, &xpc_remote_copy_buffer_base);
+							       GFP_KERNEL,
+							       &xpc_remote_copy_buffer_base);
 	if (xpc_remote_copy_buffer == NULL) {
 		dev_err(xpc_part, "could not allocate remote copy buffer\n");
 
@@ -1349,7 +1302,6 @@ xpc_init(void)
 		return -ENOMEM;
 	}
 
-
 	/* add ourselves to the reboot_notifier_list */
 	ret = register_reboot_notifier(&xpc_reboot_notifier);
 	if (ret != 0) {
@@ -1377,10 +1329,10 @@ xpc_init(void)
 		xpc_rsvd_page->vars_pa = 0;
 
 		/* take ourselves off of the reboot_notifier_list */
-		(void) unregister_reboot_notifier(&xpc_reboot_notifier);
+		(void)unregister_reboot_notifier(&xpc_reboot_notifier);
 
 		/* take ourselves off of the die_notifier list */
-		(void) unregister_die_notifier(&xpc_die_notifier);
+		(void)unregister_die_notifier(&xpc_die_notifier);
 
 		del_timer_sync(&xpc_hb_timer);
 		free_irq(SGI_XPC_ACTIVATE, NULL);
@@ -1395,7 +1347,6 @@ xpc_init(void)
 		return -EBUSY;
 	}
 
-
 	/*
 	 * Startup a thread that will attempt to discover other partitions to
 	 * activate based on info provided by SAL. This new thread is short
@@ -1412,7 +1363,6 @@ xpc_init(void)
 		return -EBUSY;
 	}
 
-
 	/* set the interface to point at XPC's functions */
 	xpc_set_interface(xpc_initiate_connect, xpc_initiate_disconnect,
 			  xpc_initiate_allocate, xpc_initiate_send,
@@ -1421,16 +1371,16 @@ xpc_init(void)
 
 	return 0;
 }
-module_init(xpc_init);
 
+module_init(xpc_init);
 
 void __exit
 xpc_exit(void)
 {
 	xpc_do_exit(xpUnloading);
 }
-module_exit(xpc_exit);
 
+module_exit(xpc_exit);
 
 MODULE_AUTHOR("Silicon Graphics, Inc.");
 MODULE_DESCRIPTION("Cross Partition Communication (XPC) support");
@@ -1438,17 +1388,16 @@ MODULE_LICENSE("GPL");
 
 module_param(xpc_hb_interval, int, 0);
 MODULE_PARM_DESC(xpc_hb_interval, "Number of seconds between "
-		"heartbeat increments.");
+		 "heartbeat increments.");
 
 module_param(xpc_hb_check_interval, int, 0);
 MODULE_PARM_DESC(xpc_hb_check_interval, "Number of seconds between "
-		"heartbeat checks.");
+		 "heartbeat checks.");
 
 module_param(xpc_disengage_request_timelimit, int, 0);
 MODULE_PARM_DESC(xpc_disengage_request_timelimit, "Number of seconds to wait "
-		"for disengage request to complete.");
+		 "for disengage request to complete.");
 
 module_param(xpc_kdebug_ignore, int, 0);
 MODULE_PARM_DESC(xpc_kdebug_ignore, "Should lack of heartbeat be ignored by "
-		"other partitions when dropping into kdebug.");
-
+		 "other partitions when dropping into kdebug.");
Index: linux-2.6/drivers/misc/xp/xpc_partition.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpc_partition.c	2008-03-26 10:40:10.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xpc_partition.c	2008-03-26 10:57:58.952022562 -0500
@@ -6,7 +6,6 @@
  * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
-
 /*
  * Cross Partition Communication (XPC) partition support.
  *
@@ -16,7 +15,6 @@
  *
  */
 
-
 #include <linux/kernel.h>
 #include <linux/sysctl.h>
 #include <linux/cache.h>
@@ -32,11 +30,9 @@
 #error architecture is NOT supported
 #endif
 
-
 /* XPC is exiting flag */
 int xpc_exiting;
 
-
 /* this partition's reserved page pointers */
 struct xpc_rsvd_page *xpc_rsvd_page;
 static u64 *xpc_part_nasids;
@@ -44,7 +40,6 @@ static u64 *xpc_mach_nasids;
 struct xpc_vars *xpc_vars;
 struct xpc_vars_part *xpc_vars_part;
 
-
 /*
  * For performance reasons, each entry of xpc_partitions[] is cacheline
  * aligned. And xpc_partitions[] is padded with an additional entry at the
@@ -53,7 +48,6 @@ struct xpc_vars_part *xpc_vars_part;
  */
 struct xpc_partition xpc_partitions[XP_NPARTITIONS + 1];
 
-
 /*
  * Generic buffer used to store a local copy of portions of a remote
  * partition's reserved page (either its header and part_nasids mask,
@@ -62,7 +56,6 @@ struct xpc_partition xpc_partitions[XP_N
 char *xpc_remote_copy_buffer;
 void *xpc_remote_copy_buffer_base;
 
-
 /*
  * Guarantee that the kmalloc'd memory is cacheline aligned.
  */
@@ -74,7 +67,7 @@ xpc_kmalloc_cacheline_aligned(size_t siz
 	if (*base == NULL) {
 		return NULL;
 	}
-	if ((u64) *base == L1_CACHE_ALIGN((u64) *base)) {
+	if ((u64)*base == L1_CACHE_ALIGN((u64)*base)) {
 		return *base;
 	}
 	kfree(*base);
@@ -84,10 +77,9 @@ xpc_kmalloc_cacheline_aligned(size_t siz
 	if (*base == NULL) {
 		return NULL;
 	}
-	return (void *) L1_CACHE_ALIGN((u64) *base);
+	return (void *)L1_CACHE_ALIGN((u64)*base);
 }
 
-
 /*
  * Given a nasid, get the physical address of the  partition's reserved page
  * for that nasid. This function returns 0 on any error.
@@ -103,7 +95,6 @@ xpc_get_rsvd_page_pa(int nasid)
 	size_t buf_len = 0;
 	void *buf_base = NULL;
 
-
 	while (1) {
 
 		ret = xp_get_partition_rsvd_page_pa(buf, &cookie, &rp_pa, &len);
@@ -120,7 +111,8 @@ xpc_get_rsvd_page_pa(int nasid)
 			kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
 			buf = (u64)xpc_kmalloc_cacheline_aligned(buf_len,
-							GFP_KERNEL, &buf_base);
+								 GFP_KERNEL,
+								 &buf_base);
 			if (buf_base == NULL) {
 				dev_err(xpc_part, "unable to kmalloc "
 					"len=0x%016lx\n", buf_len);
@@ -146,7 +138,6 @@ xpc_get_rsvd_page_pa(int nasid)
 	return rp_pa;
 }
 
-
 /*
  * Fill the partition reserved page with the information needed by
  * other partitions to discover we are alive and establish initial
@@ -166,7 +157,6 @@ xpc_rsvd_page_init(void)
 	int disengage_request_amos;
 	int ret;
 
-
 	/* get the local reserved page's address */
 
 	preempt_disable();
@@ -176,7 +166,7 @@ xpc_rsvd_page_init(void)
 		dev_err(xpc_part, "SAL failed to locate the reserved page\n");
 		return NULL;
 	}
-	rp = (struct xpc_rsvd_page *) __va(rp_pa);
+	rp = (struct xpc_rsvd_page *)__va(rp_pa);
 
 	rp->version = XPC_RP_VERSION;
 
@@ -238,12 +228,11 @@ xpc_rsvd_page_init(void)
 	xpc_vars->act_phys_cpuid = cpu_physical_id(0);
 	xpc_vars->vars_part_pa = __pa(xpc_vars_part);
 	xpc_vars->amos_page_pa = xp_pa((u64)amos_page);
-	xpc_vars->amos_page = amos_page;  /* save for next load of XPC */
-
+	xpc_vars->amos_page = amos_page;	/* save for next load of XPC */
 
 	/* clear xpc_vars_part */
 	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part) *
-							XP_NPARTITIONS);
+	       XP_NPARTITIONS);
 
 	/* initialize the activate IRQ related AMO variables */
 	activate_irq_amos = xpc_activate_irq_amos(XP_NPARTITIONS);
@@ -271,7 +260,6 @@ xpc_rsvd_page_init(void)
 	return rp;
 }
 
-
 /*
  * At periodic intervals, scan through all active partitions and ensure
  * their heartbeat is still active.  If not, the partition is deactivated.
@@ -284,8 +272,7 @@ xpc_check_remote_hb(void)
 	short partid;
 	enum xp_retval ret;
 
-
-	remote_vars = (struct xpc_vars *) xpc_remote_copy_buffer;
+	remote_vars = (struct xpc_vars *)xpc_remote_copy_buffer;
 
 	for (partid = XP_MIN_PARTID; partid <= XP_MAX_PARTID; partid++) {
 
@@ -300,7 +287,7 @@ xpc_check_remote_hb(void)
 		part = &xpc_partitions[partid];
 
 		if (part->act_state == XPC_P_AS_INACTIVE ||
-				part->act_state == XPC_P_AS_DEACTIVATING) {
+		    part->act_state == XPC_P_AS_DEACTIVATING) {
 			continue;
 		}
 
@@ -320,8 +307,8 @@ xpc_check_remote_hb(void)
 			remote_vars->heartbeat_offline);
 
 		if (((remote_vars->heartbeat == part->last_heartbeat) &&
-			(remote_vars->heartbeat_offline == 0)) ||
-			     !xpc_hb_allowed(xp_partition_id, remote_vars)) {
+		     (remote_vars->heartbeat_offline == 0)) ||
+		    !xpc_hb_allowed(xp_partition_id, remote_vars)) {
 
 			XPC_DEACTIVATE_PARTITION(part, xpNoHeartbeat);
 			continue;
@@ -331,7 +318,6 @@ xpc_check_remote_hb(void)
 	}
 }
 
-
 /*
  * Get a copy of a portion of the remote partition's rsvd page.
  *
@@ -341,12 +327,11 @@ xpc_check_remote_hb(void)
  */
 static enum xp_retval
 xpc_get_remote_rp(int nasid, u64 *discovered_nasids,
-		struct xpc_rsvd_page *remote_rp, u64 *remote_rp_pa)
+		  struct xpc_rsvd_page *remote_rp, u64 *remote_rp_pa)
 {
 	int i;
 	enum xp_retval ret;
 
-
 	/* get the reserved page's physical address */
 
 	*remote_rp_pa = xpc_get_rsvd_page_pa(nasid);
@@ -354,7 +339,6 @@ xpc_get_remote_rp(int nasid, u64 *discov
 		return xpNoRsvdPageAddr;
 	}
 
-
 	/* pull over the reserved page header and part_nasids mask */
 	ret = xp_remote_memcpy(remote_rp, (void *)*remote_rp_pa,
 			       XPC_RP_HEADER_SIZE + xp_sizeof_nasid_mask);
@@ -362,25 +346,22 @@ xpc_get_remote_rp(int nasid, u64 *discov
 		return ret;
 	}
 
-
 	if (discovered_nasids != NULL) {
 		u64 *remote_part_nasids = XPC_RP_PART_NASIDS(remote_rp);
 
-
 		for (i = 0; i < xp_nasid_mask_words(); i++) {
 			discovered_nasids[i] |= remote_part_nasids[i];
 		}
 	}
 
 	if (XPC_VERSION_MAJOR(remote_rp->version) !=
-					XPC_VERSION_MAJOR(XPC_RP_VERSION)) {
+	    XPC_VERSION_MAJOR(XPC_RP_VERSION)) {
 		return xpBadVersion;
 	}
 
 	return xpSuccess;
 }
 
-
 /*
  * Get a copy of the remote partition's XPC variables from the reserved page.
  *
@@ -404,7 +385,7 @@ xpc_get_remote_vars(u64 remote_vars_pa, 
 	}
 
 	if (XPC_VERSION_MAJOR(remote_vars->version) !=
-					XPC_VERSION_MAJOR(XPC_V_VERSION)) {
+	    XPC_VERSION_MAJOR(XPC_V_VERSION)) {
 		return xpBadVersion;
 	}
 
@@ -418,14 +399,13 @@ xpc_get_remote_vars(u64 remote_vars_pa, 
 	return xpSuccess;
 }
 
-
 /*
  * Update the remote partition's info.
  */
 static void
 xpc_update_partition_info(struct xpc_partition *part, u8 remote_rp_version,
-		struct timespec *remote_rp_stamp, u64 remote_rp_pa,
-		u64 remote_vars_pa, struct xpc_vars *remote_vars)
+			  struct timespec *remote_rp_stamp, u64 remote_rp_pa,
+			  u64 remote_vars_pa, struct xpc_vars *remote_vars)
 {
 	part->remote_rp_version = remote_rp_version;
 	dev_dbg(xpc_part, "  remote_rp_version = 0x%016x\n",
@@ -472,7 +452,6 @@ xpc_update_partition_info(struct xpc_par
 		part->remote_vars_version);
 }
 
-
 /*
  * Prior code has determined the nasid which generated an IPI.  Inspect
  * that nasid to determine if its partition needs to be activated or
@@ -502,15 +481,14 @@ xpc_identify_act_IRQ_req(int nasid)
 	struct xpc_partition *part;
 	enum xp_retval ret;
 
-
 	/* pull over the reserved page structure */
 
-	remote_rp = (struct xpc_rsvd_page *) xpc_remote_copy_buffer;
+	remote_rp = (struct xpc_rsvd_page *)xpc_remote_copy_buffer;
 
 	ret = xpc_get_remote_rp(nasid, NULL, remote_rp, &remote_rp_pa);
 	if (ret != xpSuccess) {
 		dev_warn(xpc_part, "unable to get reserved page from nasid %d, "
-			"which sent interrupt, reason=%d\n", nasid, ret);
+			 "which sent interrupt, reason=%d\n", nasid, ret);
 		return;
 	}
 
@@ -522,12 +500,12 @@ xpc_identify_act_IRQ_req(int nasid)
 
 	/* pull over the cross partition variables */
 
-	remote_vars = (struct xpc_vars *) xpc_remote_copy_buffer;
+	remote_vars = (struct xpc_vars *)xpc_remote_copy_buffer;
 
 	ret = xpc_get_remote_vars(remote_vars_pa, remote_vars);
 	if (ret != xpSuccess) {
 		dev_warn(xpc_part, "unable to get XPC variables from nasid %d, "
-			"which sent interrupt, reason=%d\n", nasid, ret);
+			 "which sent interrupt, reason=%d\n", nasid, ret);
 		return;
 	}
 
@@ -537,15 +515,15 @@ xpc_identify_act_IRQ_req(int nasid)
 	part->act_IRQ_rcvd++;
 
 	dev_dbg(xpc_part, "partid for nasid %d is %d; IRQs = %d; HB = "
-		"%" U64_ELL "d\n", (int) nasid, (int) partid,
+		"%" U64_ELL "d\n", (int)nasid, (int)partid,
 		part->act_IRQ_rcvd, remote_vars->heartbeat);
 
 	if (xpc_partition_disengaged(part) &&
-					part->act_state == XPC_P_AS_INACTIVE) {
+	    part->act_state == XPC_P_AS_INACTIVE) {
 
 		xpc_update_partition_info(part, remote_rp_version,
-					&remote_rp_stamp, remote_rp_pa,
-					remote_vars_pa, remote_vars);
+					  &remote_rp_stamp, remote_rp_pa,
+					  remote_vars_pa, remote_vars);
 
 		if (XPC_SUPPORTS_DISENGAGE_REQUEST(part->remote_vars_version)) {
 			if (xpc_partition_disengage_requested(partid)) {
@@ -569,16 +547,15 @@ xpc_identify_act_IRQ_req(int nasid)
 
 	if (!XPC_SUPPORTS_RP_STAMP(part->remote_rp_version)) {
 		DBUG_ON(XPC_SUPPORTS_DISENGAGE_REQUEST(part->
-							remote_vars_version));
+						       remote_vars_version));
 
 		if (!XPC_SUPPORTS_RP_STAMP(remote_rp_version)) {
 			DBUG_ON(XPC_SUPPORTS_DISENGAGE_REQUEST(remote_vars->
-								version));
+							       version));
 			/* see if the other side rebooted */
 			if (part->remote_amos_page_pa ==
-				remote_vars->amos_page_pa &&
-					xpc_hb_allowed(xp_partition_id,
-								remote_vars)) {
+			    remote_vars->amos_page_pa &&
+			    xpc_hb_allowed(xp_partition_id, remote_vars)) {
 				/* doesn't look that way, so ignore the IPI */
 				return;
 			}
@@ -590,8 +567,8 @@ xpc_identify_act_IRQ_req(int nasid)
 		 */
 
 		xpc_update_partition_info(part, remote_rp_version,
-						&remote_rp_stamp, remote_rp_pa,
-						remote_vars_pa, remote_vars);
+					  &remote_rp_stamp, remote_rp_pa,
+					  remote_vars_pa, remote_vars);
 		part->reactivate_nasid = nasid;
 		XPC_DEACTIVATE_PARTITION(part, xpReactivating);
 		return;
@@ -611,15 +588,15 @@ xpc_identify_act_IRQ_req(int nasid)
 		xpc_clear_partition_disengage_request(partid);
 
 		xpc_update_partition_info(part, remote_rp_version,
-						&remote_rp_stamp, remote_rp_pa,
-						remote_vars_pa, remote_vars);
+					  &remote_rp_stamp, remote_rp_pa,
+					  remote_vars_pa, remote_vars);
 		reactivate = 1;
 
 	} else {
 		DBUG_ON(!XPC_SUPPORTS_DISENGAGE_REQUEST(remote_vars->version));
 
 		stamp_diff = xpc_compare_stamps(&part->remote_rp_stamp,
-							&remote_rp_stamp);
+						&remote_rp_stamp);
 		if (stamp_diff != 0) {
 			DBUG_ON(stamp_diff >= 0);
 
@@ -632,14 +609,15 @@ xpc_identify_act_IRQ_req(int nasid)
 			DBUG_ON(xpc_partition_disengage_requested(partid));
 
 			xpc_update_partition_info(part, remote_rp_version,
-						&remote_rp_stamp, remote_rp_pa,
-						remote_vars_pa, remote_vars);
+						  &remote_rp_stamp,
+						  remote_rp_pa, remote_vars_pa,
+						  remote_vars);
 			reactivate = 1;
 		}
 	}
 
 	if (part->disengage_request_timeout > 0 &&
-					!xpc_partition_disengaged(part)) {
+	    !xpc_partition_disengaged(part)) {
 		/* still waiting on other side to disengage from us */
 		return;
 	}
@@ -649,12 +627,11 @@ xpc_identify_act_IRQ_req(int nasid)
 		XPC_DEACTIVATE_PARTITION(part, xpReactivating);
 
 	} else if (XPC_SUPPORTS_DISENGAGE_REQUEST(part->remote_vars_version) &&
-			xpc_partition_disengage_requested(partid)) {
+		   xpc_partition_disengage_requested(partid)) {
 		XPC_DEACTIVATE_PARTITION(part, xpOtherGoingDown);
 	}
 }
 
-
 /*
  * Loop through the activation AMO variables and process any bits
  * which are set.  Each bit indicates a nasid sending a partition
@@ -669,13 +646,12 @@ xpc_identify_act_IRQ_sender(void)
 	int w_index, b_index;
 	u64 *amo_va;
 	u64 nasid_mask;
-	u64 nasid;			/* remote nasid */
+	u64 nasid;		/* remote nasid */
 	int n_IRQs_detected = 0;
 
 	amo_va = (u64 *)((u64)xpc_vars->amos_page +
-				xpc_activate_irq_amos(xpc_vars->npartitions) *
-				xp_sizeof_amo);
-
+			 xpc_activate_irq_amos(xpc_vars->npartitions) *
+			 xp_sizeof_amo);
 
 	/* scan through activation AMO variables looking for non-zero entries */
 	for (w_index = 0; w_index < xp_nasid_mask_words(); w_index++) {
@@ -685,8 +661,8 @@ xpc_identify_act_IRQ_sender(void)
 		}
 
 		ret = xp_get_amo(amo_va, XP_AMO_CLEAR, &nasid_mask);
-		BUG_ON(ret != xpSuccess);  /* should never happen */
-		amo_va = (u64 *)((u64)amo_va + xp_sizeof_amo);  /* next amo */
+		BUG_ON(ret != xpSuccess);	/* should never happen */
+		amo_va = (u64 *)((u64)amo_va + xp_sizeof_amo);	/* next amo */
 		if (nasid_mask == 0) {
 			/* no IRQs from nasids in this variable */
 			continue;
@@ -695,7 +671,6 @@ xpc_identify_act_IRQ_sender(void)
 		dev_dbg(xpc_part, "AMO[%d] gave back 0x%" U64_ELL "x\n",
 			w_index, nasid_mask);
 
-
 		/*
 		 * If any nasid(s) in mask have been added to the machine
 		 * since our partition was reset, this will retain the
@@ -704,7 +679,6 @@ xpc_identify_act_IRQ_sender(void)
 		 */
 		xpc_mach_nasids[w_index] |= nasid_mask;
 
-
 		/* locate the nasid(s) which sent interrupts */
 
 		for (b_index = 0; b_index < BITS_PER_LONG; b_index++) {
@@ -720,7 +694,6 @@ xpc_identify_act_IRQ_sender(void)
 	return n_IRQs_detected;
 }
 
-
 /*
  * See if the other side has responded to a partition disengage request
  * from us.
@@ -731,7 +704,6 @@ xpc_partition_disengaged(struct xpc_part
 	short partid = XPC_PARTID(part);
 	int disengaged;
 
-
 	disengaged = (xpc_partition_engaged(partid) == 0);
 	if (part->disengage_request_timeout) {
 		if (!disengaged) {
@@ -746,7 +718,7 @@ xpc_partition_disengaged(struct xpc_part
 			 */
 
 			dev_info(xpc_part, "disengage from remote partition %d "
-				"timed out\n", partid);
+				 "timed out\n", partid);
 			xpc_disengage_request_timedout = 1;
 			xpc_clear_partition_engaged(partid);
 			disengaged = 1;
@@ -756,11 +728,11 @@ xpc_partition_disengaged(struct xpc_part
 		/* cancel the timer function, provided it's not us */
 		if (!in_interrupt()) {
 			del_singleshot_timer_sync(&part->
-						      disengage_request_timer);
+						  disengage_request_timer);
 		}
 
 		DBUG_ON(part->act_state != XPC_P_AS_DEACTIVATING &&
-					part->act_state != XPC_P_AS_INACTIVE);
+			part->act_state != XPC_P_AS_INACTIVE);
 		if (part->act_state != XPC_P_AS_INACTIVE) {
 			xpc_wakeup_channel_mgr(part);
 		}
@@ -772,7 +744,6 @@ xpc_partition_disengaged(struct xpc_part
 	return disengaged;
 }
 
-
 /*
  * Mark specified partition as active.
  */
@@ -782,7 +753,6 @@ xpc_mark_partition_active(struct xpc_par
 	unsigned long irq_flags;
 	enum xp_retval ret;
 
-
 	dev_dbg(xpc_part, "setting partition %d to ACTIVE\n", XPC_PARTID(part));
 
 	spin_lock_irqsave(&part->lock, irq_flags);
@@ -798,17 +768,15 @@ xpc_mark_partition_active(struct xpc_par
 	return ret;
 }
 
-
 /*
  * Notify XPC that the partition is down.
  */
 void
 xpc_deactivate_partition(const int line, struct xpc_partition *part,
-				enum xp_retval reason)
+			 enum xp_retval reason)
 {
 	unsigned long irq_flags;
 
-
 	spin_lock_irqsave(&part->lock, irq_flags);
 
 	if (part->act_state == XPC_P_AS_INACTIVE) {
@@ -822,7 +790,7 @@ xpc_deactivate_partition(const int line,
 	}
 	if (part->act_state == XPC_P_AS_DEACTIVATING) {
 		if ((part->reason == xpUnloading && reason != xpUnloading) ||
-					reason == xpReactivating) {
+		    reason == xpReactivating) {
 			XPC_SET_REASON(part, reason, line);
 		}
 		spin_unlock_irqrestore(&part->lock, irq_flags);
@@ -840,9 +808,9 @@ xpc_deactivate_partition(const int line,
 
 		/* set a timelimit on the disengage request */
 		part->disengage_request_timeout = jiffies +
-					(xpc_disengage_request_timelimit * HZ);
+		    (xpc_disengage_request_timelimit * HZ);
 		part->disengage_request_timer.expires =
-					part->disengage_request_timeout;
+		    part->disengage_request_timeout;
 		add_timer(&part->disengage_request_timer);
 	}
 
@@ -852,7 +820,6 @@ xpc_deactivate_partition(const int line,
 	xpc_partition_going_down(part, reason);
 }
 
-
 /*
  * Mark specified partition as inactive.
  */
@@ -861,7 +828,6 @@ xpc_mark_partition_inactive(struct xpc_p
 {
 	unsigned long irq_flags;
 
-
 	dev_dbg(xpc_part, "setting partition %d to INACTIVE\n",
 		XPC_PARTID(part));
 
@@ -871,7 +837,6 @@ xpc_mark_partition_inactive(struct xpc_p
 	part->remote_rp_pa = 0;
 }
 
-
 /*
  * Register the remote partition's AMOs so any errors within that address
  * range can be handled and cleaned up should the remote partition go down.
@@ -917,7 +882,6 @@ xpc_unregister_remote_amos(struct xpc_pa
 	spin_unlock_irqrestore(&part->lock, irq_flags);
 }
 
-
 /*
  * SAL has provided a partition and machine mask.  The partition mask
  * contains a bit for each even nasid in our partition.  The machine
@@ -945,15 +909,13 @@ xpc_discovery(void)
 	u64 *discovered_nasids;
 	enum xp_retval ret;
 
-
 	remote_rp = xpc_kmalloc_cacheline_aligned(XPC_RP_HEADER_SIZE +
 						  xp_sizeof_nasid_mask,
 						  GFP_KERNEL, &remote_rp_base);
 	if (remote_rp == NULL) {
 		return;
 	}
-	remote_vars = (struct xpc_vars *) remote_rp;
-
+	remote_vars = (struct xpc_vars *)remote_rp;
 
 	discovered_nasids = kzalloc(sizeof(u64) * xp_nasid_mask_words(),
 				    GFP_KERNEL);
@@ -962,7 +924,7 @@ xpc_discovery(void)
 		return;
 	}
 
-	rp = (struct xpc_rsvd_page *) xpc_rsvd_page;
+	rp = (struct xpc_rsvd_page *)xpc_rsvd_page;
 
 	/*
 	 * The term 'region' in this context refers to the minimum number of
@@ -985,23 +947,21 @@ xpc_discovery(void)
 
 	for (region = 0; region < max_regions; region++) {
 
-		if ((volatile int) xpc_exiting) {
+		if ((volatile int)xpc_exiting) {
 			break;
 		}
 
 		dev_dbg(xpc_part, "searching region %d\n", region);
 
 		for (nasid = (region * region_size * 2);
-		     nasid < ((region + 1) * region_size * 2);
-		     nasid += 2) {
+		     nasid < ((region + 1) * region_size * 2); nasid += 2) {
 
-			if ((volatile int) xpc_exiting) {
+			if ((volatile int)xpc_exiting) {
 				break;
 			}
 
 			dev_dbg(xpc_part, "checking nasid %d\n", nasid);
 
-
 			if (XPC_NASID_IN_ARRAY(nasid, xpc_part_nasids)) {
 				dev_dbg(xpc_part, "PROM indicates Nasid %d is "
 					"part of the local partition; skipping "
@@ -1023,11 +983,10 @@ xpc_discovery(void)
 				continue;
 			}
 
-
 			/* pull over the reserved page structure */
 
 			ret = xpc_get_remote_rp(nasid, discovered_nasids,
-					      remote_rp, &remote_rp_pa);
+						remote_rp, &remote_rp_pa);
 			if (ret != xpSuccess) {
 				dev_dbg(xpc_part, "unable to get reserved page "
 					"from nasid %d, reason=%d\n", nasid,
@@ -1068,11 +1027,11 @@ xpc_discovery(void)
 			ret = xpc_register_remote_amos(part);
 			if (ret != xpSuccess) {
 				dev_warn(xpc_part, "xpc_discovery() failed to "
-					"register remote AMOs for partition %d,"
-					"ret=%d\n", partid, ret);
+					 "register remote AMOs for partition %d,"
+					 "ret=%d\n", partid, ret);
 
 				XPC_SET_REASON(part, xpPhysAddrRegFailed,
-						__LINE__);
+					       __LINE__);
 				break;
 			}
 
@@ -1088,9 +1047,9 @@ xpc_discovery(void)
 				remote_vars->act_phys_cpuid);
 
 			if (XPC_SUPPORTS_DISENGAGE_REQUEST(remote_vars->
-								version)) {
+							   version)) {
 				part->remote_amos_page_pa =
-						remote_vars->amos_page_pa;
+				    remote_vars->amos_page_pa;
 				xpc_mark_partition_disengaged(part);
 				xpc_cancel_partition_disengage_request(part);
 			}
@@ -1102,7 +1061,6 @@ xpc_discovery(void)
 	kfree(remote_rp_base);
 }
 
-
 /*
  * Given a partid, get the nasids owned by that partition from the
  * remote partition's reserved page.
@@ -1113,7 +1071,6 @@ xpc_initiate_partid_to_nasids(short part
 	struct xpc_partition *part;
 	u64 part_nasid_pa;
 
-
 	part = &xpc_partitions[partid];
 	if (part->remote_rp_pa == 0) {
 		return xpPartitionDown;
@@ -1121,9 +1078,8 @@ xpc_initiate_partid_to_nasids(short part
 
 	memset(nasid_mask, 0, xp_sizeof_nasid_mask);
 
-	part_nasid_pa = (u64) XPC_RP_PART_NASIDS(part->remote_rp_pa);
+	part_nasid_pa = (u64)XPC_RP_PART_NASIDS(part->remote_rp_pa);
 
 	return xp_remote_memcpy(nasid_mask, (void *)part_nasid_pa,
 				xp_sizeof_nasid_mask);
 }
-
Index: linux-2.6/drivers/misc/xp/xpnet.c
===================================================================
--- linux-2.6.orig/drivers/misc/xp/xpnet.c	2008-03-26 10:40:10.000000000 -0500
+++ linux-2.6/drivers/misc/xp/xpnet.c	2008-03-26 10:57:58.968024529 -0500
@@ -6,7 +6,6 @@
  * Copyright (C) 1999,2001-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
-
 /*
  * Cross Partition Network Interface (XPNET) support
  *
@@ -21,7 +20,6 @@
  *
  */
 
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -37,7 +35,6 @@
 #include <asm/atomic.h>
 #include "xp.h"
 
-
 /*
  * The message payload transferred by XPC.
  *
@@ -76,7 +73,6 @@ struct xpnet_message {
 #define XPNET_MSG_ALIGNED_SIZE	(L1_CACHE_ALIGN(XPNET_MSG_SIZE))
 #define XPNET_MSG_NENTRIES	(PAGE_SIZE / XPNET_MSG_ALIGNED_SIZE)
 
-
 #define XPNET_MAX_KTHREADS	(XPNET_MSG_NENTRIES + 1)
 #define XPNET_MAX_IDLE_KTHREADS	(XPNET_MSG_NENTRIES + 1)
 
@@ -88,9 +84,9 @@ struct xpnet_message {
 #define XPNET_VERSION_MAJOR(_v)		((_v) >> 4)
 #define XPNET_VERSION_MINOR(_v)		((_v) & 0xf)
 
-#define	XPNET_VERSION _XPNET_VERSION(1,0)		/* version 1.0 */
-#define	XPNET_VERSION_EMBED _XPNET_VERSION(1,1)		/* version 1.1 */
-#define XPNET_MAGIC	0x88786984 /* "XNET" */
+#define	XPNET_VERSION _XPNET_VERSION(1,0)	/* version 1.0 */
+#define	XPNET_VERSION_EMBED _XPNET_VERSION(1,1)	/* version 1.1 */
+#define XPNET_MAGIC	0x88786984	/* "XNET" */
 
 #define XPNET_VALID_MSG(_m)						     \
    ((XPNET_VERSION_MAJOR(_m->version) == XPNET_VERSION_MAJOR(XPNET_VERSION)) \
@@ -98,7 +94,6 @@ struct xpnet_message {
 
 #define XPNET_DEVICE_NAME		"xp0"
 
-
 /*
  * When messages are queued with xpc_send_notify, a kmalloc'd buffer
  * of the following type is passed as a notification cookie.  When the
@@ -141,14 +136,12 @@ static DEFINE_SPINLOCK(xpnet_broadcast_l
 /* 32KB has been determined to be the ideal */
 #define XPNET_DEF_MTU (0x8000UL)
 
-
 /*
  * The partid is encapsulated in the MAC address beginning in the following
  * octet.
  */
 #define XPNET_PARTID_OCTET	2	/* consists of 2 octets total */
 
-
 /* Define the XPNET debug device structures to be used with dev_dbg() et al */
 
 struct device_driver xpnet_dbg_name = {
@@ -156,7 +149,7 @@ struct device_driver xpnet_dbg_name = {
 };
 
 struct device xpnet_dbg_subname = {
-	.bus_id = {0},			/* set to "" */
+	.bus_id = {0},		/* set to "" */
 	.driver = &xpnet_dbg_name
 };
 
@@ -171,14 +164,13 @@ xpnet_receive(short partid, int channel,
 	struct sk_buff *skb;
 	enum xp_retval ret;
 	struct xpnet_dev_private *priv =
-		(struct xpnet_dev_private *) xpnet_device->priv;
-
+	    (struct xpnet_dev_private *)xpnet_device->priv;
 
 	if (!XPNET_VALID_MSG(msg)) {
 		/*
 		 * Packet with a different XPC version.  Ignore.
 		 */
-		xpc_received(partid, channel, (void *) msg);
+		xpc_received(partid, channel, (void *)msg);
 
 		priv->stats.rx_errors++;
 
@@ -187,14 +179,13 @@ xpnet_receive(short partid, int channel,
 	dev_dbg(xpnet, "received 0x%" U64_ELL "x, %d, %d, %d\n", msg->buf_pa,
 		msg->size, msg->leadin_ignore, msg->tailout_ignore);
 
-
 	/* reserve an extra cache line */
 	skb = dev_alloc_skb(msg->size + L1_CACHE_BYTES);
 	if (!skb) {
 		dev_err(xpnet, "failed on dev_alloc_skb(%d)\n",
 			msg->size + L1_CACHE_BYTES);
 
-		xpc_received(partid, channel, (void *) msg);
+		xpc_received(partid, channel, (void *)msg);
 
 		priv->stats.rx_errors++;
 
@@ -220,12 +211,13 @@ xpnet_receive(short partid, int channel,
 	 * Move the data over from the other side.
 	 */
 	if ((XPNET_VERSION_MINOR(msg->version) == 1) &&
-						(msg->embedded_bytes != 0)) {
+	    (msg->embedded_bytes != 0)) {
 		dev_dbg(xpnet, "copying embedded message. memcpy(0x%p, 0x%p, "
 			"%lu)\n", skb->data, &msg->data,
-			(size_t) msg->embedded_bytes);
+			(size_t)msg->embedded_bytes);
 
-		skb_copy_to_linear_data(skb, &msg->data, (size_t)msg->embedded_bytes);
+		skb_copy_to_linear_data(skb, &msg->data,
+					(size_t)msg->embedded_bytes);
 	} else {
 		dev_dbg(xpnet, "transferring buffer to the skb->data area;\n\t"
 			"bte_copy(0x%p, 0x%p, %hu)\n", (void *)msg->buf_pa,
@@ -233,8 +225,8 @@ xpnet_receive(short partid, int channel,
 			msg->size);
 
 		ret = xp_remote_memcpy((void *)((u64)skb->data &
-				       ~(L1_CACHE_BYTES - 1)),
-					(void *)msg->buf_pa, msg->size);
+						~(L1_CACHE_BYTES - 1)),
+				       (void *)msg->buf_pa, msg->size);
 
 		if (ret != xpSuccess) {
 			/*
@@ -245,10 +237,10 @@ xpnet_receive(short partid, int channel,
 			dev_err(xpnet, "xp_remote_memcpy(0x%p, 0x%p, 0x%hx) "
 				"returned error=0x%x\n",
 				(void *)__pa((u64)skb->data &
-				~(L1_CACHE_BYTES - 1)),
+					     ~(L1_CACHE_BYTES - 1)),
 				(void *)msg->buf_pa, msg->size, ret);
 
-			xpc_received(partid, channel, (void *) msg);
+			xpc_received(partid, channel, (void *)msg);
 
 			priv->stats.rx_errors++;
 
@@ -257,7 +249,7 @@ xpnet_receive(short partid, int channel,
 	}
 
 	dev_dbg(xpnet, "<skb->head=0x%p skb->data=0x%p skb->tail=0x%p "
-		"skb->end=0x%p skb->len=%d\n", (void *) skb->head,
+		"skb->end=0x%p skb->len=%d\n", (void *)skb->head,
 		(void *)skb->data, skb_tail_pointer(skb), skb_end_pointer(skb),
 		skb->len);
 
@@ -270,16 +262,14 @@ xpnet_receive(short partid, int channel,
 		(void *)skb->head, (void *)skb->data, skb_tail_pointer(skb),
 		skb_end_pointer(skb), skb->len);
 
-
 	xpnet_device->last_rx = jiffies;
 	priv->stats.rx_packets++;
 	priv->stats.rx_bytes += skb->len + ETH_HLEN;
 
 	netif_rx_ni(skb);
-	xpc_received(partid, channel, (void *) msg);
+	xpc_received(partid, channel, (void *)msg);
 }
 
-
 /*
  * This is the handler which XPC calls during any sort of change in
  * state or message reception on a connection.
@@ -291,11 +281,11 @@ xpnet_connection_activity(enum xp_retval
 	DBUG_ON(partid < XP_MIN_PARTID || partid > XP_MAX_PARTID);
 	DBUG_ON(channel != XPC_NET_CHANNEL);
 
-	switch(reason) {
+	switch (reason) {
 	case xpMsgReceived:	/* message received */
 		DBUG_ON(data == NULL);
 
-		xpnet_receive(partid, channel, (struct xpnet_message *) data);
+		xpnet_receive(partid, channel, (struct xpnet_message *)data);
 		break;
 
 	case xpConnected:	/* connection completed to a partition */
@@ -325,13 +315,11 @@ xpnet_connection_activity(enum xp_retval
 	}
 }
 
-
 static int
 xpnet_dev_open(struct net_device *dev)
 {
 	enum xp_retval ret;
 
-
 	dev_dbg(xpnet, "calling xpc_connect(%d, 0x%p, NULL, %" U64_ELL "d, %"
 		U64_ELL "d, %" U64_ELL "d, %" U64_ELL "d)\n", XPC_NET_CHANNEL,
 		xpnet_connection_activity, XPNET_MSG_SIZE, XPNET_MSG_NENTRIES,
@@ -352,7 +340,6 @@ xpnet_dev_open(struct net_device *dev)
 	return 0;
 }
 
-
 static int
 xpnet_dev_stop(struct net_device *dev)
 {
@@ -363,7 +350,6 @@ xpnet_dev_stop(struct net_device *dev)
 	return 0;
 }
 
-
 static int
 xpnet_dev_change_mtu(struct net_device *dev, int new_mtu)
 {
@@ -380,7 +366,6 @@ xpnet_dev_change_mtu(struct net_device *
 	return 0;
 }
 
-
 /*
  * Required for the net_device structure.
  */
@@ -390,7 +375,6 @@ xpnet_dev_set_config(struct net_device *
 	return 0;
 }
 
-
 /*
  * Return statistics to the caller.
  */
@@ -399,13 +383,11 @@ xpnet_dev_get_stats(struct net_device *d
 {
 	struct xpnet_dev_private *priv;
 
-
-	priv = (struct xpnet_dev_private *) dev->priv;
+	priv = (struct xpnet_dev_private *)dev->priv;
 
 	return &priv->stats;
 }
 
-
 /*
  * Notification that the other end has received the message and
  * DMA'd the skb information.  At this point, they are done with
@@ -414,11 +396,9 @@ xpnet_dev_get_stats(struct net_device *d
  */
 static void
 xpnet_send_completed(enum xp_retval reason, short partid, int channel,
-			void *__qm)
+		     void *__qm)
 {
-	struct xpnet_pending_msg *queued_msg =
-		(struct xpnet_pending_msg *) __qm;
-
+	struct xpnet_pending_msg *queued_msg = (struct xpnet_pending_msg *)__qm;
 
 	DBUG_ON(queued_msg == NULL);
 
@@ -427,14 +407,13 @@ xpnet_send_completed(enum xp_retval reas
 
 	if (atomic_dec_return(&queued_msg->use_count) == 0) {
 		dev_dbg(xpnet, "all acks for skb->head=-x%p\n",
-			(void *) queued_msg->skb->head);
+			(void *)queued_msg->skb->head);
 
 		dev_kfree_skb_any(queued_msg->skb);
 		kfree(queued_msg);
 	}
 }
 
-
 static void
 xpnet_send(struct sk_buff *skb, struct xpnet_pending_msg *queued_msg,
 	   u64 start_addr, u64 end_addr, u16 embedded_bytes, int dest_partid)
@@ -442,7 +421,6 @@ xpnet_send(struct sk_buff *skb, struct x
 	struct xpnet_message *msg;
 	enum xp_retval ret;
 
-
 	ret = xpc_allocate(dest_partid, XPC_NET_CHANNEL, XPC_NOWAIT,
 			   (void **)&msg);
 	if (unlikely(ret != xpSuccess))
@@ -478,7 +456,6 @@ xpnet_send(struct sk_buff *skb, struct x
 		atomic_dec(&queued_msg->use_count);
 }
 
-
 /*
  * Network layer has formatted a packet (skb) and is ready to place it
  * "on the wire".  Prepare and send an xpnet_message to all partitions
@@ -497,9 +474,8 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	struct xpnet_dev_private *priv = (struct xpnet_dev_private *)dev->priv;
 	u16 embedded_bytes = 0;
 
-
 	dev_dbg(xpnet, ">skb->head=0x%p skb->data=0x%p skb->tail=0x%p "
-		"skb->end=0x%p skb->len=%d\n", (void *) skb->head,
+		"skb->end=0x%p skb->len=%d\n", (void *)skb->head,
 		(void *)skb->data, skb_tail_pointer(skb), skb_end_pointer(skb),
 		skb->len);
 
@@ -517,16 +493,15 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	queued_msg = kmalloc(sizeof(struct xpnet_pending_msg), GFP_ATOMIC);
 	if (queued_msg == NULL) {
 		dev_warn(xpnet, "failed to kmalloc %ld bytes; dropping "
-			"packet\n", sizeof(struct xpnet_pending_msg));
+			 "packet\n", sizeof(struct xpnet_pending_msg));
 
 		priv->stats.tx_errors++;
 
 		return -ENOMEM;
 	}
 
-
 	/* get the beginning of the first cacheline and end of last */
-	start_addr = ((u64) skb->data & ~(L1_CACHE_BYTES - 1));
+	start_addr = ((u64)skb->data & ~(L1_CACHE_BYTES - 1));
 	end_addr = L1_CACHE_ALIGN((u64)skb_tail_pointer(skb));
 
 	/* calculate how many bytes to embed in the XPC message */
@@ -535,7 +510,6 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 		embedded_bytes = skb->len;
 	}
 
-
 	/*
 	 * Since the send occurs asynchronously, we set the count to one
 	 * and begin sending.  Any sends that happen to complete before
@@ -550,7 +524,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 		/* we are being asked to broadcast to all partitions */
 		for_each_bit(dest_partid,
 			     (unsigned long *)xpnet_broadcast_partitions,
-							XP_NPARTITIONS) {
+			     XP_NPARTITIONS) {
 			xpnet_send(skb, queued_msg, start_addr, end_addr,
 				   embedded_bytes, dest_partid);
 		}
@@ -577,7 +551,6 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	return 0;
 }
 
-
 /*
  * Deal with transmit timeouts coming from the network layer.
  */
@@ -586,21 +559,18 @@ xpnet_dev_tx_timeout(struct net_device *
 {
 	struct xpnet_dev_private *priv;
 
-
-	priv = (struct xpnet_dev_private *) dev->priv;
+	priv = (struct xpnet_dev_private *)dev->priv;
 
 	priv->stats.tx_errors++;
 	return;
 }
 
-
 static int __init
 xpnet_init(void)
 {
 	short partid;
 	int result = -ENOMEM;
 
-
 	if (!is_shub() && !is_uv()) {
 		return -ENODEV;
 	}
@@ -633,7 +603,7 @@ xpnet_init(void)
 	 * MAC addresses.  We chose the first octet of the MAC to be unlikely
 	 * to collide with any vendor's officially issued MAC.
 	 */
-	xpnet_device->dev_addr[0] = 0x02;  /* locally administered, no OUI */
+	xpnet_device->dev_addr[0] = 0x02;	/* locally administered, no OUI */
 
 	partid = xp_partition_id;
 
@@ -660,23 +630,22 @@ xpnet_init(void)
 
 	return result;
 }
-module_init(xpnet_init);
 
+module_init(xpnet_init);
 
 static void __exit
 xpnet_exit(void)
 {
 	dev_info(xpnet, "unregistering network device %s\n",
-		xpnet_device[0].name);
+		 xpnet_device[0].name);
 
 	unregister_netdev(xpnet_device);
 
 	free_netdev(xpnet_device);
 }
-module_exit(xpnet_exit);
 
+module_exit(xpnet_exit);
 
 MODULE_AUTHOR("Silicon Graphics, Inc.");
 MODULE_DESCRIPTION("Cross Partition Network adapter (XPNET)");
 MODULE_LICENSE("GPL");
-
