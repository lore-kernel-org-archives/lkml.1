Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYBQM1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYBQM1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbYBQMXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:12 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55080 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 24/27] pcmcia: annotate cb_alloc with __ref
Date: Sun, 17 Feb 2008 13:23:01 +0100
Message-Id: <1203250984-11285-24-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cb_alloc() uses a function (pci_scan_slot) that will
be annotated __devinit.
Annotate cb_alloc() with __ref to tell modpost to ignore
this reference.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/pcmcia/cardbus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
index 714baae..fb2f38d 100644
--- a/drivers/pcmcia/cardbus.c
+++ b/drivers/pcmcia/cardbus.c
@@ -209,7 +209,7 @@ static void cardbus_assign_irqs(struct pci_bus *bus, int irq)
 	}
 }
 
-int cb_alloc(struct pcmcia_socket * s)
+int __ref cb_alloc(struct pcmcia_socket * s)
 {
 	struct pci_bus *bus = s->cb_dev->subordinate;
 	struct pci_dev *dev;
-- 
1.5.4.rc3.14.g44397

