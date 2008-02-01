Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYBAUBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYBAUBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYBAUB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:01:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:51823 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531AbYBAUB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:01:26 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH] pcmcia: silence section mismatch warnings from pci_driver variables
Date: Fri,  1 Feb 2008 21:01:27 +0100
Message-Id: <1201896087-15867-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1201896087-15867-1-git-send-email-sam@ravnborg.org>
References: <1201896087-15867-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence following warnings:
WARNING: drivers/pcmcia/built-in.o(.data+0x14e0): Section mismatch in reference from the variable pd6729_pci_drv to the function .devinit.text:pd6729_pci_probe()
WARNING: drivers/pcmcia/built-in.o(.data+0x14e8): Section mismatch in reference from the variable pd6729_pci_drv to the function .devexit.text:pd6729_pci_remove()
WARNING: drivers/pcmcia/built-in.o(.data+0x16c0): Section mismatch in reference from the variable i82092aa_pci_drv to the function .devinit.text:i82092aa_pci_probe()
WARNING: drivers/pcmcia/built-in.o(.data+0x16c8): Section mismatch in reference from the variable i82092aa_pci_drv to the function .devexit.text:i82092aa_pci_remove()

Rename the variables from *_drv to *_driver so
modpost ignore the OK references to __devinit/__devexit
functions.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/pcmcia/i82092.c |    6 +++---
 drivers/pcmcia/pd6729.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index df21e2d..1fae0bd 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -53,7 +53,7 @@ static int i82092aa_socket_resume (struct pci_dev *dev)
 }
 #endif
 
-static struct pci_driver i82092aa_pci_drv = {
+static struct pci_driver i82092aa_pci_driver = {
 	.name           = "i82092aa",
 	.id_table       = i82092aa_pci_ids,
 	.probe          = i82092aa_pci_probe,
@@ -709,13 +709,13 @@ static int i82092aa_set_mem_map(struct pcmcia_socket *socket, struct pccard_mem_
 
 static int i82092aa_module_init(void)
 {
-	return pci_register_driver(&i82092aa_pci_drv);
+	return pci_register_driver(&i82092aa_pci_driver);
 }
 
 static void i82092aa_module_exit(void)
 {
 	enter("i82092aa_module_exit");
-	pci_unregister_driver(&i82092aa_pci_drv);
+	pci_unregister_driver(&i82092aa_pci_driver);
 	if (sockets[0].io_base>0)
 			 release_region(sockets[0].io_base, 2);
 	leave("i82092aa_module_exit");
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index abc10fe..8bed1da 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -778,7 +778,7 @@ static struct pci_device_id pd6729_pci_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, pd6729_pci_ids);
 
-static struct pci_driver pd6729_pci_drv = {
+static struct pci_driver pd6729_pci_driver = {
 	.name		= "pd6729",
 	.id_table	= pd6729_pci_ids,
 	.probe		= pd6729_pci_probe,
@@ -791,12 +791,12 @@ static struct pci_driver pd6729_pci_drv = {
 
 static int pd6729_module_init(void)
 {
-	return pci_register_driver(&pd6729_pci_drv);
+	return pci_register_driver(&pd6729_pci_driver);
 }
 
 static void pd6729_module_exit(void)
 {
-	pci_unregister_driver(&pd6729_pci_drv);
+	pci_unregister_driver(&pd6729_pci_driver);
 }
 
 module_init(pd6729_module_init);
-- 
1.5.4.rc3.14.g44397

