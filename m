Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYEZU2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYEZU2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 16:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYEZU2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 16:28:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:5675 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbYEZU2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 16:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=LhQysiNhnA5jmg1w9xbyBf+/pY4PkTvIY9o4PV+jnDePlMCa2AmNY3/GFyIfhaRZ0l0nTJyyOJXVdRbJKX2kqhsmomZpC9cbJXh/WPXa3rfea+7zBnY1+9NsDIwJfqv1x+MNWiooReU8tVvDHnVNs3yIkvMj5FLB4ODQKy7yWbo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] sis5513: add missing pci_enable_device() call
Date: Tue, 27 May 2008 22:15:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Riccardo Gori <goric@trivenet.it>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805272215.24560.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Riccardo Gori <goric@trivenet.it>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
thanks to Riccardo for an unintentional ;) inspiration

 drivers/ide/pci/sis5513.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -569,6 +569,11 @@ static int __devinit sis5513_init_one(st
 {
 	struct ide_port_info d = sis5513_chipset;
 	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
+	int rc;
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
 
 	if (sis_find_family(dev) == 0)
 		return -ENOTSUPP;
