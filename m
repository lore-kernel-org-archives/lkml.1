Return-Path: <linux-kernel-owner+w=401wt.eu-S1946392AbXBQDYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946392AbXBQDYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 22:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946395AbXBQDYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 22:24:05 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:35612 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946394AbXBQDYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 22:24:04 -0500
Date: Sat, 17 Feb 2007 03:23:40 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix build errors if bitop functions are do {} while macros.
Message-ID: <20070217032339.GA22079@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If one of clear_bit, change_bit or set_bit is defined as a do { } while (0)
function usage of these functions in parenthesis like

  (foo_bit(23, &var))

while be expaned to something like

  (do { ... } while (0)}).

resulting in a build error.  This patch removes the useless parenthesis.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3f1b382..5231ed7 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -297,17 +297,17 @@ static int initialising = 1;
 #define DRS (&drive_state[current_drive])
 #define DRWE (&write_errors[current_drive])
 #define FDCS (&fdc_state[fdc])
-#define CLEARF(x) (clear_bit(x##_BIT, &DRS->flags))
-#define SETF(x) (set_bit(x##_BIT, &DRS->flags))
-#define TESTF(x) (test_bit(x##_BIT, &DRS->flags))
+#define CLEARF(x) clear_bit(x##_BIT, &DRS->flags)
+#define SETF(x) set_bit(x##_BIT, &DRS->flags)
+#define TESTF(x) test_bit(x##_BIT, &DRS->flags)
 
 #define UDP (&drive_params[drive])
 #define UDRS (&drive_state[drive])
 #define UDRWE (&write_errors[drive])
 #define UFDCS (&fdc_state[FDC(drive)])
-#define UCLEARF(x) (clear_bit(x##_BIT, &UDRS->flags))
-#define USETF(x) (set_bit(x##_BIT, &UDRS->flags))
-#define UTESTF(x) (test_bit(x##_BIT, &UDRS->flags))
+#define UCLEARF(x) clear_bit(x##_BIT, &UDRS->flags)
+#define USETF(x) set_bit(x##_BIT, &UDRS->flags)
+#define UTESTF(x) test_bit(x##_BIT, &UDRS->flags)
 
 #define DPRINT(format, args...) printk(DEVICE_NAME "%d: " format, current_drive , ## args)
 
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index de9fc57..3069ecc 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -150,10 +150,10 @@ struct rpc_call_ops {
 #define RPC_TASK_HAS_TIMER	3
 #define RPC_TASK_ACTIVE		4
 
-#define RPC_IS_RUNNING(t)	(test_bit(RPC_TASK_RUNNING, &(t)->tk_runstate))
-#define rpc_set_running(t)	(set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate))
+#define RPC_IS_RUNNING(t)	test_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
+#define rpc_set_running(t)	set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
 #define rpc_test_and_set_running(t) \
-				(test_and_set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate))
+				test_and_set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
 #define rpc_clear_running(t)	\
 	do { \
 		smp_mb__before_clear_bit(); \
@@ -161,8 +161,8 @@ struct rpc_call_ops {
 		smp_mb__after_clear_bit(); \
 	} while (0)
 
-#define RPC_IS_QUEUED(t)	(test_bit(RPC_TASK_QUEUED, &(t)->tk_runstate))
-#define rpc_set_queued(t)	(set_bit(RPC_TASK_QUEUED, &(t)->tk_runstate))
+#define RPC_IS_QUEUED(t)	test_bit(RPC_TASK_QUEUED, &(t)->tk_runstate)
+#define rpc_set_queued(t)	set_bit(RPC_TASK_QUEUED, &(t)->tk_runstate)
 #define rpc_clear_queued(t)	\
 	do { \
 		smp_mb__before_clear_bit(); \
@@ -179,7 +179,7 @@ struct rpc_call_ops {
 		smp_mb__after_clear_bit(); \
 	} while (0)
 
-#define RPC_IS_ACTIVATED(t)	(test_bit(RPC_TASK_ACTIVE, &(t)->tk_runstate))
+#define RPC_IS_ACTIVATED(t)	test_bit(RPC_TASK_ACTIVE, &(t)->tk_runstate)
 
 /*
  * Task priorities.
