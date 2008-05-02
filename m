Return-Path: <linux-kernel-owner+w=401wt.eu-S934242AbYEBLOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934242AbYEBLOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbYEBLOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:14:40 -0400
Received: from ozlabs.org ([203.10.76.45]:51502 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812AbYEBLOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:14:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: fix up bootparam.h for userspace inclusion
Date: Fri, 2 May 2008 21:14:20 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805022114.20672.rusty@rustcorp.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8b664aa66e824a0ddf4ec56d41fa0cf7bb374de6 (x86, boot: add linked
list of struct setup_data) put a new struct in bootparam.h, but didn't
use the userspace-safe types.

CC: Huang, Ying <ying.huang@intel.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 3b015cd747e0 include/asm-x86/bootparam.h
--- a/include/asm-x86/bootparam.h	Fri May 02 09:32:30 2008 +1000
+++ b/include/asm-x86/bootparam.h	Fri May 02 18:35:11 2008 +1000
@@ -14,10 +14,10 @@
 
 /* extensible setup data list node */
 struct setup_data {
-	u64 next;
-	u32 type;
-	u32 len;
-	u8 data[0];
+	__u64 next;
+	__u32 type;
+	__u32 len;
+	__u8 data[0];
 };
 
 struct setup_header {
