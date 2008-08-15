Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbYHOPE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbYHOPE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYHOPEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:04:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbYHOPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:04:14 -0400
Date: Fri, 15 Aug 2008 11:04:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
cc: trem@mandriva.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RT] fix flags in usb code
Message-ID: <alpine.DEB.1.10.0808151102560.2188@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix flags in usb code

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 drivers/usb/host/isp1760-hcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rt1/drivers/usb/host/isp1760-hcd.c
===================================================================
--- linux-2.6.26-rt1.orig/drivers/usb/host/isp1760-hcd.c	2008-08-12 11:36:53.000000000 -0400
+++ linux-2.6.26-rt1/drivers/usb/host/isp1760-hcd.c	2008-08-12 11:37:40.000000000 -0400
@@ -1592,7 +1592,7 @@ static int isp1760_urb_dequeue(struct us
 	struct inter_packet_info *ints;
 	u32 i;
 	u32 reg_base, or_reg, skip_reg;
-	int flags;
+	unsigned long flags;
 	struct ptd ptd;
 
 	switch (usb_pipetype(urb->pipe)) {
@@ -2061,7 +2061,7 @@ static void isp1760_endpoint_disable(str
 	struct isp1760_hcd *priv = hcd_to_priv(usb_hcd);
 	struct isp1760_qh *qh;
 	struct isp1760_qtd *qtd;
-	u32 flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	qh = ep->hcpriv;

