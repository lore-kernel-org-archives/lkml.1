Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZIVKdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZIVKdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZIVKdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:33:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbZIVKdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:33:17 -0400
Date: Tue, 22 Sep 2009 12:33:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [origin tree build failure] [PATCH] Re: [git pull] drm tree.
Message-ID: <20090922103312.GA13894@elte.hu>
References: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie> <20090921161207.GA9741@elte.hu> <alpine.DEB.2.00.0909220450440.7648@skynet.skynet.ie> <20090922102726.GA31054@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922102726.GA31054@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


here's a patch that works for me.

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/vgaarb.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index e81c64a..923f904 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -41,7 +41,7 @@
  *     interrupts at any time.
  */
 extern void vga_set_legacy_decoding(struct pci_dev *pdev,
-									unsigned int decodes);
+				    unsigned int decodes);
 
 /**
  *     vga_get         - acquire & locks VGA resources
@@ -193,8 +193,17 @@ static inline int vga_conflicts(struct pci_dev *p1, struct pci_dev *p2)
  * They driver will get a callback when VGA arbitration is first used
  * by userspace since we some older X servers have issues.
  */
+#if defined(CONFIG_VGA_ARB)
 int vga_client_register(struct pci_dev *pdev, void *cookie,
 			void (*irq_set_state)(void *cookie, bool state),
 			unsigned int (*set_vga_decode)(void *cookie, bool state));
+#else
+static inline int vga_client_register(struct pci_dev *pdev, void *cookie,
+				      void (*irq_set_state)(void *cookie, bool state),
+				      unsigned int (*set_vga_decode)(void *cookie, bool state))
+{
+	return 0;
+}
+#endif
 
 #endif /* LINUX_VGA_H */
