Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbYLWQW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbYLWQW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYLWQWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:22:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYLWQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:22:11 -0500
Subject: [PATCH] x86: traps.c replace #if CONFIG_X86_32 with #ifdef
	CONFIG_X86_32
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Dec 2008 21:50:11 +0530
Message-Id: <1230049211.14358.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid warning in X86_64

Fixes this warning in X86_64:
  CC      arch/x86/kernel/traps.o
arch/x86/kernel/traps.c:695:5: warning: "CONFIG_X86_32" is not defined

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d327b53..2c00412 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -692,7 +692,7 @@ void math_error(void __user *ip)
 
 	err = swd & ~cwd & 0x3f;
 
-#if CONFIG_X86_32
+#ifdef CONFIG_X86_32
 	if (!err)
 		return;
 #endif
-- 
1.5.5.1



