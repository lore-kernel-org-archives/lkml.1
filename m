Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbZLDQfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbZLDQfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbZLDQfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:35:07 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33896 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbZLDQfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Ij9ob2owfW2ltBXMWBPfvpRdqzrltAl5Nd3wSY2Tvl7EuPtAhpx7yS/+lt3rJufZy7
         VfobpmSScIm0kvGIGGPd7wRy8OblYYpjoisWK0HI4mHTIAjHMF5exVmTJbg+BnSYxT3J
         mFq7L+TDePL7X76i/xDZRzA7qNNKCAkSwS6/s=
MIME-Version: 1.0
Date: Fri, 4 Dec 2009 22:35:12 +0600
Message-ID: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com>
Subject: [PATCH] pci: Make pci_dev struct point to NULL.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 pci: Make pci_dev struct point to NULL.

In function enable_device of acpiphp_glue.c, structure pci_dev
doesn't point anything. Due to the check in line 975 we might
end up being uninitialized. So make it point to NULL.

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/pci/hotplug/acpiphp_glue.c	2009-12-03 21:30:57.000000000 +0600
+++ rakib/drivers/pci/hotplug/acpiphp_glue.c	2009-12-03 23:53:44.000000000 +0600
@@ -964,7 +964,7 @@ static int acpiphp_bus_trim(acpi_handle
  */
 static int __ref enable_device(struct acpiphp_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev = NULL;
 	struct pci_bus *bus = slot->bridge->pci_bus;
 	struct list_head *l;
 	struct acpiphp_func *func;
