Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0BGTou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 14:44:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:53449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab0BGTos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 14:44:48 -0500
Date: Sun, 7 Feb 2010 19:42:49 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20100205171647.15750.37221.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100205171647.15750.37221.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/alternatives: Fix build warning
Message-ID: <tip-076dc4a65a6d99a16979e2c7917e669fb8c91ee5@git.kernel.org>
Git-Commit-ID: 076dc4a65a6d99a16979e2c7917e669fb8c91ee5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 07 Feb 2010 19:42:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  076dc4a65a6d99a16979e2c7917e669fb8c91ee5
Gitweb:     http://git.kernel.org/tip/076dc4a65a6d99a16979e2c7917e669fb8c91ee5
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 5 Feb 2010 12:16:47 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Feb 2010 18:08:24 +0100

x86/alternatives: Fix build warning

Fixes these warnings:

 arch/x86/kernel/alternative.c: In function 'alternatives_text_reserved':
 arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
 arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
 arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast
 arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast

Caused by:

  2cfa197: ftrace/alternatives: Introducing *_text_reserved functions

Changes in v2:
  - Use local variables to compare, instead of type casts.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100205171647.15750.37221.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 3c13284..e63b80e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -395,12 +395,14 @@ int alternatives_text_reserved(void *start, void *end)
 {
 	struct smp_alt_module *mod;
 	u8 **ptr;
+	u8 *text_start = start;
+	u8 *text_end = end;
 
 	list_for_each_entry(mod, &smp_alt_modules, next) {
-		if (mod->text > end || mod->text_end < start)
+		if (mod->text > text_end || mod->text_end < text_start)
 			continue;
 		for (ptr = mod->locks; ptr < mod->locks_end; ptr++)
-			if (start <= *ptr && end >= *ptr)
+			if (text_start <= *ptr && text_end >= *ptr)
 				return 1;
 	}
 
