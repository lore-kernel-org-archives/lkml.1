Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbZCMIVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbZCMIVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbZCMIMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:35 -0400
Received: from gw.goop.org ([64.81.55.164]:34823 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756032AbZCMIMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:30 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/24] xen: add irq_from_evtchn
Date: Fri, 13 Mar 2009 01:11:50 -0700
Message-Id: <1236931920-6861-15-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
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

