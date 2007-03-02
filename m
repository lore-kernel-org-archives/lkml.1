Return-Path: <linux-kernel-owner+w=401wt.eu-S2992711AbXCBW6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992711AbXCBW6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992710AbXCBW6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:58:30 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53261 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992711AbXCBW63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:58:29 -0500
Date: Fri, 2 Mar 2007 23:59:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci: fix section mismatch warning
Message-ID: <20070302225904.GB22555@uranus.ravnborg.org>
References: <20070227092702.GA21337@uranus.ravnborg.org> <20070302204752.GA24716@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302204752.GA24716@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pci/search.c caused following section mismatch warning
(if compiled with CONFIG_HOTPLUG=n):

WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text: from .text.pci_find_bus after 'pci_find_bus' (at offset 0x24)

This was due to pci_find_bus() calling a function marked __devinit.
Fix was to remove the __devinit from the offending function.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

With this patch and my pending kbuild changes drivers/pci/
is now section mismatch free!

	Sam

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index ff98ead..2dd8681 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -15,7 +15,7 @@
 
 DECLARE_RWSEM(pci_bus_sem);
 
-static struct pci_bus * __devinit
+static struct pci_bus *
 pci_do_find_bus(struct pci_bus* bus, unsigned char busnr)
 {
 	struct pci_bus* child;
