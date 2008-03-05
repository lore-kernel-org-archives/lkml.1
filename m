Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbYCEGFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbYCEGFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYCEGFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:05:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:37308 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYCEGFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:05:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Qkq2Ftyfhh6fUgMsITIBhBmGXzhkebvXvQhrDrKMli9eYuYBrxN0t6PwbvMLYAt7leysuCXlJ0dRZ7lhyQMU388MPbh8sf0KjfaL16hDCCgCYCKBDHMPdYuZliI/jGTBBRzikp+3llx6KFChAzS//5dpcHzGQJ+7/a4EorTxKv0=
Subject: [PATCH] x86: pageattr.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 22:05:27 -0800
Message-Id: <1204697127.17484.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irqs_disabled() uses flags internally, use _flags to avoid shadowing
code calling into this macro.

Introduced between 2.6.25-rc3 and -rc4

Fixes the sparse warning:
arch/x86/mm/pageattr.c:383:21: warning: symbol 'flags' shadows an earlier one
arch/x86/mm/pageattr.c:369:16: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This was the only new sparse warning introduced between -rc3 and -rc4 on an
X86_32 allyesconfig.

 include/linux/irqflags.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 412e025..e600c4e 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -84,10 +84,10 @@
 
 #define irqs_disabled()						\
 ({								\
-	unsigned long flags;					\
+	unsigned long _flags;					\
 								\
-	raw_local_save_flags(flags);				\
-	raw_irqs_disabled_flags(flags);				\
+	raw_local_save_flags(_flags);				\
+	raw_irqs_disabled_flags(_flags);			\
 })
 
 #define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
-- 
1.5.4.GIT



