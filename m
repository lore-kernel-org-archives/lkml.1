Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbXHXD4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbXHXD4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 23:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXHXD4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 23:56:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33955 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXHXD4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 23:56:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, samuel@sortiz.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] sysctl: Properly register the irda binary sysctl numbers.
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<23568.1187876026@turing-police.cc.vt.edu>
	<20070823141652.d488a6e0.akpm@linux-foundation.org>
Date: Thu, 23 Aug 2007 21:53:53 -0600
In-Reply-To: <20070823141652.d488a6e0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 23 Aug 2007 14:16:52 -0700")
Message-ID: <m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Grumble.  These numbers should have been in sysctl.h from the
beginning if we ever expected anyone to use them.  Oh well put
them there now so we can find them and make maintenance easier.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/sysctl.h |   20 ++++++++++++++++++++
 net/irda/irsysctl.c    |   34 ++++++++++++++--------------------
 2 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 88f0941..77c9ae2 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -238,6 +238,7 @@ enum
 	NET_LLC=18,
 	NET_NETFILTER=19,
 	NET_DCCP=20,
+	NET_IRDA=412,
 };
 
 /* /proc/sys/kernel/random */
@@ -795,6 +796,25 @@ enum {
 	NET_BRIDGE_NF_FILTER_PPPOE_TAGGED = 5,
 };
 
