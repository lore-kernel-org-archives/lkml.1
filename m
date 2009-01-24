Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZAXOVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZAXOVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZAXOVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:21:22 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:65254 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbZAXOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=lR1N8w3LG3uyonoINed8b+ZbGSF+WEE4TOkMOWd06xPGyy55LB+SzPttt71hQg5fNG
         3DPK3qq49AdVOe8i+eq1JE0VDxFj0jWnDZTqWA/098VLYX7OVWoU6v90tm7LBIT/UNVn
         hmhgreEmV/zWTYZV4sZmjtkGmolF3MbAg5gFw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] icside: fix PCB version 6 support
Date: Sat, 24 Jan 2009 15:13:29 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901241513.29772.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] icside: fix PCB version 6 support

We need to pass struct ide_port_info also to ide_host_register().

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/icside.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -453,7 +453,7 @@ icside_register_v5(struct icside_state *
 
 	ecard_set_drvdata(ec, state);
 
-	ret = ide_host_register(host, NULL, hws);
+	ret = ide_host_register(host, &d, hws);
 	if (ret)
 		goto err_free;
 
