Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYGHXRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYGHXRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYGHXOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:42 -0400
Received: from gw.goop.org ([64.81.55.164]:51206 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbYGHXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 55] x86_64: unstatic get_local_pda
X-Mercurial-Node: 67a6d2cb534c6749a45cb8c9335624ddd706816a
Message-Id: <67a6d2cb534c6749a45c.1215554789@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows Xen's xen_cpu_up() to allocate a pda for the new CPU.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 include/asm-x86/smp.h     |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -768,7 +768,7 @@
  *
  * Must be called after the _cpu_pda pointer table is initialized.
  */
-static int __cpuinit get_local_pda(int cpu)
+int __cpuinit get_local_pda(int cpu)
 {
 	struct x8664_pda *oldpda, *newpda;
 	unsigned long size = sizeof(struct x8664_pda);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -24,6 +24,8 @@
 
 extern void (*mtrr_hook)(void);
 extern void zap_low_mappings(void);
+
+extern int __cpuinit get_local_pda(int cpu);
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;


