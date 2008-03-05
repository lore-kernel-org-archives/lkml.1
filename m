Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbYCEFtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbYCEFtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYCEFtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:49:09 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:16938 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYCEFtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=MXhHUWlMv8MqB0N2GJMSlNvhDCvAHtU7fS5BL+P3fjJ1vbK7N9+lMh4jf5eepxBneYbkBHlDqZogxboz6Z9OlkHpvei6r5maAKAnH/XqFdfASm7ID5WLosbx4PohDEt5N3d6dwgfqHQRy+g22bvRDzMBvC5yndXqKge5pFsHuX0=
Message-ID: <47CE3452.3070509@gmail.com>
Date: Tue, 04 Mar 2008 23:49:06 -0600
From: Jon Schindler <jkschind@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/11] /drivers/block/floppy.c replaced init_module&cleanup_module
 with module_init&module_exit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced init_module and cleanup_module with static functions and module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
---
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 32c79a5..9a3d509 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4528,14 +4528,15 @@ static void __init parse_floppy_cfg_string(char *cfg)
 	}
 }
 
-int __init init_module(void)
+static int __init floppy_module_init(void)
 {
 	if (floppy)
 		parse_floppy_cfg_string(floppy);
 	return floppy_init();
 }
+module_init(floppy_module_init);
 
-void cleanup_module(void)
+static void __exit floppy_module_exit(void)
 {
 	int drive;
 
@@ -4567,6 +4568,7 @@ void cleanup_module(void)
 
 	wait_for_completion(&device_release);
 }
+module_exit(floppy_module_exit);
 
 module_param(floppy, charp, 0);
 module_param(FLOPPY_IRQ, int, 0);

