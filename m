Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0BIP4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:56:33 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:29065 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab0BIP4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:56:19 -0500
X-IronPort-AV: E=Sophos;i="4.49,436,1262581200"; 
   d="scan'208";a="83432806"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 3/3] x86: ret_from_fork: use symbolic contants for bits in EFLAGS
Date: Tue,  9 Feb 2010 15:56:09 +0000
Message-Id: <1265730969-30145-4-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265730969-30145-1-git-send-email-ian.campbell@citrix.com>
References: <1265730969-30145-1-git-send-email-ian.campbell@citrix.com>
X-OriginalArrivalTime: 09 Feb 2010 15:56:17.0829 (UTC) FILETIME=[6A642550:01CAA9A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/entry_32.S |    2 +-
 arch/x86/kernel/entry_64.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 44a8e0d..02a5a18 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -325,7 +325,7 @@ ENTRY(ret_from_fork)
 	GET_THREAD_INFO(%ebp)
 	popl %eax
 	CFI_ADJUST_CFA_OFFSET -4
-	pushl $0x0202			# Reset kernel eflags
+	pushl $(X86_EFLAGS_IF|0x2)	# Reset kernel eflags
 	CFI_ADJUST_CFA_OFFSET 4
 	popfl
 	CFI_ADJUST_CFA_OFFSET -4
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b771c2f..f5ceffa 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -400,7 +400,7 @@ ENTRY(ret_from_fork)
 
 	call schedule_tail			# rdi: 'prev' task parameter
 
-	push $0x0202
+	push $(X86_EFLAGS_IF|0x2)
 	CFI_ADJUST_CFA_OFFSET 8
 	popf					# reset kernel eflags
 	CFI_ADJUST_CFA_OFFSET -8
-- 
1.5.6.5

