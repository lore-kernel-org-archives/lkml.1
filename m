Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbZCMQrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbZCMQrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbZCMQnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:31 -0400
Received: from gw.goop.org ([64.81.55.164]:57290 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759445AbZCMQna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:30 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Gerd Hoffmann <kraxel@xeni.home.kraxel.org>
Subject: [PATCH 16/17] xen: fix legacy irq setup, make ioapic-less machines work.
Date: Fri, 13 Mar 2009 09:42:37 -0700
Message-Id: <1236962558-13748-17-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>

Signed-off-by: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>
---
 arch/x86/xen/pci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index fb3ada9..69b475b 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -65,6 +65,12 @@ void __init xen_setup_pirqs(void)
 {
 	int irq;
 
+	if (0 == nr_ioapics) {
+		for (irq=0; irq < NR_IRQS_LEGACY; irq++)
+			xen_allocate_pirq(irq, "xt-pic");
+		return;
+	}
+
 	/* Pre-allocate legacy irqs */
 	for (irq=0; irq < NR_IRQS_LEGACY; irq++) {
 		int trigger, polarity;
-- 
1.6.0.6

