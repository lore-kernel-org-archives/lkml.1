Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYC3XXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYC3XXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbYC3XWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:22:42 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55102 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbYC3XWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:22:41 -0400
Date: Mon, 31 Mar 2008 02:22:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: khali@linux-fr.org
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] i2c/busses/scx200_acb.c: don't use 0 as NULL pointer
Message-ID: <20080330232228.GR28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use 0 as NULL pointer.

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4a2495930cc9bc83f4302de3b73ebf3e8849dc1a diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index f5e7a70..61abe0f 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -527,7 +527,7 @@ static int __init scx200_create_isa(const char *text, unsigned long base,
 	if (iface == NULL)
 		return -ENOMEM;
 
-	if (request_region(base, 8, iface->adapter.name) == 0) {
+	if (!request_region(base, 8, iface->adapter.name)) {
 		printk(KERN_ERR NAME ": can't allocate io 0x%lx-0x%lx\n",
 		       base, base + 8 - 1);
 		rc = -EBUSY;

