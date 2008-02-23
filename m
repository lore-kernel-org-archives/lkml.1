Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbYBWIhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbYBWIhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936435AbYBWIVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:21:41 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936959AbYBWIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ubRTdLVl/AQCfuM3vSxlijchN/Inw8ENa1eAILEgBhSjUOD8efCYyhrSUIILxk/h+SfjGsMTXGEgIQnpY9zGODocOzMCzze1Q8Z0GQlmgPoaRktiQ5CvkkwmWXgZ4bQJLxaFI32X5Q925KZTQat1pShBOdQgr+5hArlxN8Git/k=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 14/16] frv: use get_personality()
Date: Sat, 23 Feb 2008 16:14:17 +0800
Message-Id: <12037546033003-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1203754594597-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
 <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
 <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
 <12037545311452-git-send-email-xiyou.wangcong@gmail.com>
 <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
 <12037545522455-git-send-email-xiyou.wangcong@gmail.com>
 <12037545611159-git-send-email-xiyou.wangcong@gmail.com>
 <1203754571655-git-send-email-xiyou.wangcong@gmail.com>
 <1203754579637-git-send-email-xiyou.wangcong@gmail.com>
 <1203754594597-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for frv code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Howells <dhowells@redhat.com>

---
 include/asm-frv/page.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-frv/page.h b/include/asm-frv/page.h
index c2c1e89..6c5c4db 100644
--- a/include/asm-frv/page.h
+++ b/include/asm-frv/page.h
@@ -69,7 +69,7 @@ extern unsigned long max_pfn;
 #ifdef CONFIG_MMU
 #define VM_DATA_DEFAULT_FLAGS \
 	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+	((get_personality() & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
 		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 #endif
 
-- 
1.5.3.8