+/* proc/sys/net/irda */
+enum { 
+	NET_IRDA_DISCOVERY=1,
+	NET_IRDA_DEVNAME=2, 
+	NET_IRDA_DEBUG=3, 
+	NET_IRDA_FAST_POLL=4,
+	NET_IRDA_DISCOVERY_SLOTS=5,
+	NET_IRDA_DISCOVERY_TIMEOUT=6,
+	NET_IRDA_SLOT_TIMEOUT=7,
+	NET_IRDA_MAX_BAUD_RATE=8,
+	NET_IRDA_MIN_TX_TURN_TIME=9,
+	NET_IRDA_MAX_TX_DATA_SIZE=10,
+	NET_IRDA_MAX_TX_WINDOW=11,
+	NET_IRDA_MAX_NOREPLY_TIME=12,
+	NET_IRDA_WARN_NOREPLY_TIME=13,
+	NET_IRDA_LAP_KEEPALIVE_TIME=14,
+};
+
+
 /* CTL_FS names: */
 enum
 {
diff --git a/net/irda/irsysctl.c b/net/irda/irsysctl.c
index 957e04f..525343a 100644
--- a/net/irda/irsysctl.c
+++ b/net/irda/irsysctl.c
@@ -31,12 +31,6 @@
 #include <net/irda/irda.h>		/* irda_debug */
 #include <net/irda/irias_object.h>
 
-#define NET_IRDA 412 /* Random number */
-enum { DISCOVERY=1, DEVNAME, DEBUG, FAST_POLL, DISCOVERY_SLOTS,
-       DISCOVERY_TIMEOUT, SLOT_TIMEOUT, MAX_BAUD_RATE, MIN_TX_TURN_TIME,
-       MAX_TX_DATA_SIZE, MAX_TX_WINDOW, MAX_NOREPLY_TIME, WARN_NOREPLY_TIME,
-       LAP_KEEPALIVE_TIME };
-
 extern int  sysctl_discovery;
 extern int  sysctl_discovery_slots;
 extern int  sysctl_discovery_timeout;
@@ -94,7 +88,7 @@ static int do_devname(ctl_table *table, int write, struct file *filp,
 /* One file */
 static ctl_table irda_table[] = {
 	{
-		.ctl_name	= DISCOVERY,
+		.ctl_name	= NET_IRDA_DISCOVERY,
 		.procname	= "discovery",
 		.data		= &sysctl_discovery,
 		.maxlen		= sizeof(int),
@@ -102,7 +96,7 @@ static ctl_table irda_table[] = {
 		.proc_handler	= &proc_dointvec
 	},
 	{
-		.ctl_name	= DEVNAME,
+		.ctl_name	= NET_IRDA_DEVNAME,
 		.procname	= "devname",
 		.data		= sysctl_devname,
 		.maxlen		= 65,
@@ -112,7 +106,7 @@ static ctl_table irda_table[] = {
 	},
 #ifdef CONFIG_IRDA_DEBUG
 	{
-		.ctl_name	= DEBUG,
+		.ctl_name	= NET_IRDA_DEBUG,
 		.procname	= "debug",
 		.data		= &irda_debug,
 		.maxlen		= sizeof(int),
@@ -122,7 +116,7 @@ static ctl_table irda_table[] = {
 #endif
 #ifdef CONFIG_IRDA_FAST_RR
 	{
-		.ctl_name	= FAST_POLL,
+		.ctl_name	= NET_IRDA_FAST_POLL,
 		.procname	= "fast_poll_increase",
 		.data		= &sysctl_fast_poll_increase,
 		.maxlen		= sizeof(int),
@@ -131,7 +125,7 @@ static ctl_table irda_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= DISCOVERY_SLOTS,
+		.ctl_name	= NET_IRDA_DISCOVERY_SLOTS,
 		.procname	= "discovery_slots",
 		.data		= &sysctl_discovery_slots,
 		.maxlen		= sizeof(int),
@@ -142,7 +136,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_discovery_slots
 	},
 	{
-		.ctl_name	= DISCOVERY_TIMEOUT,
+		.ctl_name	= NET_IRDA_DISCOVERY_TIMEOUT,
 		.procname	= "discovery_timeout",
 		.data		= &sysctl_discovery_timeout,
 		.maxlen		= sizeof(int),
@@ -150,7 +144,7 @@ static ctl_table irda_table[] = {
 		.proc_handler	= &proc_dointvec
 	},
 	{
-		.ctl_name	= SLOT_TIMEOUT,
+		.ctl_name	= NET_IRDA_SLOT_TIMEOUT,
 		.procname	= "slot_timeout",
 		.data		= &sysctl_slot_timeout,
 		.maxlen		= sizeof(int),
@@ -161,7 +155,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_slot_timeout
 	},
 	{
-		.ctl_name	= MAX_BAUD_RATE,
+		.ctl_name	= NET_IRDA_MAX_BAUD_RATE,
 		.procname	= "max_baud_rate",
 		.data		= &sysctl_max_baud_rate,
 		.maxlen		= sizeof(int),
@@ -172,7 +166,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_max_baud_rate
 	},
 	{
-		.ctl_name	= MIN_TX_TURN_TIME,
+		.ctl_name	= NET_IRDA_MIN_TX_TURN_TIME,
 		.procname	= "min_tx_turn_time",
 		.data		= &sysctl_min_tx_turn_time,
 		.maxlen		= sizeof(int),
@@ -183,7 +177,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_min_tx_turn_time
 	},
 	{
-		.ctl_name	= MAX_TX_DATA_SIZE,
+		.ctl_name	= NET_IRDA_MAX_TX_DATA_SIZE,
 		.procname	= "max_tx_data_size",
 		.data		= &sysctl_max_tx_data_size,
 		.maxlen		= sizeof(int),
@@ -194,7 +188,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_max_tx_data_size
 	},
 	{
-		.ctl_name	= MAX_TX_WINDOW,
+		.ctl_name	= NET_IRDA_MAX_TX_WINDOW,
 		.procname	= "max_tx_window",
 		.data		= &sysctl_max_tx_window,
 		.maxlen		= sizeof(int),
@@ -205,7 +199,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_max_tx_window
 	},
 	{
-		.ctl_name	= MAX_NOREPLY_TIME,
+		.ctl_name	= NET_IRDA_MAX_NOREPLY_TIME,
 		.procname	= "max_noreply_time",
 		.data		= &sysctl_max_noreply_time,
 		.maxlen		= sizeof(int),
@@ -216,7 +210,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_max_noreply_time
 	},
 	{
-		.ctl_name	= WARN_NOREPLY_TIME,
+		.ctl_name	= NET_IRDA_WARN_NOREPLY_TIME,
 		.procname	= "warn_noreply_time",
 		.data		= &sysctl_warn_noreply_time,
 		.maxlen		= sizeof(int),
@@ -227,7 +221,7 @@ static ctl_table irda_table[] = {
 		.extra2		= &max_warn_noreply_time
 	},
 	{
-		.ctl_name	= LAP_KEEPALIVE_TIME,
+		.ctl_name	= NET_IRDA_LAP_KEEPALIVE_TIME,
 		.procname	= "lap_keepalive_time",
 		.data		= &sysctl_lap_keepalive_time,
 		.maxlen		= sizeof(int),
-- 
1.5.1.1.181.g2de0

