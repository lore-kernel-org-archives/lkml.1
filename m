Return-Path: <linux-kernel-owner+w=401wt.eu-S1767796AbXCJELx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767796AbXCJELx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767782AbXCJEKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:10:31 -0500
Received: from mx1.suse.de ([195.135.220.2]:36329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767779AbXCJEK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:10:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/4] pci: fix section mismatch warning
Date: Fri,  9 Mar 2007 20:08:34 -0800
Message-Id: <11734997244048-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <1173499721772-git-send-email-gregkh@suse.de>
References: <20070310040356.GB30638@kroah.com> <11734997142797-git-send-email-gregkh@suse.de> <1173499718269-git-send-email-gregkh@suse.de> <1173499721772-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

drivers/pci/search.c caused following section mismatch warning
(if compiled with CONFIG_HOTPLUG=n):

WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text: from .text.pci_find_bus after 'pci_find_bus' (at offset 0x24)

This was due to pci_find_bus() calling a function marked __devinit.
Fix was to remove the __devinit from the offending function.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/search.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.5.0.2

