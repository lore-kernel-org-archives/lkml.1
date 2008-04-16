Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYDPTAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYDPTAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYDPTAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:00:41 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40392 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYDPTAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:00:40 -0400
Date: Wed, 16 Apr 2008 14:00:40 -0500
From: scameron@beardog.cca.cpqcorp.net
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com,
       mikem@beardog.cca.cpqcorp.net
Subject: [patch] cciss: fix warning oops on rmmod of driver
Message-ID: <20080416190040.GQ16584@beardog.cca.cpqcorp.net>
References: <20080414142019.GG16584@beardog.cca.cpqcorp.net> <20080414170505.GO12774@kernel.dk> <20080414172716.GM16584@beardog.cca.cpqcorp.net> <20080414173720.GQ12774@kernel.dk> <20080414174540.GO16584@beardog.cca.cpqcorp.net> <20080414175219.GR12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414175219.GR12774@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fix oops on cciss rmmod due to calling pci_free_consistent with 
  irqs disabled. 

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
---

 linux-2.6.25-rc9/drivers/block/cciss_scsi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN linux-2.6.25-rc9/drivers/block/cciss_scsi.c~pci_free_consistent_oops linux-2.6.25-rc9/drivers/block/cciss_scsi.c
--- root/linux-2.6.25-rc9/drivers/block/cciss_scsi.c~pci_free_consistent_oops	2008-04-16 12:58:53.000000000 -0500
+++ root-root/linux-2.6.25-rc9/drivers/block/cciss_scsi.c	2008-04-16 12:59:22.000000000 -0500
@@ -1349,9 +1349,9 @@ cciss_unregister_scsi(int ctlr)
 	/* set scsi_host to NULL so our detect routine will 
 	   find us on register */
 	sa->scsi_host = NULL;
+	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 	scsi_cmd_stack_free(ctlr);
 	kfree(sa);
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 }
 
 static int 
_
