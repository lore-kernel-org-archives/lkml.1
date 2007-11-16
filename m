Return-Path: <linux-kernel-owner+w=401wt.eu-S1765866AbXKPL5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765866AbXKPL5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbXKPL5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:57:34 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:44312 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbXKPL5d (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:57:33 -0500
Subject: [PATCH][RT] 2.6.24-rc2-rt1 drivers/dma/ioat_dma.c compile fix
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: RT Users List <linux-rt-users@vger.kernel.org>
Cc: LKML <Linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Suse
Date: Fri, 16 Nov 2007 03:57:25 -0800
Message-Id: <1195214245.3241.37.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compile fix for new code in -rc2.

I'm not positive about the insertion point...

Subject: compile error fix (needs review)

RT changes __list_splice to require prev and next pointers. 

This changes the use in the new code to list_splice_tail, 
but the optimal insertion point needs to be analyzed.

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>

---
 drivers/dma/ioat_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/dma/ioat_dma.c
===================================================================
--- linux-2.6.23.orig/drivers/dma/ioat_dma.c
+++ linux-2.6.23/drivers/dma/ioat_dma.c
@@ -244,7 +244,7 @@ static dma_cookie_t ioat_tx_submit(struc
 	/* write address into NextDescriptor field of last desc in chain */
 	to_ioat_desc(ioat_chan->used_desc.prev)->hw->next =
 							first->async_tx.phys;
-	__list_splice(&new_chain, ioat_chan->used_desc.prev);
+	list_splice_tail(&new_chain, ioat_chan->used_desc.prev);
 
 	ioat_chan->pending += desc_count;
 	if (ioat_chan->pending >= 4) {


