Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYIIWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYIIWW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYIIWWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:22:18 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:27982 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYIIWWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:22:17 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 22/24] i386: add TRACE_IRQS_OFF for the nmi
Date: Tue,  9 Sep 2008 21:56:16 +0200
Message-Id: <1220990178-29773-23-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-22-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-5-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-6-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-7-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-8-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-9-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-10-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-11-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-12-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-13-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-14-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-15-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-16-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-17-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-18-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-19-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-20-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-21-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-22-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 00:21:59 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

At this point interrupts are off, so let's inform the tracing
code of that fact before calling into C.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a278505..2abdc9a 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -849,6 +849,7 @@ nmi_stack_correct:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
 	call do_nmi
@@ -889,6 +890,7 @@ nmi_espfix_stack:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	FIXUP_ESPFIX_STACK		# %eax == %esp
 	xorl %edx,%edx			# zero error code
 	call do_nmi
-- 
1.5.4.3

