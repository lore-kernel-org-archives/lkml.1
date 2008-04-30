Return-Path: <linux-kernel-owner+w=401wt.eu-S933899AbYD3Usc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbYD3Usc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765202AbYD3UsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:48:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44000 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764245AbYD3UsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:48:17 -0400
Date: Wed, 30 Apr 2008 15:48:15 -0500
From: Dean Nelson <dcn@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch] replace partid_t by short in drivers/misc/sgi-xp
Message-ID: <20080430204815.GA8053@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for supporting greater than 64 partitions replace partid_t
by short in drivers/misc/sgi-xp.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Acked-by: Robin Holt <holt@sgi.com>

---

 drivers/misc/sgi-xp/xp.h            |   34 ++++++++++++++++----------------
 drivers/misc/sgi-xp/xp_main.c       |   30 ++++++++++++++--------------
 drivers/misc/sgi-xp/xpc.h           |   20 +++++++++---------
 drivers/misc/sgi-xp/xpc_channel.c   |   20 +++++++++---------
 drivers/misc/sgi-xp/xpc_main.c      |   16 +++++++--------
 drivers/misc/sgi-xp/xpc_partition.c |   10 ++++-----
 drivers/misc/sgi-xp/xpnet.c         |    8 +++----
 7 files changed, 69 insertions(+), 69 deletions(-)

