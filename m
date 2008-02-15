Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYBOSFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYBOSFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbYBOSFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:05:42 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:63276 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbYBOSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:05:41 -0500
Date: Fri, 15 Feb 2008 12:05:24 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 2/5] IPMI: Convert system interface defines to an enum
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Reply-to: minyard@acm.org
Message-id: <20080215180524.GB29755@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Convert the #defines for statistics into an enum in the IPMI system
interface and remove the unused timeout_restart statistic.  And comment
what these statistics mean.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
Ok to merge into
ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch

Index: linux-2.6.24/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_si_intf.c
@@ -124,22 +124,50 @@ static struct device_driver ipmi_driver 
 /*
  * Indexes into stats[] in smi_info below.
  */
+enum si_stat_indexes {
+	/*
+	 * Number of times the driver requested a timer while an operation
+	 * was in progress.
+	 */
+	SI_STAT_short_timeouts = 0,
+
+	/*
+	 * Number of times the driver requested a timer while nothing was in
+	 * progress.
+	 */
+	SI_STAT_long_timeouts,
+
+	/* Number of times the interface was idle while being polled. */
+	SI_STAT_idles,
+
+	/* Number of interrupts the driver handled. */
+	SI_STAT_interrupts,
+
+	/* Number of time the driver got an ATTN from the hardware. */
+	SI_STAT_attentions,
 
-#define SI_STAT_short_timeouts		0
-#define SI_STAT_long_timeouts		1
-#define SI_STAT_timeout_restarts	2
-#define SI_STAT_idles			3
-#define SI_STAT_interrupts		4
-#define SI_STAT_attentions		5
-#define SI_STAT_flag_fetches		6
-#define SI_STAT_hosed_count		7
-#define SI_STAT_complete_transactions	8
-#define SI_STAT_events			9
-#define SI_STAT_watchdog_pretimeouts	10
-#define SI_STAT_incoming_messages	11
+	/* Number of times the driver requested flags from the hardware. */
+	SI_STAT_flag_fetches,
 
-/* If you add a stat, you must update this value. */
-#define SI_NUM_STATS			12
+	/* Number of times the hardware didn't follow the state machine. */
+	SI_STAT_hosed_count,
+
+	/* Number of completed messages. */
+	SI_STAT_complete_transactions,
+
+	/* Number of IPMI events received from the hardware. */
+	SI_STAT_events,
+
+	/* Number of watchdog pretimeouts. */
+	SI_STAT_watchdog_pretimeouts,
+
+	/* Number of asyncronous messages received. */
+	SI_STAT_incoming_messages,
+
+
+	/* This *must* remain last, add new values above this. */
+	SI_NUM_STATS
+};
 
 struct smi_info
 {
@@ -2400,8 +2428,6 @@ static int stat_file_read_proc(char *pag
 		       smi_get_stat(smi, short_timeouts));
 	out += sprintf(out, "long_timeouts:         %u\n",
 		       smi_get_stat(smi, long_timeouts));
-	out += sprintf(out, "timeout_restarts:      %u\n",
-		       smi_get_stat(smi, timeout_restarts));
 	out += sprintf(out, "idles:                 %u\n",
 		       smi_get_stat(smi, idles));
 	out += sprintf(out, "interrupts:            %u\n",
