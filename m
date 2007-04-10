Return-Path: <linux-kernel-owner+w=401wt.eu-S1030609AbXDJOZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609AbXDJOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030583AbXDJOZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:25:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030609AbXDJOZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:25:58 -0400
Message-ID: <461B9E68.6040008@redhat.com>
Date: Tue, 10 Apr 2007 10:25:44 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [patch] PCI: add debug information to resource collision message
Content-Type: multipart/mixed;
 boundary="------------060701080303030207050205"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060701080303030207050205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------060701080303030207050205
Content-Type: text/plain;
 name="i386_pci-add_debugging.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i386_pci-add_debugging.patch"

Add more information to PCI resource collision message
to help with debugging.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
---
 arch/i386/pci/i386.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.noarch.orig/arch/i386/pci/i386.c
+++ linux-2.6.20.noarch/arch/i386/pci/i386.c
@@ -246,8 +246,8 @@ int pcibios_enable_resources(struct pci_
 			continue;
 		if (!r->start && r->end) {
 			printk(KERN_ERR "PCI: Device %s not available "
-				"because of resource collisions\n",
-				pci_name(dev));
+				"because of resource %d collisions\n",
+				pci_name(dev), idx);
 			return -EINVAL;
 		}
 		if (r->flags & IORESOURCE_IO)

--------------060701080303030207050205--
