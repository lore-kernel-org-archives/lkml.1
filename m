Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYGZNnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYGZNnn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYGZNmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:42:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:59814 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbYGZNmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Mbl4lGIiKqV52tT85BW8fwfuUF3c0qQDcSVTDVSa1dqUJ493S942b4RX9Y/J7wBe9G
         65G9iuIaTWPQRuHCtiJOAH2gmjPqC3UpfT+MHCTwvi72OLjx1IHB3OP/6Y+waotc82bA
         KB0SfHMocds449BKRppkWNYqDK8FB1XFSijAI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:40:30 +0200
Message-Id: <20080726134030.10589.69015.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/10] ide: remove no longer needed BUG_ON()-s from init_irq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_irq() is now called only during initial host registration
so these BUG_ON()-s are no loner needed (+ the last one was done
too late anyway).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1031,11 +1031,6 @@ static int init_irq (ide_hwif_t *hwif)
 	ide_hwgroup_t *hwgroup;
 	ide_hwif_t *match = NULL;
 
-
-	BUG_ON(in_interrupt());
-	BUG_ON(irqs_disabled());	
-	BUG_ON(hwif == NULL);
-
 	mutex_lock(&ide_cfg_mtx);
 	hwif->hwgroup = NULL;
 #if MAX_HWIFS > 1
