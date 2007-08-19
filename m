Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbXHSWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbXHSWT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXHSWTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:19:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1496 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbXHSWTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:19:13 -0400
Subject: [PATCH 3/5] drivers/scsi/... convert #include "linux/..." to
	#include <linux/...>
From: Joe Perches <joe@perches.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 19 Aug 2007 15:19:11 -0700
Message-Id: <1187561951.4200.142.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(untested)

There are several files that 
#include "linux/file" not #include <linux/file>
#include "asm/file" not #include <asm/file>

Here's a little script that converts them:

egrep -i -r -l --include=*.[ch] \
"^[[:space:]]*\#[[:space:]]*include[[:space:]]*\"(linux|asm)/(.*)\"" * \
| xargs sed -i -e 's/^[[:space:]]*#[[:space:]]*include[[:space:]]*"\(linux\|asm\)\/\(.*\)"/#include <\1\/\2>/g'

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 6bd8e30..ddf5f10 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -29,7 +29,7 @@
  *
  */
 
-#include "linux/pci.h"
+#include <linux/pci.h>
 #include "aic94xx.h"
 #include "aic94xx_reg.h"
 #include "aic94xx_reg_def.h"


