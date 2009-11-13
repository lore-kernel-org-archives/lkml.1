Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZKMRFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZKMRFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZKMRFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:05:33 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:49340 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbZKMRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:05:32 -0500
Message-ID: <4AFD91DD.7000104@linux.vnet.ibm.com>
Date: Fri, 13 Nov 2009 15:05:33 -0200
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: rjw@sisk.pl
Subject: PCI: pci_restore_state() is returning 0 when it fails
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually pci_restore_state() is returning 0 if the restore process
fails, instead of a error value.

If it fails, I believe that it should return -EPERM, once that
it is an invalid operation and probably pci_save_state() wasn't
called.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/pci/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4e4c295..b677ca3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -857,7 +857,7 @@ pci_restore_state(struct pci_dev *dev)
 	u32 val;
 
 	if (!dev->state_saved)
-		return 0;
+		return -EPERM;
 
 	/* PCI Express register must be restored first */
 	pci_restore_pcie_state(dev);
-- 
1.6.0.4

