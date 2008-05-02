Return-Path: <linux-kernel-owner+w=401wt.eu-S1764106AbYEBCFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764106AbYEBCFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 22:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYEBCF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 22:05:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:15218 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYEBCF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 22:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bpZuypQTjEm9SS6iJCpVVM4AgLiT9giSJQ9djMa/ohmnYbhpRDG+bG6SpyGDcdMrLvfkayR/HmtKxeOU5R/JjS7hgH/l7kAcV4gDGs9bJaLwBqSXWUE8LS1v0dvAzDVeT6RMOoxCgUSmdi+Vz/hGCZcogA9xiuag65EVPWeJRFY=
Subject: [PATCH] kgdb: use put_unaligned_be32 helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 19:05:47 -0700
Message-Id: <1209693947.24729.221.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/kgdb.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 216c3dc..04e1ff4 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -52,6 +52,7 @@
 #include <asm/byteorder.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
+#include <asm/unaligned.h>
 
 static int kgdb_break_asap;
 
@@ -504,10 +505,7 @@ static void int_to_threadref(unsigned char *id, int value)
 	scan = (unsigned char *)id;
 	while (i--)
 		*scan++ = 0;
-	*scan++ = (value >> 24) & 0xff;
-	*scan++ = (value >> 16) & 0xff;
-	*scan++ = (value >> 8) & 0xff;
-	*scan++ = (value & 0xff);
+	put_unaligned_be32(value, scan);
 }
 
 static struct task_struct *getthread(struct pt_regs *regs, int tid)
-- 
1.5.5.1.350.gbbbf



