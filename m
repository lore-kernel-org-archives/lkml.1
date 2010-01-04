Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035Ab0ADDHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0ADDHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919Ab0ADDHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:07:17 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65034 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0ADDHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:14 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:39 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/29] x86: fix size for ex trampoline with 32bit
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix for error that is introduced by
| x86: Use find_e820() instead of hard coded trampoline address

it should end with PAGE_SIZE + PAGE_SIZE

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 05ed7ab..a1a7876 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -733,13 +733,13 @@ struct early_res {
 };
 static struct early_res early_res[MAX_EARLY_RES] __initdata = {
 	{ 0, PAGE_SIZE, "BIOS data page", 1 },	/* BIOS data page */
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && defined(CONFIG_X86_TRAMPOLINE)
 	/*
 	 * But first pinch a few for the stack/trampoline stuff
 	 * FIXME: Don't need the extra page at 4K, but need to fix
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
-	{ PAGE_SIZE, PAGE_SIZE, "EX TRAMPOLINE", 1 },
+	{ PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE", 1 },
 #endif
 
 	{}
-- 
1.6.4.2

