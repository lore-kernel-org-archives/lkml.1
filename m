Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbYAJWdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbYAJWdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759160AbYAJWdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:33:21 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:38591 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130AbYAJWdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:33:19 -0500
Date: Thu, 10 Jan 2008 14:31:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: tpm@selhorst.net, lkml <linux-kernel@vger.kernel.org>
Cc: samr <sam@ravnborg.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] tpm: infineon section mismatch
Message-Id: <20080110143158.28f1d591.randy.dunlap@oracle.com>
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

Fix section mismatch by making the driver template variable name
match one of the whitelisted variable names in modpost.

WARNING: vmlinux.o(.data+0x7a9e8): Section mismatch: reference to .init.text:tpm_inf_pnp_probe (between 'tpm_inf_pnp' and 'cn_idx')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/tpm/tpm_infineon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc7-git1.orig/drivers/char/tpm/tpm_infineon.c
+++ linux-2.6.24-rc7-git1/drivers/char/tpm/tpm_infineon.c
@@ -611,7 +611,7 @@ static __devexit void tpm_inf_pnp_remove
 	}
 }
 
-static struct pnp_driver tpm_inf_pnp = {
+static struct pnp_driver tpm_inf_pnp_driver = {
 	.name = "tpm_inf_pnp",
 	.driver = {
 		.owner = THIS_MODULE,
@@ -625,12 +625,12 @@ static struct pnp_driver tpm_inf_pnp = {
 
 static int __init init_inf(void)
 {
-	return pnp_register_driver(&tpm_inf_pnp);
+	return pnp_register_driver(&tpm_inf_pnp_driver);
 }
 
 static void __exit cleanup_inf(void)
 {
-	pnp_unregister_driver(&tpm_inf_pnp);
+	pnp_unregister_driver(&tpm_inf_pnp_driver);
 }
 
 module_init(init_inf);
