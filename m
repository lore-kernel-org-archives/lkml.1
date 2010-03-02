Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0CBXh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:37:59 -0500
Received: from kroah.org ([198.145.64.141]:51659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab0CBXhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Breno Leitao <leitao@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/36] jsm: removing the uart structure and filename on error
Date: Tue,  2 Mar 2010 15:36:42 -0800
Message-Id: <1267573003-782-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitao <leitao@linux.vnet.ibm.com>

If jsm fails to load, then remove the uart stuff, otherwise,
the things (as files), will be there forever (even when the module
is unloaded). If you try to reload the module, the following message
appears:

kobject_add_internal failed for ttyn1 with -EEXIST, don't try to
register things with the same name in the same directory.

This patch remove the uart things when the driver fails.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/jsm/jsm_driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index 108c3e0..12cb5e4 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -179,6 +179,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 
 	return 0;
  out_free_irq:
+	jsm_remove_uart_port(brd);
 	free_irq(brd->irq, brd);
  out_iounmap:
 	iounmap(brd->re_map_membase);
-- 
1.7.0.1