Index: linux-2.6/drivers/misc/sgi-xp/xp.h
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xp.h	2008-04-30 15:24:23.937831251 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xp.h	2008-04-30 15:32:28.745402450 -0500
@@ -264,7 +264,7 @@ enum xp_retval {
  * When a failure reason code is received, one can assume that the channel
  * is not connected.
  */
-typedef void (*xpc_channel_func) (enum xp_retval reason, partid_t partid,
+typedef void (*xpc_channel_func) (enum xp_retval reason, short partid,
 				  int ch_number, void *data, void *key);
 
 /*
@@ -286,7 +286,7 @@ typedef void (*xpc_channel_func) (enum x
  *
  * All other reason codes indicate failure.
  */
-typedef void (*xpc_notify_func) (enum xp_retval reason, partid_t partid,
+typedef void (*xpc_notify_func) (enum xp_retval reason, short partid,
 				 int ch_number, void *key);
 
 /*
@@ -322,24 +322,24 @@ struct xpc_registration {
 struct xpc_interface {
 	void (*connect) (int);
 	void (*disconnect) (int);
-	enum xp_retval (*allocate) (partid_t, int, u32, void **);
-	enum xp_retval (*send) (partid_t, int, void *);
-	enum xp_retval (*send_notify) (partid_t, int, void *,
+	enum xp_retval (*allocate) (short, int, u32, void **);
+	enum xp_retval (*send) (short, int, void *);
+	enum xp_retval (*send_notify) (short, int, void *,
 					xpc_notify_func, void *);
-	void (*received) (partid_t, int, void *);
-	enum xp_retval (*partid_to_nasids) (partid_t, void *);
+	void (*received) (short, int, void *);
+	enum xp_retval (*partid_to_nasids) (short, void *);
 };
 
 extern struct xpc_interface xpc_interface;
 
 extern void xpc_set_interface(void (*)(int),
 			      void (*)(int),
-			      enum xp_retval (*)(partid_t, int, u32, void **),
-			      enum xp_retval (*)(partid_t, int, void *),
-			      enum xp_retval (*)(partid_t, int, void *,
+			      enum xp_retval (*)(short, int, u32, void **),
+			      enum xp_retval (*)(short, int, void *),
+			      enum xp_retval (*)(short, int, void *,
 						  xpc_notify_func, void *),
-			      void (*)(partid_t, int, void *),
-			      enum xp_retval (*)(partid_t, void *));
+			      void (*)(short, int, void *),
+			      enum xp_retval (*)(short, void *));
 extern void xpc_clear_interface(void);
 
 extern enum xp_retval xpc_connect(int, xpc_channel_func, void *, u16,
@@ -347,32 +347,32 @@ extern enum xp_retval xpc_connect(int, x
 extern void xpc_disconnect(int);
 
 static inline enum xp_retval
-xpc_allocate(partid_t partid, int ch_number, u32 flags, void **payload)
+xpc_allocate(short partid, int ch_number, u32 flags, void **payload)
 {
 	return xpc_interface.allocate(partid, ch_number, flags, payload);
 }
 
 static inline enum xp_retval
-xpc_send(partid_t partid, int ch_number, void *payload)
+xpc_send(short partid, int ch_number, void *payload)
 {
 	return xpc_interface.send(partid, ch_number, payload);
 }
 
 static inline enum xp_retval
-xpc_send_notify(partid_t partid, int ch_number, void *payload,
+xpc_send_notify(short partid, int ch_number, void *payload,
 		xpc_notify_func func, void *key)
 {
 	return xpc_interface.send_notify(partid, ch_number, payload, func, key);
 }
 
 static inline void
-xpc_received(partid_t partid, int ch_number, void *payload)
+xpc_received(short partid, int ch_number, void *payload)
 {
 	return xpc_interface.received(partid, ch_number, payload);
 }
 
 static inline enum xp_retval
-xpc_partid_to_nasids(partid_t partid, void *nasids)
+xpc_partid_to_nasids(short partid, void *nasids)
 {
 	return xpc_interface.partid_to_nasids(partid, nasids);
 }
Index: linux-2.6/drivers/misc/sgi-xp/xp_main.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xp_main.c	2008-04-30 15:24:23.853820934 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xp_main.c	2008-04-30 15:33:46.410951881 -0500
@@ -51,12 +51,12 @@ xpc_notloaded(void)
 struct xpc_interface xpc_interface = {
 	(void (*)(int))xpc_notloaded,
 	(void (*)(int))xpc_notloaded,
-	(enum xp_retval(*)(partid_t, int, u32, void **))xpc_notloaded,
-	(enum xp_retval(*)(partid_t, int, void *))xpc_notloaded,
-	(enum xp_retval(*)(partid_t, int, void *, xpc_notify_func, void *))
+	(enum xp_retval(*)(short, int, u32, void **))xpc_notloaded,
+	(enum xp_retval(*)(short, int, void *))xpc_notloaded,
+	(enum xp_retval(*)(short, int, void *, xpc_notify_func, void *))
 	    xpc_notloaded,
-	(void (*)(partid_t, int, void *))xpc_notloaded,
-	(enum xp_retval(*)(partid_t, void *))xpc_notloaded
+	(void (*)(short, int, void *))xpc_notloaded,
+	(enum xp_retval(*)(short, void *))xpc_notloaded
 };
 EXPORT_SYMBOL_GPL(xpc_interface);
 
@@ -66,12 +66,12 @@ EXPORT_SYMBOL_GPL(xpc_interface);
 void
 xpc_set_interface(void (*connect) (int),
 		  void (*disconnect) (int),
-		  enum xp_retval (*allocate) (partid_t, int, u32, void **),
-		  enum xp_retval (*send) (partid_t, int, void *),
-		  enum xp_retval (*send_notify) (partid_t, int, void *,
+		  enum xp_retval (*allocate) (short, int, u32, void **),
+		  enum xp_retval (*send) (short, int, void *),
+		  enum xp_retval (*send_notify) (short, int, void *,
 						  xpc_notify_func, void *),
-		  void (*received) (partid_t, int, void *),
-		  enum xp_retval (*partid_to_nasids) (partid_t, void *))
+		  void (*received) (short, int, void *),
+		  enum xp_retval (*partid_to_nasids) (short, void *))
 {
 	xpc_interface.connect = connect;
 	xpc_interface.disconnect = disconnect;
@@ -91,16 +91,16 @@ xpc_clear_interface(void)
 {
 	xpc_interface.connect = (void (*)(int))xpc_notloaded;
 	xpc_interface.disconnect = (void (*)(int))xpc_notloaded;
-	xpc_interface.allocate = (enum xp_retval(*)(partid_t, int, u32,
+	xpc_interface.allocate = (enum xp_retval(*)(short, int, u32,
 						     void **))xpc_notloaded;
-	xpc_interface.send = (enum xp_retval(*)(partid_t, int, void *))
+	xpc_interface.send = (enum xp_retval(*)(short, int, void *))
 	    xpc_notloaded;
-	xpc_interface.send_notify = (enum xp_retval(*)(partid_t, int, void *,
+	xpc_interface.send_notify = (enum xp_retval(*)(short, int, void *,
 							xpc_notify_func,
 							void *))xpc_notloaded;
-	xpc_interface.received = (void (*)(partid_t, int, void *))
+	xpc_interface.received = (void (*)(short, int, void *))
 	    xpc_notloaded;
-	xpc_interface.partid_to_nasids = (enum xp_retval(*)(partid_t, void *))
+	xpc_interface.partid_to_nasids = (enum xp_retval(*)(short, void *))
 	    xpc_notloaded;
 }
 EXPORT_SYMBOL_GPL(xpc_clear_interface);
Index: linux-2.6/drivers/misc/sgi-xp/xpc.h
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc.h	2008-04-30 15:24:23.861821917 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc.h	2008-04-30 15:28:42.409582705 -0500
@@ -172,13 +172,13 @@ struct xpc_vars {
 			(_version >= _XPC_VERSION(3, 1))
 
 static inline int
-xpc_hb_allowed(partid_t partid, struct xpc_vars *vars)
+xpc_hb_allowed(short partid, struct xpc_vars *vars)
 {
 	return ((vars->heartbeating_to_mask & (1UL << partid)) != 0);
 }
 
 static inline void
-xpc_allow_hb(partid_t partid, struct xpc_vars *vars)
+xpc_allow_hb(short partid, struct xpc_vars *vars)
 {
 	u64 old_mask, new_mask;
 
@@ -190,7 +190,7 @@ xpc_allow_hb(partid_t partid, struct xpc
 }
 
 static inline void
-xpc_disallow_hb(partid_t partid, struct xpc_vars *vars)
+xpc_disallow_hb(short partid, struct xpc_vars *vars)
 {
 	u64 old_mask, new_mask;
 
@@ -408,7 +408,7 @@ struct xpc_notify {
  *	messages.
  */
 struct xpc_channel {
-	partid_t partid;	/* ID of remote partition connected */
+	short partid;		/* ID of remote partition connected */
 	spinlock_t lock;	/* lock for updating this structure */
 	u32 flags;		/* general flags */
 
@@ -615,7 +615,7 @@ struct xpc_partition {
 /* interval in seconds to print 'waiting disengagement' messages */
 #define XPC_DISENGAGE_PRINTMSG_INTERVAL		10
 
-#define XPC_PARTID(_p)	((partid_t) ((_p) - &xpc_partitions[0]))
+#define XPC_PARTID(_p)	((short)((_p) - &xpc_partitions[0]))
 
 /* found in xp_main.c */
 extern struct xpc_registration xpc_registrations[];
@@ -652,16 +652,16 @@ extern void xpc_discovery(void);
 extern void xpc_check_remote_hb(void);
 extern void xpc_deactivate_partition(const int, struct xpc_partition *,
 				     enum xp_retval);
-extern enum xp_retval xpc_initiate_partid_to_nasids(partid_t, void *);
+extern enum xp_retval xpc_initiate_partid_to_nasids(short, void *);
 
 /* found in xpc_channel.c */
 extern void xpc_initiate_connect(int);
 extern void xpc_initiate_disconnect(int);
-extern enum xp_retval xpc_initiate_allocate(partid_t, int, u32, void **);
-extern enum xp_retval xpc_initiate_send(partid_t, int, void *);
-extern enum xp_retval xpc_initiate_send_notify(partid_t, int, void *,
+extern enum xp_retval xpc_initiate_allocate(short, int, u32, void **);
+extern enum xp_retval xpc_initiate_send(short, int, void *);
+extern enum xp_retval xpc_initiate_send_notify(short, int, void *,
 					       xpc_notify_func, void *);
-extern void xpc_initiate_received(partid_t, int, void *);
+extern void xpc_initiate_received(short, int, void *);
 extern enum xp_retval xpc_setup_infrastructure(struct xpc_partition *);
 extern enum xp_retval xpc_pull_remote_vars_part(struct xpc_partition *);
 extern void xpc_process_channel_activity(struct xpc_partition *);
Index: linux-2.6/drivers/misc/sgi-xp/xpc_channel.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc_channel.c	2008-04-30 15:24:23.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc_channel.c	2008-04-30 15:25:18.036475227 -0500
@@ -53,7 +53,7 @@ xpc_kzalloc_cacheline_aligned(size_t siz
  * Set up the initial values for the XPartition Communication channels.
  */
 static void
-xpc_initialize_channels(struct xpc_partition *part, partid_t partid)
+xpc_initialize_channels(struct xpc_partition *part, short partid)
 {
 	int ch_number;
 	struct xpc_channel *ch;
@@ -95,7 +95,7 @@ xpc_setup_infrastructure(struct xpc_part
 {
 	int ret, cpuid;
 	struct timer_list *timer;
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 
 	/*
 	 * Zero out MOST of the entry for this partition. Only the fields
@@ -290,7 +290,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 	    (struct xpc_vars_part *)L1_CACHE_ALIGN((u64)buffer);
 	struct xpc_vars_part *pulled_entry;
 	u64 remote_entry_cacheline_pa, remote_entry_pa;
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 	enum xp_retval ret;
 
 	/* pull the cacheline that contains the variables we're interested in */
@@ -1375,7 +1375,7 @@ xpc_partition_going_down(struct xpc_part
 void
 xpc_teardown_infrastructure(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 
 	/*
 	 * We start off by making this partition inaccessible to local
@@ -1428,7 +1428,7 @@ xpc_teardown_infrastructure(struct xpc_p
 void
 xpc_initiate_connect(int ch_number)
 {
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
@@ -1484,7 +1484,7 @@ void
 xpc_initiate_disconnect(int ch_number)
 {
 	unsigned long irq_flags;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
@@ -1728,7 +1728,7 @@ xpc_allocate_msg(struct xpc_channel *ch,
  * 	          return) in which the user-defined message is constructed.
  */
 enum xp_retval
-xpc_initiate_allocate(partid_t partid, int ch_number, u32 flags, void **payload)
+xpc_initiate_allocate(short partid, int ch_number, u32 flags, void **payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	enum xp_retval ret = xpUnknownReason;
@@ -1909,7 +1909,7 @@ xpc_send_msg(struct xpc_channel *ch, str
  *			xpc_initiate_allocate().
  */
 enum xp_retval
-xpc_initiate_send(partid_t partid, int ch_number, void *payload)
+xpc_initiate_send(short partid, int ch_number, void *payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
@@ -1958,7 +1958,7 @@ xpc_initiate_send(partid_t partid, int c
  *	key - user-defined key to be passed to the function when it's called.
  */
 enum xp_retval
-xpc_initiate_send_notify(partid_t partid, int ch_number, void *payload,
+xpc_initiate_send_notify(short partid, int ch_number, void *payload,
 			 xpc_notify_func func, void *key)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
@@ -2203,7 +2203,7 @@ xpc_acknowledge_msgs(struct xpc_channel 
  *			xpc_initiate_allocate().
  */
 void
-xpc_initiate_received(partid_t partid, int ch_number, void *payload)
+xpc_initiate_received(short partid, int ch_number, void *payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_channel *ch;
Index: linux-2.6/drivers/misc/sgi-xp/xpc_main.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc_main.c	2008-04-30 15:24:23.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc_main.c	2008-04-30 15:25:37.438858295 -0500
@@ -429,7 +429,7 @@ xpc_partition_up(struct xpc_partition *p
 static int
 xpc_activating(void *__partid)
 {
-	partid_t partid = (u64)__partid;
+	short partid = (u64)__partid;
 	struct xpc_partition *part = &xpc_partitions[partid];
 	unsigned long irq_flags;
 
@@ -499,7 +499,7 @@ xpc_activating(void *__partid)
 void
 xpc_activate_partition(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 	unsigned long irq_flags;
 	struct task_struct *kthread;
 
@@ -541,7 +541,7 @@ xpc_activate_partition(struct xpc_partit
 irqreturn_t
 xpc_notify_IRQ_handler(int irq, void *dev_id)
 {
-	partid_t partid = (partid_t) (u64)dev_id;
+	short partid = (short)(u64)dev_id;
 	struct xpc_partition *part = &xpc_partitions[partid];
 
 	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
@@ -643,7 +643,7 @@ xpc_kthread_waitmsgs(struct xpc_partitio
 static int
 xpc_kthread_start(void *args)
 {
-	partid_t partid = XPC_UNPACK_ARG1(args);
+	short partid = XPC_UNPACK_ARG1(args);
 	u16 ch_number = XPC_UNPACK_ARG2(args);
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_channel *ch;
@@ -809,7 +809,7 @@ void
 xpc_disconnect_wait(int ch_number)
 {
 	unsigned long irq_flags;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 	int wakeup_channel_mgr;
@@ -859,7 +859,7 @@ xpc_disconnect_wait(int ch_number)
 static void
 xpc_do_exit(enum xp_retval reason)
 {
-	partid_t partid;
+	short partid;
 	int active_part_count, printed_waiting_msg = 0;
 	struct xpc_partition *part;
 	unsigned long printmsg_time, disengage_request_timeout = 0;
@@ -1008,7 +1008,7 @@ static void
 xpc_die_disengage(void)
 {
 	struct xpc_partition *part;
-	partid_t partid;
+	short partid;
 	unsigned long engaged;
 	long time, printmsg_time, disengage_request_timeout;
 
@@ -1124,7 +1124,7 @@ int __init
 xpc_init(void)
 {
 	int ret;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct task_struct *kthread;
 	size_t buf_size;
Index: linux-2.6/drivers/misc/sgi-xp/xpc_partition.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc_partition.c	2008-04-30 15:24:23.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc_partition.c	2008-04-30 15:25:48.912267553 -0500
@@ -403,7 +403,7 @@ xpc_check_remote_hb(void)
 {
 	struct xpc_vars *remote_vars;
 	struct xpc_partition *part;
-	partid_t partid;
+	short partid;
 	bte_result_t bres;
 
 	remote_vars = (struct xpc_vars *)xpc_remote_copy_buffer;
@@ -604,7 +604,7 @@ xpc_identify_act_IRQ_req(int nasid)
 	int reactivate = 0;
 	int stamp_diff;
 	struct timespec remote_rp_stamp = { 0, 0 };
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	enum xp_retval ret;
 
@@ -825,7 +825,7 @@ xpc_identify_act_IRQ_sender(void)
 int
 xpc_partition_disengaged(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 	int disengaged;
 
 	disengaged = (xpc_partition_engaged(1UL << partid) == 0);
@@ -982,7 +982,7 @@ xpc_discovery(void)
 	int max_regions;
 	int nasid;
 	struct xpc_rsvd_page *rp;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	u64 *discovered_nasids;
 	enum xp_retval ret;
@@ -1152,7 +1152,7 @@ xpc_discovery(void)
  * remote partition's reserved page.
  */
 enum xp_retval
-xpc_initiate_partid_to_nasids(partid_t partid, void *nasid_mask)
+xpc_initiate_partid_to_nasids(short partid, void *nasid_mask)
 {
 	struct xpc_partition *part;
 	u64 part_nasid_pa;
Index: linux-2.6/drivers/misc/sgi-xp/xpnet.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpnet.c	2008-04-30 15:24:23.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpnet.c	2008-04-30 15:25:58.481442948 -0500
@@ -166,7 +166,7 @@ struct device *xpnet = &xpnet_dbg_subnam
  * Packet was recevied by XPC and forwarded to us.
  */
 static void
-xpnet_receive(partid_t partid, int channel, struct xpnet_message *msg)
+xpnet_receive(short partid, int channel, struct xpnet_message *msg)
 {
 	struct sk_buff *skb;
 	bte_result_t bret;
@@ -282,7 +282,7 @@ xpnet_receive(partid_t partid, int chann
  * state or message reception on a connection.
  */
 static void
-xpnet_connection_activity(enum xp_retval reason, partid_t partid, int channel,
+xpnet_connection_activity(enum xp_retval reason, short partid, int channel,
 			  void *data, void *key)
 {
 	long bp;
@@ -407,7 +407,7 @@ xpnet_dev_get_stats(struct net_device *d
  * release the skb and then release our pending message structure.
  */
 static void
-xpnet_send_completed(enum xp_retval reason, partid_t partid, int channel,
+xpnet_send_completed(enum xp_retval reason, short partid, int channel,
 		     void *__qm)
 {
 	struct xpnet_pending_msg *queued_msg = (struct xpnet_pending_msg *)__qm;
@@ -444,7 +444,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	u64 start_addr, end_addr;
 	long dp;
 	u8 second_mac_octet;
-	partid_t dest_partid;
+	short dest_partid;
 	struct xpnet_dev_private *priv;
 	u16 embedded_bytes;
 
