Return-Path: <linux-kernel-owner+w=401wt.eu-S1764878AbYF0Vms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764878AbYF0Vms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764217AbYF0Vhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764236AbYF0Vhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:34 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 13/39] use _ASM_PTR instead of explicit word-size pointers
Date: Fri, 27 Jun 2008 18:34:20 -0300
Message-Id: <1214602486-17080-14-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-13-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switch .long and .quad with _ASM_PTR in getuser*.S.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/getuser_32.S |    6 +++---
 arch/x86/lib/getuser_64.S |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lib/getuser_32.S b/arch/x86/lib/getuser_32.S
index 2cc3cee..2bb0a18 100644
--- a/arch/x86/lib/getuser_32.S
+++ b/arch/x86/lib/getuser_32.S
@@ -73,7 +73,7 @@ bad_get_user:
 END(bad_get_user)
 
 .section __ex_table,"a"
-	.long 1b,bad_get_user
-	.long 2b,bad_get_user
-	.long 3b,bad_get_user
+	_ASM_PTR 1b,bad_get_user
+	_ASM_PTR 2b,bad_get_user
+	_ASM_PTR 3b,bad_get_user
 .previous
diff --git a/arch/x86/lib/getuser_64.S b/arch/x86/lib/getuser_64.S
index 63b0e5c..e333884 100644
--- a/arch/x86/lib/getuser_64.S
+++ b/arch/x86/lib/getuser_64.S
@@ -93,8 +93,8 @@ bad_get_user:
 END(bad_get_user)
 
 .section __ex_table,"a"
-	.quad 1b,bad_get_user
-	.quad 2b,bad_get_user
-	.quad 3b,bad_get_user
-	.quad 4b,bad_get_user
+	_ASM_PTR 1b,bad_get_user
+	_ASM_PTR 2b,bad_get_user
+	_ASM_PTR 3b,bad_get_user
+	_ASM_PTR 4b,bad_get_user
 .previous
-- 
1.5.5.1

