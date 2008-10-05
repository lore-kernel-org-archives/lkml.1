Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbYJEQhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbYJEQhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbYJEQf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:35:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35283 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761171AbYJEQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:35:58 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 03/19] pcmcia: Whine harder about use of EXCLUSIVE
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:35:59 +0100
Message-ID: <20081005163546.3799.95611.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exclusive IRQ line support is a legacy and any remaining drivers that
cannot share interrupts need tidying up so whine harder about them.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/pcmcia/pcmcia_resource.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index 4884a18..8f1c3d4 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -738,8 +738,9 @@ int pcmcia_request_irq(struct pcmcia_device *p_dev, irq_req_t *req)
 	type = 0;
 	if (s->functions > 1)		/* All of this ought to be handled higher up */
 		type = IRQF_SHARED;
-	if (req->Attributes & IRQ_TYPE_DYNAMIC_SHARING)
+	else if (req->Attributes & IRQ_TYPE_DYNAMIC_SHARING)
 		type = IRQF_SHARED;
+	else printk(KERN_WARNING "pcmcia: Driver needs updating to support IRQ sharing.\n");
 
 #ifdef CONFIG_PCMCIA_PROBE
 

