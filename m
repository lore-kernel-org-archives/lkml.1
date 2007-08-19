Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbXHSWTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbXHSWTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXHSWTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:19:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1505 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbXHSWTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:19:40 -0400
Subject: [PATCH 4/5] Documentation/firmware/... convert #include
	"linux/..." to #include <linux/...>
From: Joe Perches <joe@perches.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Markus Rechberger <markus.rechberger@amd.com>
Content-Type: text/plain
Date: Sun, 19 Aug 2007 15:19:32 -0700
Message-Id: <1187561972.4200.143.camel@localhost>
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

This one is probably wrong.

It should likely keep firmware.h in
the same directory as firmware.c

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/Documentation/firmware_class/firmware_sample_driver.c b/Documentation/firmware_class/firmware_sample_driver.c
index 6865cbe..754ded2 100644
--- a/Documentation/firmware_class/firmware_sample_driver.c
+++ b/Documentation/firmware_class/firmware_sample_driver.c
@@ -13,7 +13,7 @@
 #include <linux/device.h>
 #include <linux/string.h>
 
-#include "linux/firmware.h"
+#include "firmware.h"
 
 static struct device ghost_device = {
 	.bus_id    = "ghost0",



