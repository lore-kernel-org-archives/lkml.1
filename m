Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbYHLJcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbYHLJcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYHLJbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:31:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:55600 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYHLJbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=KSmqAjCIRG2YjG5Rmz0GB2UsdWRJJ54xkNTBe/c05/YOW9hk6ibyc3owVICiblK0ax
         U9XZE2phWdYxyLLPksMPGh/mRGtoBJPK4iVnvdTD5ATv3kveMre7gFHvxYhYl4JcnCgO
         FkDQJryc6VqmX1ajeEAnK+ABh+WU792kUEH+E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] sgiioc4: fixup message on resource allocation failure
Date: Tue, 12 Aug 2008 11:27:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121127.23512.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There can be more than one sgiioc4 card in the system so print
also PCI device name on resource allocation failure (so we know
which one is the problematic one).

Reported-by: Jeremy Higdon <jeremy@sgi.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sgiioc4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -621,9 +621,9 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	if (!request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
 	    DRV_NAME)) {
 		printk(KERN_ERR
-			"%s : %s -- ERROR, Addresses "
+			"%s %s: -- ERROR, Addresses "
 			"0x%p to 0x%p ALREADY in use\n",
-		       __func__, DRV_NAME, (void *) cmd_phys_base,
+		       DRV_NAME, pci_name(dev), (void *)cmd_phys_base,
 		       (void *) cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
 		return -ENOMEM;
 	}
