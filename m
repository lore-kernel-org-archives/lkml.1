Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZINQ2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZINQ2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZINQ2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:28:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1168 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZINQ2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:28:05 -0400
Subject: [PATCH] arch/x86/kernel/cpu/mtrr/if.c: Convert for loop to while,
 avoid naked semicolon
From: Joe Perches <joe@perches.com>
To: x86@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 09:28:07 -0700
Message-Id: <1252945687.3937.14.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps this is a more readable/standard form

Signed-off-by: Joe Perches <joe@perches.com>

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



