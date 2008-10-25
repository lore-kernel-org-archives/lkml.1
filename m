Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYJYDee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYJYDee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYJYDbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:31:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:19879 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYJYDad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y6/j9GP2vwBREkGq9QFTF0iIJTjEc6N2PDbDdluF/yPlp+30rbtG55xcsqaZ55Teja
         xym4q566TTMWFguYtl8CBNj/adT02C5b0eUY8rPN1NEZ6Q+TEMGJ4oQBY5sx2n7xum68
         LRg/KSG6otWZKAqhp/CBBZO7b5Mv+pvPmnhnA=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 04/12] x86: Add macros for gate_desc
Date: Fri, 24 Oct 2008 20:15:24 -0700
Message-Id: <a9cabc5cabdb5a10631e2a6dc330c54826f2b210.1224903712.git.ice799@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <4810cc08c12cd78612b53f9b52d7ba93a9b03fd0.1224903712.git.ice799@gmail.com>
References: <>
 <1224904532-9586-1-git-send-email-ice799@gmail.com>
 <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
 <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com>
 <4810cc08c12cd78612b53f9b52d7ba93a9b03fd0.1224903712.git.ice799@gmail.com>
In-Reply-To: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
References: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add useful macros which can be used to access the lo and hi 32bit words, get the offset of the handler, and get the segment for gate_descs.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 include/asm-x86/desc_defs.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index 012df1f..d6a5310 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -75,8 +75,13 @@ typedef struct ldttss_desc64 tss_desc;
 typedef struct gate_struct gate_desc;
 typedef struct desc_struct ldt_desc;
 typedef struct desc_struct tss_desc;
-#define gate_offset(g)		(((g).b & 0xffff0000) | ((g).a & 0x0000ffff))
-#define gate_segment(g)		((g).a >> 16)
+#define desc_lo(d)		(((u32 *)&d)[0])
+#define desc_hi(d)		(((u32 *)&d)[1])
+#define gate_offset(g)		(((g).base1 << 16) | ((g).base0 & 0x0000ffff))
+#define gate_segment(g)		((g).seg_sel >> 16)
+#define ldttss_offset(d)	(((d).base2 << 24 ) | ((d).base1 << 16) |\
+				 ((d).base0 & 0x0000ffff))
+#define ldttss_limit(d)		((d).limit0)
 #endif
 
 struct desc_ptr {
-- 
1.5.4.3

