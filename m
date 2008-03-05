Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbYCEFxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbYCEFxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761984AbYCEFug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:50:36 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:17288 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761955AbYCEFue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:50:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=wGlilaZxlUUNLQsYv+Tl3izcFq7xZ4lFna3/GPF5G9+1b68MiDtfhTxvUKwaScng3WRByD88CvxZa43ILVptylkkkenLmwKOYjIHdh+RDIaviukeGlC9zkUmLECHkaC/gAiN8IdhtohU9ynoWAKZb+QFYUvKUJCalEvtB8wpHw4=
Message-ID: <47CE34AD.2040504@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:50:37 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 9/11] /drivers/net/3c523.c replaced init_module&cleanup_module
 with module_init&module_exit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Jon Schindler <jkschind@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced init_module and cleanup_module with static functions and module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
---
diff --git a/drivers/net/3c523.c b/drivers/net/3c523.c
index 239fc42..cb4beba 100644
--- a/drivers/net/3c523.c
+++ b/drivers/net/3c523.c
@@ -1268,7 +1268,7 @@ MODULE_PARM_DESC(io, "EtherLink/MC I/O base address(es)");
 MODULE_PARM_DESC(irq, "EtherLink/MC IRQ number(s)");
 MODULE_LICENSE("GPL");
 
-int __init init_module(void)
+static int __init tc523_module_init(void)
 {
 	int this_dev,found = 0;
 
@@ -1295,8 +1295,9 @@ int __init init_module(void)
 		return -ENXIO;
 	} else return 0;
 }
+module_init(tc523_module_init);
 
-void __exit cleanup_module(void)
+static void __exit tc523_module_exit(void)
 {
 	int this_dev;
 	for (this_dev=0; this_dev<MAX_3C523_CARDS; this_dev++) {
@@ -1308,5 +1309,6 @@ void __exit cleanup_module(void)
 		}
 	}
 }
+module_exit(tc523_module_exit);
 
 #endif				/* MODULE */
