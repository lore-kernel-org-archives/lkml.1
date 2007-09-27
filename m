Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbXI0Ult@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbXI0Ult (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758845AbXI0Ula
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:41:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828AbXI0Ul3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:41:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=qAoI4EnWgFYkpx+eiiiT8AN4VpwOdTMVH8aaTNkKEKHp5w7Nch8EZlxxbZiFshWEv
	3TaM4lN65n+u1/UnMAfMg==
Date: Thu, 27 Sep 2007 13:41:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [patch 1/2] pci: use size stored in proc_dir_entry for proc bus
 files
Message-ID: <alpine.DEB.0.9999.0709271322370.8767@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On pci_proc_attach_device(), the size of the PCI configuration space is
stored in the proc_dir_entry as the size of the file.  Thus, the procfs
interface to PCI devices should use it instead of the device directly.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/pci/proc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -60,7 +60,7 @@ proc_bus_pci_read(struct file *file, char __user *buf, size_t nbytes, loff_t *pp
 	 */
 
 	if (capable(CAP_SYS_ADMIN))
-		size = dev->cfg_size;
+		size = dp->size;
 	else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 		size = 128;
 	else
@@ -133,7 +133,7 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 	const struct proc_dir_entry *dp = PDE(ino);
 	struct pci_dev *dev = dp->data;
 	int pos = *ppos;
-	int size = dev->cfg_size;
+	int size = dp->size;
 	int cnt;
 
 	if (pos >= size)
