Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZCOFiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZCOFiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 01:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZCOFiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 01:38:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZCOFip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 01:38:45 -0400
Date: Sun, 15 Mar 2009 01:38:42 -0400
From: Kyle McMartin <kyle@infradead.org>
To: axboe@kernel.dk
Cc: mike.miller@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH trivial] cpqarray: enable bus mastering
Message-ID: <20090315053842.GI3167@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

We've been carrying this patch for the last 3 years in Fedora,
long past time we got it upstream...

Call pci_set_master to enable bus-mastering if the BIOS hasn't
done it already.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Dave Jones <davej@redhat.com>

--- a/drivers/block/cpqarray.c	2006-10-06 14:23:34.000000000 -0400
+++ b/drivers/block/cpqarray.c	2006-10-06 14:25:16.000000000 -0400
@@ -614,6 +614,7 @@ static int cpqarray_pci_init(ctlr_info_t
 	int i;
 
 	c->pci_dev = pdev;
+	pci_set_master(pdev);
 	if (pci_enable_device(pdev)) {
 		printk(KERN_ERR "cpqarray: Unable to Enable PCI device\n");
 		return -1;
