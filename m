Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYL3OqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYL3OqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 09:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYL3OqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 09:46:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:50310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYL3OqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 09:46:03 -0500
Subject: [PATCH] x86: uv_bau.h fix dubious bitfield
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, cpw@sgi.com,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Tue, 30 Dec 2008 20:13:49 +0530
Message-Id: <1230648229.10677.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid sparse warnings

declare bitfield as unsigned to avoid dubious bitfield issue

 CHECK   arch/x86/kernel/tlb_64.c
arch/x86/include/asm/uv/uv_bau.h:136:22: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:138:25: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:140:15: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:143:14: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:146:14: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:149:18: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:151:18: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:155:14: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:159:18: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:173:19: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:181:16: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:185:18: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:188:16: error: dubious one-bit signed bitfield

 CHECK   arch/x86/kernel/tlb_uv.c
arch/x86/include/asm/uv/uv_bau.h:136:22: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:138:25: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:140:15: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:143:14: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:146:14: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:149:18: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:151:18: warning: dubious bitfield without explicit `signed' or `unsigned'
arch/x86/include/asm/uv/uv_bau.h:155:14: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:159:18: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:173:19: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:181:16: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:185:18: error: dubious one-bit signed bitfield
arch/x86/include/asm/uv/uv_bau.h:188:16: error: dubious one-bit signed bitfield

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/uv/uv_bau.h |   46 +++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index e236325..50423c7 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -133,61 +133,61 @@ struct bau_msg_payload {
  * see table 4.2.3.0.1 in broacast_assist spec.
  */
 struct bau_msg_header {
-	int dest_subnodeid:6;	/* must be zero */
+	unsigned int dest_subnodeid:6;	/* must be zero */
 	/* bits 5:0 */
-	int base_dest_nodeid:15; /* nasid>>1 (pnode) of first bit in node_map */
-	/* bits 20:6 */
-	int command:8;		/* message type */
+	unsigned int base_dest_nodeid:15; /* nasid>>1 (pnode) of */
+	/* bits 20:6 */			  /* first bit in node_map */
+	unsigned int command:8;	/* message type */
 	/* bits 28:21 */
 				/* 0x38: SN3net EndPoint Message */
-	int rsvd_1:3;		/* must be zero */
+	unsigned int rsvd_1:3;	/* must be zero */
 	/* bits 31:29 */
 				/* int will align on 32 bits */
-	int rsvd_2:9;		/* must be zero */
+	unsigned int rsvd_2:9;	/* must be zero */
 	/* bits 40:32 */
 				/* Suppl_A is 56-41 */
-	int payload_2a:8;	/* becomes byte 16 of msg */
+	unsigned int payload_2a:8;/* becomes byte 16 of msg */
 	/* bits 48:41 */	/* not currently using */
-	int payload_2b:8;	/* becomes byte 17 of msg */
+	unsigned int payload_2b:8;/* becomes byte 17 of msg */
 	/* bits 56:49 */	/* not currently using */
 				/* Address field (96:57) is never used as an
 				   address (these are address bits 42:3) */
-	int rsvd_3:1;		/* must be zero */
+	unsigned int rsvd_3:1;	/* must be zero */
 	/* bit 57 */
 				/* address bits 27:4 are payload */
 				/* these 24 bits become bytes 12-14 of msg */
-	int replied_to:1;	/* sent as 0 by the source to byte 12 */
+	unsigned int replied_to:1;/* sent as 0 by the source to byte 12 */
 	/* bit 58 */
 
-	int payload_1a:5;	/* not currently used */
+	unsigned int payload_1a:5;/* not currently used */
 	/* bits 63:59 */
-	int payload_1b:8;	/* not currently used */
+	unsigned int payload_1b:8;/* not currently used */
 	/* bits 71:64 */
-	int payload_1c:8;	/* not currently used */
+	unsigned int payload_1c:8;/* not currently used */
 	/* bits 79:72 */
-	int payload_1d:2;	/* not currently used */
+	unsigned int payload_1d:2;/* not currently used */
 	/* bits 81:80 */
 
-	int rsvd_4:7;		/* must be zero */
+	unsigned int rsvd_4:7;	/* must be zero */
 	/* bits 88:82 */
-	int sw_ack_flag:1;	/* software acknowledge flag */
+	unsigned int sw_ack_flag:1;/* software acknowledge flag */
 	/* bit 89 */
 				/* INTD trasactions at destination are to
 				   wait for software acknowledge */
-	int rsvd_5:6;		/* must be zero */
+	unsigned int rsvd_5:6;	/* must be zero */
 	/* bits 95:90 */
-	int rsvd_6:5;		/* must be zero */
+	unsigned int rsvd_6:5;	/* must be zero */
 	/* bits 100:96 */
-	int int_both:1;		/* if 1, interrupt both sockets on the blade */
+	unsigned int int_both:1;/* if 1, interrupt both sockets on the blade */
 	/* bit 101*/
-	int fairness:3;		/* usually zero */
+	unsigned int fairness:3;/* usually zero */
 	/* bits 104:102 */
-	int multilevel:1;	/* multi-level multicast format */
+	unsigned int multilevel:1;	/* multi-level multicast format */
 	/* bit 105 */
 				/* 0 for TLB: endpoint multi-unicast messages */
-	int chaining:1;		/* next descriptor is part of this activation*/
+	unsigned int chaining:1;/* next descriptor is part of this activation*/
 	/* bit 106 */
-	int rsvd_7:21;		/* must be zero */
+	unsigned int rsvd_7:21;	/* must be zero */
 	/* bits 127:107 */
 };
 
-- 
1.5.5.1



