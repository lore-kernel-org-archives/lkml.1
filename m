Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbXGKTV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbXGKTV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765057AbXGKTTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764802AbXGKTTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:20 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 06/33] Clean up struct screen_info (<linux/screen_info.h>)
Date: Wed, 11 Jul 2007 12:18:31 -0700
Message-Id: <1184181539416-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815393014-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
Message-Id: <068e40b5e554720f1c3f1a966f5ea3d16cb8bbc5.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

struct screen_info has unaligned members, it needs to be packed.
In the process, fix the naming of some of the members, which don't
belong in this structure but are part of it anyway.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/screen_info.h |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index b02308e..3ee412b 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -10,7 +10,7 @@
 struct screen_info {
 	u8  orig_x;		/* 0x00 */
 	u8  orig_y;		/* 0x01 */
-	u16 dontuse1;		/* 0x02 -- EXT_MEM_K sits here */
+	u16 ext_mem_k;		/* 0x02 */
 	u16 orig_video_page;	/* 0x04 */
 	u8  orig_video_mode;	/* 0x06 */
 	u8  orig_video_cols;	/* 0x07 */
@@ -27,7 +27,7 @@ struct screen_info {
 	u16 lfb_depth;		/* 0x16 */
 	u32 lfb_base;		/* 0x18 */
 	u32 lfb_size;		/* 0x1c */
-	u16 dontuse2, dontuse3;	/* 0x20 -- CL_MAGIC and CL_OFFSET here */
+	u16 cl_magic, cl_offset; /* 0x20 */
 	u16 lfb_linelength;	/* 0x24 */
 	u8  red_size;		/* 0x26 */
 	u8  red_pos;		/* 0x27 */
@@ -42,9 +42,8 @@ struct screen_info {
 	u16 pages;		/* 0x32 */
 	u16 vesa_attributes;	/* 0x34 */
 	u32 capabilities;       /* 0x36 */
-				/* 0x3a -- 0x3b reserved for future expansion */
-				/* 0x3c -- 0x3f micro stack for relocatable kernels */
-};
+	u8  _reserved[6];	/* 0x3a */
+} __attribute__((packed));
 
 extern struct screen_info screen_info;
 
-- 
1.5.2.2

