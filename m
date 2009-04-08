Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbZDHQZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbZDHQZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933911AbZDHQZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:25:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35009 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852AbZDHQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pQC8zFd9qnzsrmuwvQ7LBlc3H+K9EVm1Syb+nMt0XXA6P8zcD1XtwufRvt6Pf6oV7w
         G+2LuKW3tXwd1Nqp99TgGdx/prxM6/d1JWQShlFe4P26d2k44GpN+16skeWPQNssNHpn
         bcAh25JxE2IfDBZ+p4+/8+273bs26LG3pwdXk=
Date: Wed, 8 Apr 2009 18:24:52 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ata: fix obviously wrong comment
Message-ID: <20090408162452.GA10440@damson.cased.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 776d93d1e11ff79ed2693541b0663dbb2ffa3aee Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 8 Apr 2009 18:19:39 +0200
Subject: [PATCH] ata: fix obviously wrong comment

Also remove the now-useless debug printouts which are supposed to
tell us when the scan starts and ends.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/ata/libata-core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e7ea77c..065507c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6110,13 +6110,11 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 			ata_port_printk(ap, KERN_INFO, "DUMMY\n");
 	}
 
-	/* perform each probe synchronously */
-	DPRINTK("probe begin\n");
+	/* perform each probe asynchronously */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 		async_schedule(async_port_probe, ap);
 	}
-	DPRINTK("probe end\n");
 
 	return 0;
 }
-- 
1.6.0.6

