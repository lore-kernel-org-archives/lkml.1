Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbXCEU6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbXCEU6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXCEU6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:12 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46840 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161AbXCEU6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:08 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 09/11] uml: fix confusion irq early reenabling
Date: Mon, 05 Mar 2007 21:49:08 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204908.9072.72355.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L03ZJ008286

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Fix confusion about call context - comments and code are inconsistent and plain
wrong, my fault.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/drivers/line.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 01d4ab6..f75d7b0 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -370,10 +370,10 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 	struct tty_struct *tty = line->tty;
 	int err;
 
-	/* Interrupts are enabled here because we registered the interrupt with
+	/* Interrupts are disabled here because we registered the interrupt with
 	 * IRQF_DISABLED (see line_setup_irq).*/
 
-	spin_lock_irq(&line->lock);
+	spin_lock(&line->lock);
 	err = flush_buffer(line);
 	if (err == 0) {
 		return IRQ_NONE;
@@ -381,7 +381,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 		line->head = line->buffer;
 		line->tail = line->buffer;
 	}
-	spin_unlock_irq(&line->lock);
+	spin_unlock(&line->lock);
 
 	if(tty == NULL)
 		return IRQ_NONE;


