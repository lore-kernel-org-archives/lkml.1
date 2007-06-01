Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbXFABQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbXFABQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759013AbXFABQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:16:01 -0400
Received: from mail.kroah.org ([69.55.234.183]:46580 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758522AbXFABP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:15:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, Ben Gardner <gardner.ben@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] PCI: Fix pci_find_present
Date: Thu, 31 May 2007 18:16:55 -0700
Message-Id: <11806606172411-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11806606172891-git-send-email-gregkh@suse.de>
References: <20070601011612.GA28262@kroah.com>
 <11806606172653-git-send-email-gregkh@suse.de>
 <11806606172891-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Gardner <gardner.ben@gmail.com>

pci_find_present() is only matching the last item in the list of ids.

The break after the match is found only escapes the for loop, not the
while loop, so found gets reset to NULL on the next pass.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/search.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index b137a27..c132324 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -403,10 +403,11 @@ const struct pci_device_id *pci_find_present(const struct pci_device_id *ids)
 	while (ids->vendor || ids->subvendor || ids->class_mask) {
 		list_for_each_entry(dev, &pci_devices, global_list) {
 			if ((found = pci_match_one_device(ids, dev)) != NULL)
-				break;
+				goto exit;
 		}
 		ids++;
 	}
+exit:
 	up_read(&pci_bus_sem);
 	return found;
 }
-- 
1.5.2

