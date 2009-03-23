Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbZCWSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbZCWSEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZCWSEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:04:25 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:35002
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757452AbZCWSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:04:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/11] xen: add irq_from_evtchn
Date: Mon, 23 Mar 2009 10:55:01 -0700
Message-Id: <1237830911-6249-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Given an evtchn, return the corresponding irq.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |    6 ++++++
 include/xen/events.h |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 30963af..1cd2a0e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -151,6 +151,12 @@ static unsigned int evtchn_from_irq(unsigned irq)
 	return info_for_irq(irq)->evtchn;
 }
 
+unsigned irq_from_evtchn(unsigned int evtchn)
+{
+	return evtchn_to_irq[evtchn];
+}
+EXPORT_SYMBOL_GPL(irq_from_evtchn);
+
 static enum ipi_vector ipi_from_irq(unsigned irq)
 {
 	struct irq_info *info = info_for_irq(irq);
diff --git a/include/xen/events.h b/include/xen/events.h
index 0d5f1ad..e68d59a 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -53,4 +53,7 @@ bool xen_test_irq_pending(int irq);
    irq will be disabled so it won't deliver an interrupt. */
 void xen_poll_irq(int irq);
 
+/* Determine the IRQ which is bound to an event channel */
+unsigned irq_from_evtchn(unsigned int evtchn);
+
 #endif	/* _XEN_EVENTS_H */
-- 
1.6.0.6

