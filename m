Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYBRQg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYBRQg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYBRQfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:35:36 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:31072 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbYBRQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:35:35 -0500
Message-Id: <20080218163732.359446793@ldl.fc.hp.com>
References: <20080218163403.364442547@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Feb 2008 09:34:06 -0700
From: bjorn.helgaas@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/3] PCI: Simplify quirk debug output
Content-Disposition: inline; filename=pci-quirk-debug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_fn_descriptor_symbol() prints the address if we don't have a symbol,
so no need to print both.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work6/drivers/pci/quirks.c
===================================================================
--- work6.orig/drivers/pci/quirks.c	2008-02-18 08:12:18.000000000 -0700
+++ work6/drivers/pci/quirks.c	2008-02-18 08:42:45.000000000 -0700
@@ -1498,8 +1498,8 @@
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
 #ifdef DEBUG
-			dev_dbg(&dev->dev, "calling quirk 0x%p", f->hook);
-			print_fn_descriptor_symbol(": %s()\n",
+			dev_dbg(&dev->dev, "calling ");
+			print_fn_descriptor_symbol("%s()\n",
 				(unsigned long) f->hook);
 #endif
 			f->hook(dev);

-- 
