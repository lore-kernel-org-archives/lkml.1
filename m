Return-Path: <linux-kernel-owner+w=401wt.eu-S1161331AbXBGOQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161331AbXBGOQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161327AbXBGOQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:16:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:31110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161331AbXBGOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=XBCIXifx7euwYOwLfU7f/StSiQch2pI5Lwkc8Za/bCnsa8QZYm3EnkhtbWVwVoxfKA96rAlu+SBPqLHWnOrYwOkUoOi14cS30/2/CKzLjIWEW7fjXItiFGqBL7mhIKCfRj5bN/26FnCpVa9wpmkjfnTgoS1cuhDyx8TJ2qtEcuQ=
Date: Wed, 7 Feb 2007 15:16:10 +0100 (CET)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Randy Dunlap <randy.dunlap@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: [PATCH] Broken ArcNet com20020 pcmcia driver in 2.6.20
Message-ID: <Pine.LNX.4.64.0702071418440.31566@frodo.shire>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I can not get my com20020 pcmcia driver to work as a module under 2.6.20.
There is the build problem:

MODPOST 30 modules
WARNING: "com20020_found" [drivers/net/pcmcia/com20020_cs.ko] undefined!
WARNING: "com20020_check" [drivers/net/pcmcia/com20020_cs.ko] undefined!

The solution:
Always export com20020_found and com20020_check.

Esben

  drivers/net/arcnet/com20020.c |    3 ---
  1 file changed, 3 deletions(-)

Index: linux-2.6.20/drivers/net/arcnet/com20020.c
===================================================================
--- linux-2.6.20.orig/drivers/net/arcnet/com20020.c
+++ linux-2.6.20/drivers/net/arcnet/com20020.c
@@ -337,11 +337,8 @@ static void com20020_set_mc_list(struct
  	}
  }

-#if defined(CONFIG_ARCNET_COM20020_PCI_MODULE) || \
-    defined(CONFIG_ARCNET_COM20020_ISA_MODULE)
  EXPORT_SYMBOL(com20020_check);
  EXPORT_SYMBOL(com20020_found);
-#endif

  MODULE_LICENSE("GPL");



