Return-Path: <linux-kernel-owner+w=401wt.eu-S1751634AbZLMHiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbZLMHiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 02:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZLMHiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 02:38:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:48680 "HELO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751594AbZLMHiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 02:38:17 -0500
Date: Sun, 13 Dec 2009 07:37:31 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1NJ9Pe-0004P7-0Q@eag09.americas.sgi.com>
References: <E1NJ9Pe-0004P7-0Q@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix duplicated UV BAU interrupt vector
Message-ID: <tip-1d865fb728bd6bbcdfbd6ec1e2b8ade3b4805641@git.kernel.org>
Git-Commit-ID: 1d865fb728bd6bbcdfbd6ec1e2b8ade3b4805641
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d865fb728bd6bbcdfbd6ec1e2b8ade3b4805641
Gitweb:     http://git.kernel.org/tip/1d865fb728bd6bbcdfbd6ec1e2b8ade3b4805641
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Fri, 11 Dec 2009 11:36:18 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Dec 2009 08:17:40 +0100

x86: Fix duplicated UV BAU interrupt vector

Interrupt vector 0xec has been doubly defined in irq_vectors.h

It seems arbitrary whether LOCAL_PENDING_VECTOR or
UV_BAU_MESSAGE is the higher number.  As long as they are
unique. If they are not unique we'll hit a BUG in
alloc_system_vector().

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: <stable@kernel.org>
LKML-Reference: <E1NJ9Pe-0004P7-0Q@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq_vectors.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6a635bd..4611f08 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -113,7 +113,7 @@
  */
 #define LOCAL_PENDING_VECTOR		0xec
 
-#define UV_BAU_MESSAGE			0xec
+#define UV_BAU_MESSAGE			0xea
 
 /*
  * Self IPI vector for machine checks
