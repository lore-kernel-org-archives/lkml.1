Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761Ab0ADVnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0ADVnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842Ab0ADVnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:43:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:47889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab0ADVnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:43:05 -0500
Date: Mon, 4 Jan 2010 21:42:40 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <1261525263-13763-2-git-send-email-yinghai@kernel.org>
References: <1261525263-13763-2-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix size for ex trampoline with 32bit
Message-ID: <tip-9dad0fd5a73d4048dff18069733c0b515f68df74@git.kernel.org>
Git-Commit-ID: 9dad0fd5a73d4048dff18069733c0b515f68df74
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9dad0fd5a73d4048dff18069733c0b515f68df74
Gitweb:     http://git.kernel.org/tip/9dad0fd5a73d4048dff18069733c0b515f68df74
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 22 Dec 2009 15:40:39 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 4 Jan 2010 13:20:11 -0800

x86: Fix size for ex trampoline with 32bit

fix for error that is introduced by
| x86: Use find_e820() instead of hard coded trampoline address

it should end with PAGE_SIZE + PAGE_SIZE

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1261525263-13763-2-git-send-email-yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
