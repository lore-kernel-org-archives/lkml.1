Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbXLJQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbXLJQ5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXLJQ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:57:29 -0500
Received: from mx1.riseup.net ([204.13.164.18]:42730 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbXLJQ53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:57:29 -0500
Date: Mon, 10 Dec 2007 17:57:28 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] acpi_pci_irq_find_prt_entry(): use list_for_each_entry()
	instead of list_for_each()
Message-ID: <20071210165727.GA20186@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_pci_irq_find_prt_entry(): use list_for_each_entry() instead of
list_for_each()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index dd3186a..e51dac7 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -51,10 +51,8 @@ static struct acpi_prt_entry *acpi_pci_irq_find_prt_entry(int segment,
 							  int bus,
 							  int device, int pin)
 {
-	struct list_head *node = NULL;
 	struct acpi_prt_entry *entry = NULL;
 
-
 	if (!acpi_prt.count)
 		return NULL;
 
@@ -64,8 +62,7 @@ static struct acpi_prt_entry *acpi_pci_irq_find_prt_entry(int segment,
 	 *
 	 */
 	spin_lock(&acpi_prt_lock);
-	list_for_each(node, &acpi_prt.entries) {
-		entry = list_entry(node, struct acpi_prt_entry, node);
+	list_for_each_entry(entry, &acpi_prt.entries, node) {
 		if ((segment == entry->id.segment)
 		    && (bus == entry->id.bus)
 		    && (device == entry->id.device)

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

    Tant qu'il y aura sur terre des hommes pour qui existe un concept
    d' 'honneur national', la menace d'une nouvelle guerre subsistera
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
