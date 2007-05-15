Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbXEOEdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbXEOEdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbXEOEdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:33:24 -0400
Received: from lixom.net ([66.141.50.11]:40889 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbXEOEdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:33:24 -0400
Date: Mon, 14 May 2007 23:36:28 -0500
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, hch@lst.de
Subject: [PATCH v3] pcmcia: export pcmcia_bus_type (GPL-only)
Message-ID: <20070515043628.GA6648@lixom.net>
References: <20070512153307.GA13223@lixom.net> <20070512180658.GA14291@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512180658.GA14291@lixom.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export pcmcia_bus_type so module-based drivers can register bus notifiers.

Signed-off-by: Olof Johansson <olof@lixom.net>


Index: powerpc/drivers/pcmcia/ds.c
===================================================================
--- powerpc.orig/drivers/pcmcia/ds.c
+++ powerpc/drivers/pcmcia/ds.c
@@ -1404,6 +1404,7 @@ struct bus_type pcmcia_bus_type = {
 	.suspend = pcmcia_dev_suspend,
 	.resume = pcmcia_dev_resume,
 };
+EXPORT_SYMBOL_GPL(pcmcia_bus_type);
 
 
 static int __init init_pcmcia_bus(void)
Index: powerpc/include/pcmcia/ss.h
===================================================================
--- powerpc.orig/include/pcmcia/ss.h
+++ powerpc/include/pcmcia/ss.h
@@ -298,6 +298,7 @@ extern int pcmcia_register_socket(struct
 extern void pcmcia_unregister_socket(struct pcmcia_socket *socket);
 
 extern struct class pcmcia_socket_class;
+extern struct bus_type pcmcia_bus_type;
 
 /* socket drivers are expected to use these callbacks in their .drv struct */
 extern int pcmcia_socket_dev_suspend(struct device *dev, pm_message_t state);
