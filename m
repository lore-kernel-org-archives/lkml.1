Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0BEGRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 01:17:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab0BEGRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 01:17:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/2] x86/alternatives: Fix build warning
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>
Date: Fri, 05 Feb 2010 01:24:27 -0500
Message-ID: <20100205062427.3745.85746.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes below warnings.

====
FYI, there's this new build warning on x86 defconfig:

arch/x86/kernel/alternative.c: In function 'alternatives_text_reserved':
arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast
arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast

Caused by:

2cfa197: ftrace/alternatives: Introducing *_text_reserved functions
====

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/alternative.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 3832fdc..99d9920 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -399,10 +399,10 @@ int alternatives_text_reserved(void *start, void *end)
 	u8 **ptr;
 
 	list_for_each_entry(mod, &smp_alt_modules, next) {
-		if (mod->text > end || mod->text_end < start)
+		if (mod->text > (u8 *)end || mod->text_end < (u8 *)start)
 			continue;
 		for (ptr = mod->locks; ptr < mod->locks_end; ptr++)
-			if (start <= *ptr && end >= *ptr)
+			if ((u8 *)start <= *ptr && (u8 *)end >= *ptr)
 				return 1;
 	}
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
