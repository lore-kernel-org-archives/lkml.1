Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747Ab0AYVue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0AYVue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087Ab0AYVud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:50:33 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:48891 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0AYVud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:50:33 -0500
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com, Himanshu Chauhan <hschauhan@nulltrace.org>
Subject: [PATCH] scripts/kallsyms build warning fix
Date: Tue, 26 Jan 2010 03:11:21 +0530
Message-Id: <1264455681-10578-1-git-send-email-hschauhan@nulltrace.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a small patch that fixes the build warning
of scripts/kallsyms.c

Regards
Himanshu

Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
---
 scripts/kallsyms.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 86c3896..e3902fb 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -108,8 +108,10 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	rc = fscanf(in, "%llx %c %499s\n", &s->addr, &stype, str);
 	if (rc != 3) {
 		if (rc != EOF) {
-			/* skip line */
-			fgets(str, 500, in);
+			/* skip line. sym is used as dummy to
+			 * shut of "warn_unused_result" warning.
+			 */
+			sym = fgets(str, 500, in);
 		}
 		return -1;
 	}
-- 
1.6.3.3

