Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYFIOTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYFIOTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbYFIOSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYFIOSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:32 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 05/15] x86: use initial_code for i386
Date: Mon,  9 Jun 2008 11:16:48 -0300
Message-Id: <1213021018-14159-6-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-5-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 jumps to whatever is written in "initial_code" symbol,
instead of a fixed address. Do it for i386 too. It will allow us
to integrate more of the smp boot code.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/head_32.S |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index b98b338..ffb73a5 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -455,7 +455,10 @@ is386:	movl $2,%ecx		# set MP
 	jmp initialize_secondary # all other CPUs call initialize_secondary
 1:
 #endif /* CONFIG_SMP */
-	jmp i386_start_kernel
+	jmp *(initial_code)
+.align 4
+ENTRY(initial_code)
+	.long i386_start_kernel
 
 /*
  * We depend on ET to be correct. This checks for 287/387.
-- 
1.5.4.5

