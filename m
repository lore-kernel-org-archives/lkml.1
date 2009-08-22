Return-Path: <linux-kernel-owner+w=401wt.eu-S933350AbZHVXq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbZHVXq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 19:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933235AbZHVXq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 19:46:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:57555 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933239AbZHVXq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 19:46:57 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/l1a4fxBLlLYOu4RVzQnAMJrG/UNK+fX25Jymh3a
	r+GTnVw/ppD88Q
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] char/impi: adding __init macro/ fix of __exit macro location in ipmi_poweroff.c
Date: Sun, 23 Aug 2009 01:46:55 +0200
User-Agent: KMail/1.9.9
Cc: Corey Minyard <minyard@acm.org>, openipmi-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908230146.56283.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init to the module_init function of
drivers/char/ipmi/ipmy_poweroff.c and corrects the location of __exit for the
cleanup function.

According to ldd3, page 31 the __exit token hast to be after the return type.
Or am I getting something wrong here?

Corey, please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version 2.6.31-rc6 - linus git tree, So 23. Aug 01:38:43 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index a261bd7..2e66b5f 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -691,7 +691,7 @@ static struct ctl_table_header *ipmi_table_header;
 /*
  * Startup and shutdown functions.
  */
-static int ipmi_poweroff_init(void)
+static int __init ipmi_poweroff_init(void)
 {
 	int rv;
 
@@ -725,7 +725,7 @@ static int ipmi_poweroff_init(void)
 }
 
 #ifdef MODULE
-static __exit void ipmi_poweroff_cleanup(void)
+static void __exit ipmi_poweroff_cleanup(void)
 {
 	int rv;
 
