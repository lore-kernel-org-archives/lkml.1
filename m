Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYAOVZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYAOVZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYAOVZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:25:26 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:39671 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbYAOVZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:25:25 -0500
Date: Tue, 15 Jan 2008 13:24:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-sound@vger.kernel.org
Cc: perex@perex.cz, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH 2/5] sound: fix ad1889 section mismatch
Message-Id: <20080115132459.4902cdef.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch in ad1889 by renaming the pci_driver variable to a
whitelisted variable name.

WARNING: vmlinux.o(.data+0x2e5ff0): Section mismatch: reference to .init.text:snd_ad1889_probe (between 'ad1889_pci' and 'index')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/ad1889.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc7-git7.orig/sound/pci/ad1889.c
+++ linux-2.6.24-rc7-git7/sound/pci/ad1889.c
@@ -1055,7 +1055,7 @@ static struct pci_device_id snd_ad1889_i
 };
 MODULE_DEVICE_TABLE(pci, snd_ad1889_ids);
 
-static struct pci_driver ad1889_pci = {
+static struct pci_driver ad1889_pci_driver = {
 	.name = "AD1889 Audio",
 	.id_table = snd_ad1889_ids,
 	.probe = snd_ad1889_probe,
@@ -1065,13 +1065,13 @@ static struct pci_driver ad1889_pci = {
 static int __init
 alsa_ad1889_init(void)
 {
-	return pci_register_driver(&ad1889_pci);
+	return pci_register_driver(&ad1889_pci_driver);
 }
 
 static void __exit
 alsa_ad1889_fini(void)
 {
-	pci_unregister_driver(&ad1889_pci);
+	pci_unregister_driver(&ad1889_pci_driver);
 }
 
 module_init(alsa_ad1889_init);
