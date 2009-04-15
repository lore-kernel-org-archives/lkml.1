Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZDOGas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZDOGas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZDOG24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:28:56 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49600 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbZDOG2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:28:54 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       David Kiliani <mail@davidkiliani.de>
Subject: [PATCH resend 7/8] staging: meilhaus, annotate cpi functions
Date: Wed, 15 Apr 2009 08:28:46 +0200
Message-Id: <1239776927-16168-7-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
References: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __devinit and __devexit to pci probe/remove. Also make pci_driver
static.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Kiliani <mail@davidkiliani.de>
---
 drivers/staging/meilhaus/memain.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/meilhaus/memain.c b/drivers/staging/meilhaus/memain.c
index d5aacdd..2631587 100644
--- a/drivers/staging/meilhaus/memain.c
+++ b/drivers/staging/meilhaus/memain.c
@@ -103,11 +103,11 @@ static const struct file_operations me_file_operations = {
 	.release = me_release,
 };
 
-struct pci_driver me_pci_driver = {
+static struct pci_driver me_pci_driver = {
 	.name = MEMAIN_NAME,
 	.id_table = me_pci_table,
 	.probe = me_probe_pci,
-	.remove = me_remove_pci
+	.remove = __devexit_p(me_remove_pci),
 };
 
 /* //me_usb_driver
@@ -384,7 +384,8 @@ static me_device_t *get_dummy_instance(unsigned short vendor_id,
 	return instance;
 }
 
-static int me_probe_pci(struct pci_dev *dev, const struct pci_device_id *id)
+static int __devinit me_probe_pci(struct pci_dev *dev,
+		const struct pci_device_id *id)
 {
 	int err;
 	me_pci_constructor_t constructor = NULL;
@@ -582,7 +583,7 @@ static int insert_to_device_list(me_device_t *n_device)
 	return 0;
 }
 
-static void me_remove_pci(struct pci_dev *dev)
+static void __devexit me_remove_pci(struct pci_dev *dev)
 {
 	int vendor_id = dev->vendor;
 	int device_id = dev->device;
-- 
1.6.2

