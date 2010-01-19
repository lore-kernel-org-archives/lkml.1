Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690Ab0ASVJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0ASVJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660Ab0ASVJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:09:11 -0500
Received: from [206.15.93.42] ([206.15.93.42]:13367 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755631Ab0ASVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:09:09 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/misc/iwmc3200top/log.c: use skip_spaces to strip leading whitespace
Date: Tue, 19 Jan 2010 14:09:14 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001191409.14705.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the library function instead of a while loop.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/misc/iwmc3200top/log.c b/drivers/misc/iwmc3200top/log.c
index d569279..fe6dbc0 100644
--- a/drivers/misc/iwmc3200top/log.c
+++ b/drivers/misc/iwmc3200top/log.c
@@ -26,7 +26,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mmc/sdio_func.h>
-#include <linux/ctype.h>
+#include <linux/string.h>
 #include "fw-msg.h"
 #include "iwmc3200top.h"
 #include "log.h"
@@ -224,8 +224,7 @@ ssize_t store_iwmct_log_level(struct device *d,
 	memcpy(str_buf, buf, count);
 
 	while ((token = strsep(&str_buf, ",")) != NULL) {
-		while (isspace(*token))
-			++token;
+		token = skip_spaces(token);
 		if (strict_strtol(token, HEXADECIMAL_RADIX, &val)) {
 			LOG_ERROR(priv, DEBUGFS,
 				  "failed to convert string to long %s\n",
@@ -307,9 +306,7 @@ ssize_t store_iwmct_log_level_fw(struct device *d,
 	for (i = 0; ((token = strsep(&str_buf, ",")) != NULL) &&
 		     (i < FW_LOG_SRC_MAX); i++) {
 
-		while (isspace(*token))
-			++token;
-
+		token = skip_spaces(token);
 		if (strict_strtol(token, HEXADECIMAL_RADIX, &val)) {
 			LOG_ERROR(priv, DEBUGFS,
 				  "failed to convert string to long %s\n",
