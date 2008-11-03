Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYKCUGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYKCUGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbYKCUFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:05:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:11135 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbYKCUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:05:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rZ9h0YECoWB0oHjuDupb5ZfztHtCj7+ZJEEQQs5ToqA4rprgGgrhyL3EHZCMQwyatX
         dN3Y/xahpmTLO2eavLVm0hgXJ7l8i48KbeN2EeDcFsmKZGPRgFtppu5kqv+xYaph4FZN
         6wmX+o07tcXRU4hwzTg49rQZB4pqI6e5ILvuo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Mon, 03 Nov 2008 21:03:19 +0100
Message-Id: <20081103200319.5098.23834.sendpatchset@localhost.localdomain>
In-Reply-To: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/6] cy82c693: remove superfluous ide_cy82c693 chipset type
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cy82c693: remove superfluous ide_cy82c693 chipset type

Since CY82C693 doesn't require serialization we may as well
use the default ide_pci chipset type.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cy82c693.c |    1 -
 drivers/ide/ide-proc.c |    1 -
 include/linux/ide.h    |    3 +--
 3 files changed, 1 insertion(+), 4 deletions(-)

Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -292,7 +292,6 @@ static const struct ide_port_info cy82c6
 	.name		= DRV_NAME,
 	.init_iops	= init_iops_cy82c693,
 	.port_ops	= &cy82c693_port_ops,
-	.chipset	= ide_cy82c693,
 	.host_flags	= IDE_HFLAG_SINGLE,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2,
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -46,7 +46,6 @@ static int proc_ide_read_imodel
 	case ide_qd65xx:	name = "qd65xx";	break;
 	case ide_umc8672:	name = "umc8672";	break;
 	case ide_ht6560b:	name = "ht6560b";	break;
-	case ide_cy82c693:	name = "cy82c693";	break;
 	case ide_4drives:	name = "4drives";	break;
 	case ide_pmac:		name = "mac-io";	break;
 	case ide_au1xxx:	name = "au1xxx";	break;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -163,8 +163,7 @@ typedef int (ide_ack_intr_t)(struct hwif
 enum {		ide_unknown,	ide_generic,	ide_pci,
 		ide_cmd640,	ide_dtc2278,	ide_ali14xx,
 		ide_qd65xx,	ide_umc8672,	ide_ht6560b,
-		ide_cy82c693,	ide_4drives,
-		ide_pmac,	ide_acorn,
+		ide_4drives,	ide_pmac,	ide_acorn,
 		ide_au1xxx,	ide_palm3710
 };
 
