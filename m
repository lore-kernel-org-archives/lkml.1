Return-Path: <linux-kernel-owner+w=401wt.eu-S2992737AbXCBX2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992737AbXCBX2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992743AbXCBX2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:28:37 -0500
Received: from ns1.suse.de ([195.135.220.2]:52696 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992737AbXCBX2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:28:36 -0500
Subject: patch pci-fix-section-mismatch-warning.patch added to gregkh-2.6 tree
To: sam@ravnborg.org, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Fri, 02 Mar 2007 15:27:44 -0800
In-Reply-To: <20070302225904.GB22555@uranus.ravnborg.org>
Message-Id: <20070302232833.BEB80C526CD@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: pci: fix section mismatch warning

to my gregkh-2.6 tree.  Its filename is

     pci-fix-section-mismatch-warning.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From sam@ravnborg.org  Fri Mar  2 15:06:44 2007
From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 2 Mar 2007 23:59:04 +0100
Subject: pci: fix section mismatch warning
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <20070302225904.GB22555@uranus.ravnborg.org>
Content-Disposition: inline


drivers/pci/search.c caused following section mismatch warning
(if compiled with CONFIG_HOTPLUG=n):

WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text: from .text.pci_find_bus after 'pci_find_bus' (at offset 0x24)

This was due to pci_find_bus() calling a function marked __devinit.
Fix was to remove the __devinit from the offending function.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/search.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- gregkh-2.6.orig/drivers/pci/search.c
+++ gregkh-2.6/drivers/pci/search.c
@@ -15,7 +15,7 @@
 
 DECLARE_RWSEM(pci_bus_sem);
 
-static struct pci_bus * __devinit
+static struct pci_bus *
 pci_do_find_bus(struct pci_bus* bus, unsigned char busnr)
 {
 	struct pci_bus* child;


Patches currently in gregkh-2.6 which might be from sam@ravnborg.org are

