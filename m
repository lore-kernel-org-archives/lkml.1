Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZITS2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZITS2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZITS2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:28:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:56151 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbZITS2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:28:00 -0400
Date: Sun, 20 Sep 2009 18:27:35 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1252945687.3937.14.camel@Joe-Laptop.home>
References: <1252945687.3937.14.camel@Joe-Laptop.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mtrr: Convert loop to a while based construct, avoid naked semicolon
Message-ID: <tip-9ff6d8e06fbd9249804d43574167c2acc52886be@git.kernel.org>
Git-Commit-ID: 9ff6d8e06fbd9249804d43574167c2acc52886be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:27:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ff6d8e06fbd9249804d43574167c2acc52886be
Gitweb:     http://git.kernel.org/tip/9ff6d8e06fbd9249804d43574167c2acc52886be
Author:     Joe Perches <joe@perches.com>
AuthorDate: Mon, 14 Sep 2009 09:28:07 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:12:21 +0200

x86, mtrr: Convert loop to a while based construct, avoid naked semicolon

Perhaps this is a more readable/standard form.

Signed-off-by: Joe Perches <joe@perches.com>
LKML-Reference: <1252945687.3937.14.camel@Joe-Laptop.home>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/if.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 08b6ea4..f04e725 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -126,8 +126,8 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return -EINVAL;
 
 	base = simple_strtoull(line + 5, &ptr, 0);
-	for (; isspace(*ptr); ++ptr)
-		;
+	while (isspace(*ptr))
+		ptr++;
 
 	if (strncmp(ptr, "size=", 5))
 		return -EINVAL;
@@ -135,14 +135,14 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	size = simple_strtoull(ptr + 5, &ptr, 0);
 	if ((base & 0xfff) || (size & 0xfff))
 		return -EINVAL;
-	for (; isspace(*ptr); ++ptr)
-		;
+	while (isspace(*ptr))
+		ptr++;
 
 	if (strncmp(ptr, "type=", 5))
 		return -EINVAL;
 	ptr += 5;
-	for (; isspace(*ptr); ++ptr)
-		;
+	while (isspace(*ptr))
+		ptr++;
 
 	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
 		if (strcmp(ptr, mtrr_strings[i]))
