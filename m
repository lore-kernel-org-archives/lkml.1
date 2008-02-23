Return-Path: <linux-kernel-owner+w=401wt.eu-S937834AbYBWIio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937834AbYBWIio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934975AbYBWIWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:22:06 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761021AbYBWIWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:22:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=j7SPboJlmOHLMN/EuTDa3E01EosAq1Sv6bS1zyObuRgAKslOiGn4Zmg7jP1A8bLvL9DD7W/RJXzYcoTYyN70aGoBVZm41o462WJ6pCF7D6dxz9csYEqzYge/FKLePTONs4MyaLvEcBrmM192ezHvRaUXDWrUGRn4inXbOi9Hv8U=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/16] kernel: use get_personality()
Date: Sat, 23 Feb 2008 16:14:19 +0800
Message-Id: <12037546253547-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037546111887-git-send-email-xiyou.wangcong@gmail.com>
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
 <12037546033003-git-send-email-xiyou.wangcong@gmail.com>
 <12037546111887-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>

---
 kernel/exec_domain.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/exec_domain.c b/kernel/exec_domain.c
index a9e6bad..056ba23 100644
--- a/kernel/exec_domain.c
+++ b/kernel/exec_domain.c
@@ -192,11 +192,11 @@ get_exec_domain_list(char *page)
 asmlinkage long
 sys_personality(u_long personality)
 {
-	u_long old = current->personality;
+	u_long old = get_personality();
 
 	if (personality != 0xffffffff) {
 		set_personality(personality);
-		if (current->personality != personality)
+		if (get_personality() != personality)
 			return -EINVAL;
 	}
 
-- 
1.5.3.8

