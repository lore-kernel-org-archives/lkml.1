Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbYBOSEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbYBOSEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYBOSD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:03:57 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:34472 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYBOSD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:03:56 -0500
Date: Fri, 15 Feb 2008 12:03:41 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 1/5] IPMI: convert message handler defines to an enum
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Reply-to: minyard@acm.org
Message-id: <20080215180341.GA29755@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Convert the #defines for statistics into an enum in the IPMI message
handler.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
Ok to merge into ipmi-convert-locked-counters-to-atomics.patch

Index: linux-2.6.24/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_msghandler.c
@@ -189,90 +189,99 @@ struct bmc_device
  * Various statistics for IPMI, these index stats[] in the ipmi_smi
  * structure.
  */
-/* Commands we got from the user that were invalid. */
-#define IPMI_STAT_sent_invalid_commands			0
+enum ipmi_stat_indexes {
+	/* Commands we got from the user that were invalid. */
+	IPMI_STAT_sent_invalid_commands = 0,
 
-/* Commands we sent to the MC. */
-#define IPMI_STAT_sent_local_commands			1
+	/* Commands we sent to the MC. */
+	IPMI_STAT_sent_local_commands,
 
-/* Responses from the MC that were delivered to a user. */
-#define IPMI_STAT_handled_local_responses		2
+	/* Responses from the MC that were delivered to a user. */
+	IPMI_STAT_handled_local_responses,
 
-/* Responses from the MC that were not delivered to a user. */
-#define IPMI_STAT_unhandled_local_responses		3
+	/* Responses from the MC that were not delivered to a user. */
+	IPMI_STAT_unhandled_local_responses,
 
-/* Commands we sent out to the IPMB bus. */
-#define IPMI_STAT_sent_ipmb_commands			4
+	/* Commands we sent out to the IPMB bus. */
+	IPMI_STAT_sent_ipmb_commands,
 
-/* Commands sent on the IPMB that had errors on the SEND CMD */
-#define IPMI_STAT_sent_ipmb_command_errs		5
+	/* Commands sent on the IPMB that had errors on the SEND CMD */
+	IPMI_STAT_sent_ipmb_command_errs,
 
-/* Each retransmit increments this count. */
-#define IPMI_STAT_retransmitted_ipmb_commands		6
+	/* Each retransmit increments this count. */
+	IPMI_STAT_retransmitted_ipmb_commands,
 
-/* When a message times out (runs out of retransmits) this is incremented. */
-#define IPMI_STAT_timed_out_ipmb_commands		7
+	/*
+	 * When a message times out (runs out of retransmits) this is
+	 * incremented.
+	 */
+	IPMI_STAT_timed_out_ipmb_commands,
 
-/*
- * This is like above, but for broadcasts.  Broadcasts are
- * *not* included in the above count (they are expected to
- * time out).
- */
-#define IPMI_STAT_timed_out_ipmb_broadcasts		8
+	/*
+	 * This is like above, but for broadcasts.  Broadcasts are
+	 * *not* included in the above count (they are expected to
+	 * time out).
+	 */
+	IPMI_STAT_timed_out_ipmb_broadcasts,
 
-/* Responses I have sent to the IPMB bus. */
-#define IPMI_STAT_sent_ipmb_responses			9
+	/* Responses I have sent to the IPMB bus. */
+	IPMI_STAT_sent_ipmb_responses,
 
-/* The response was delivered to the user. */
-#define IPMI_STAT_handled_ipmb_responses		10
+	/* The response was delivered to the user. */
+	IPMI_STAT_handled_ipmb_responses,
 
-/* The response had invalid data in it. */
-#define IPMI_STAT_invalid_ipmb_responses		11
+	/* The response had invalid data in it. */
+	IPMI_STAT_invalid_ipmb_responses,
 
-/* The response didn't have anyone waiting for it. */
-#define IPMI_STAT_unhandled_ipmb_responses		12
+	/* The response didn't have anyone waiting for it. */
+	IPMI_STAT_unhandled_ipmb_responses,
 
-/* Commands we sent out to the IPMB bus. */
-#define IPMI_STAT_sent_lan_commands			13
+	/* Commands we sent out to the IPMB bus. */
+	IPMI_STAT_sent_lan_commands,
 
-/* Commands sent on the IPMB that had errors on the SEND CMD */
-#define IPMI_STAT_sent_lan_command_errs			14
+	/* Commands sent on the IPMB that had errors on the SEND CMD */
+	IPMI_STAT_sent_lan_command_errs,
 
-/* Each retransmit increments this count. */
-#define IPMI_STAT_retransmitted_lan_commands		15
+	/* Each retransmit increments this count. */
+	IPMI_STAT_retransmitted_lan_commands,
 
-/* When a message times out (runs out of retransmits) this is incremented. */
-#define IPMI_STAT_timed_out_lan_commands		16
+	/*
+	 * When a message times out (runs out of retransmits) this is
+	 * incremented.
+	 */
+	IPMI_STAT_timed_out_lan_commands,
 
-/* Responses I have sent to the IPMB bus. */
-#define IPMI_STAT_sent_lan_responses			17
+	/* Responses I have sent to the IPMB bus. */
+	IPMI_STAT_sent_lan_responses,
 
-/* The response was delivered to the user. */
-#define IPMI_STAT_handled_lan_responses			18
+	/* The response was delivered to the user. */
+	IPMI_STAT_handled_lan_responses,
 
-/* The response had invalid data in it. */
-#define IPMI_STAT_invalid_lan_responses			19
+	/* The response had invalid data in it. */
+	IPMI_STAT_invalid_lan_responses,
 
-/* The response didn't have anyone waiting for it. */
-#define IPMI_STAT_unhandled_lan_responses		20
+	/* The response didn't have anyone waiting for it. */
+	IPMI_STAT_unhandled_lan_responses,
 
-/* The command was delivered to the user. */
-#define IPMI_STAT_handled_commands			21
+	/* The command was delivered to the user. */
+	IPMI_STAT_handled_commands,
 
-/* The command had invalid data in it. */
-#define IPMI_STAT_invalid_commands			22
+	/* The command had invalid data in it. */
+	IPMI_STAT_invalid_commands,
 
-/* The command didn't have anyone waiting for it. */
-#define IPMI_STAT_unhandled_commands			23
+	/* The command didn't have anyone waiting for it. */
+	IPMI_STAT_unhandled_commands,
 
-/* Invalid data in an event. */
-#define IPMI_STAT_invalid_events			24
+	/* Invalid data in an event. */
+	IPMI_STAT_invalid_events,
 
-/* Events that were received with the proper format. */
-#define IPMI_STAT_events				25
+	/* Events that were received with the proper format. */
+	IPMI_STAT_events,
 
-/* When you add a statistic, you must update this value. */
-#define IPMI_NUM_STATS					26
+
+	/* This *must* remain last, add new values above this. */
+	IPMI_NUM_STATS
+};
 
 
 #define IPMI_IPMB_NUM_SEQ	64
