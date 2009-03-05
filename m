Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbZCENoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbZCENoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbZCENnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:43:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:48998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbZCENnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:43:12 -0500
Date: Thu, 5 Mar 2009 13:42:29 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-14-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-14-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: move init_memory_mapping() to common mm/init.c, build fix on 32-bit PAE
Message-ID: <tip-62436fe9ee10f5e0dd087b106d69d93c9549935a@git.kernel.org>
Git-Commit-ID: 62436fe9ee10f5e0dd087b106d69d93c9549935a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:42:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62436fe9ee10f5e0dd087b106d69d93c9549935a
Gitweb:     http://git.kernel.org/tip/62436fe9ee10f5e0dd087b106d69d93c9549935a
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Thu, 5 Mar 2009 14:39:03 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:39:03 +0100

x86: move init_memory_mapping() to common mm/init.c, build fix on 32-bit PAE

Impact: build fix

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-14-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/mm/init_32.c                |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 4d258ad..b8238dc 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -273,6 +273,7 @@ typedef struct page *pgtable_t;
 
 extern pteval_t __supported_pte_mask;
 extern int nx_enabled;
+extern void set_nx(void);
 
 #define pgprot_writecombine	pgprot_writecombine
 extern pgprot_t pgprot_writecombine(pgprot_t prot);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 1669693..5e5126e 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -605,7 +605,7 @@ static int __init noexec_setup(char *str)
 }
 early_param("noexec", noexec_setup);
 
-static void __init set_nx(void)
+void __init set_nx(void)
 {
 	unsigned int v[4], l, h;
 
