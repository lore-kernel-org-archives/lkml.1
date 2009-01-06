Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbZAFWeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbZAFWeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZAFWOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:22 -0500
Received: from kroah.org ([198.145.64.141]:51335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753377AbZAFWOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 56/60] UIO: use pci_ioremap_bar() in drivers/uio
Date: Tue,  6 Jan 2009 14:12:15 -0800
Message-Id: <1231279939-32728-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

Use the newly introduced pci_ioremap_bar() function in drivers/uio.
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio_cif.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index 5737606..c60b8fc 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -57,8 +57,7 @@ static int __devinit hilscher_pci_probe(struct pci_dev *dev,
 	info->mem[0].addr = pci_resource_start(dev, 0);
 	if (!info->mem[0].addr)
 		goto out_release;
-	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, 0),
-					     pci_resource_len(dev, 0));
+	info->mem[0].internal_addr = pci_ioremap_bar(dev, 0);
 	if (!info->mem[0].internal_addr)
 		goto out_release;
 
-- 
1.6.0.4

