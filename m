Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZCRMIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZCRMIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbZCRMIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:08:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:41226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757823AbZCRMIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:08:14 -0400
Subject: [PATCH -tip] x86: kprobes.c fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Mar 2009 17:37:45 +0530
Message-Id: <1237378065.13488.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: kprobes.c fix compilation warning

arch/x86/kernel/kprobes.c:196: warning: passing argument 1 of ‘search_exception_tables’ makes integer from pointer without a cast

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index cfb3d81..ea06096 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -193,7 +193,7 @@ static int __kprobes can_boost(kprobe_opcode_t *opcodes)
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
 
-	if (search_exception_tables(opcodes))
+	if (search_exception_tables((unsigned long)opcodes))
 		return 0;	/* Page fault may occur on this address. */
 
 retry:
-- 
1.6.0.6



