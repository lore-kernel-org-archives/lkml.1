Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbZGFKLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbZGFKLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 06:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZGFKLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 06:11:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54997 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbZGFKLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 06:11:11 -0400
Date: Mon, 6 Jul 2009 06:11:08 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>
Message-Id: <20090706101323.6737.62028.sendpatchset@localhost.localdomain>
Subject: [Patch] lib: make strict_strtoul() more strict
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Let strict_strtoul() to reject strings longer than
ULONG_MAX's string.

So does strict_stroull().

Update their documents.

(Tested on x86_64.)

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: akpm@linux-foundation.org

---
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 756ccaf..f1f7bd7 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -143,7 +143,8 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
  * @res: The converted result value
  *
  * strict_strtoul converts a string to an unsigned long only if the
- * string is really an unsigned long string, any string containing
+ * string is really an unsigned long string, any string has more than the
+ * number of digits in ULONG_MAX will be rejected, any string containing
  * any invalid char at the tail will be rejected and -EINVAL is returned,
  * only a newline char at the tail is acceptible because people generally
  * change a module parameter in the following way:
@@ -168,6 +169,8 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
 	len = strlen(cp);
 	if (len == 0)
 		return -EINVAL;
+	if (len > snprintf(NULL, 0, "%ld", ULONG_MAX))
+		return -EINVAL;
 
 	val = simple_strtoul(cp, &tail, base);
 	if (tail == cp)
@@ -216,7 +219,8 @@ EXPORT_SYMBOL(strict_strtol);
  * @res: The converted result value
  *
  * strict_strtoull converts a string to an unsigned long long only if the
- * string is really an unsigned long long string, any string containing
+ * string is really an unsigned long long string, any string has more than
+ * the number of digits in ULLONG_MAX will be rejected, any string containing
  * any invalid char at the tail will be rejected and -EINVAL is returned,
  * only a newline char at the tail is acceptible because people generally
  * change a module parameter in the following way:
@@ -241,6 +245,8 @@ int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res)
 	len = strlen(cp);
 	if (len == 0)
 		return -EINVAL;
+	if (len > snprintf(NULL, 0, "%lld", ULLONG_MAX))
+		return -EINVAL;
 
 	val = simple_strtoull(cp, &tail, base);
 	if (tail == cp)
