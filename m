Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZDKMzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZDKMzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 08:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZDKMzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 08:55:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34489 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZDKMzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 08:55:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=tcf3iHs9oG346aWYqL8bHCmmrWCKqwPk1TvB12W0xqS824eebnbIwYtlSOVObOkNOb
         Ip+xMwndOYCdPnjtNknLnNn2ePOAT01E5bzlZegeRtZEAmEZTCoFWjKH/6eLWUYrH7w9
         Ipne8zSfYOEQI1lj68fww/D1wDM2voIfTeYlU=
MIME-Version: 1.0
Date: Sat, 11 Apr 2009 14:55:22 +0200
Message-ID: <667b0cb60904110555k442f3959k9140d355b00980cd@mail.gmail.com>
Subject: [PATCH]8390p: Get rid of init_module/cleanup_module
From: Mateusz Mandera <ormi.linux@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       p_gortmaker@yahoo.com, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch just "gets rid of" init_module and cleanup_module
from drivers/net/8390p.c

Signed-off-by: Mateusz Mandera <ormi.linux@gmail.com>
---
diff --git a/drivers/net/8390p.c b/drivers/net/8390p.c
index da863c9..ec9e3ca 100644
--- a/drivers/net/8390p.c
+++ b/drivers/net/8390p.c
@@ -97,16 +97,15 @@ void NS8390p_init(struct net_device *dev, int startp)
 }
 EXPORT_SYMBOL(NS8390p_init);

-#if defined(MODULE)
-
-int init_module(void)
+static int __init 8390p_init_module(void)
 {
 	return 0;
 }

-void cleanup_module(void)
+static void __exit 8390p_cleanup_module(void)
 {
 }

-#endif /* MODULE */
+module_init(8390p_init_module);
+module_exit(8390p_cleanup_module);
 MODULE_LICENSE("GPL");
