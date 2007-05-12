Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbXELSEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbXELSEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbXELSER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:04:17 -0400
Received: from lixom.net ([66.141.50.11]:42242 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbXELSEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:04:16 -0400
Date: Sat, 12 May 2007 13:06:58 -0500
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH v2] pcmcia: export pcmcia_bus_type
Message-ID: <20070512180658.GA14291@lixom.net>
References: <20070512153307.GA13223@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512153307.GA13223@lixom.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export pcmcia_bus_type so module-based drivers can register bus notifiers,
and add it to what seems to be the main include file.

Signed-off-by: Olof Johansson <olof@lixom.net>

---

Missed the include file in the last patch.


Index: 2.6.21/drivers/pcmcia/ds.c
===================================================================
--- 2.6.21.orig/drivers/pcmcia/ds.c
+++ 2.6.21/drivers/pcmcia/ds.c
@@ -1404,6 +1404,7 @@ struct bus_type pcmcia_bus_type = {
 	.suspend = pcmcia_dev_suspend,
 	.resume = pcmcia_dev_resume,
 };
+EXPORT_SYMBOL(pcmcia_bus_type);
 
 
 static int __init init_pcmcia_bus(void)
Index: 2.6.21/include/pcmcia/ss.h
===================================================================
--- 2.6.21.orig/include/pcmcia/ss.h
+++ 2.6.21/include/pcmcia/ss.h
@@ -298,6 +298,7 @@ extern int pcmcia_register_socket(struct
 extern void pcmcia_unregister_socket(struct pcmcia_socket *socket);
 
 extern struct class pcmcia_socket_class;
+extern struct bus_type pcmcia_bus_type;
 
 /* socket drivers are expected to use these callbacks in their .drv struct */
 extern int pcmcia_socket_dev_suspend(struct device *dev, pm_message_t state);
