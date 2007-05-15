Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXEOTii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXEOTii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761435AbXEOThO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:37:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45140 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762002AbXEOThL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:37:11 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] audit_match_signal() and friends are used only if CONFIG_AUDITSYSCALL is set
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ho2pa-0003V7-D1@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:37:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/auditfilter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 6c61263..74cc0fc 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -311,6 +311,7 @@ int audit_match_class(int class, unsigned syscall)
 	return classes[class][AUDIT_WORD(syscall)] & AUDIT_BIT(syscall);
 }
 
+#ifdef CONFIG_AUDITSYSCALL
 static inline int audit_match_class_bits(int class, u32 *mask)
 {
 	int i;
@@ -347,6 +348,7 @@ static int audit_match_signal(struct audit_entry *entry)
 		return 1;
 	}
 }
+#endif
 
 /* Common user-space to kernel rule translation. */
 static inline struct audit_entry *audit_to_entry_common(struct audit_rule *rule)
-- 
1.5.0-rc2.GIT


