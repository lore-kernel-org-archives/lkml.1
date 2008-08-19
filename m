Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYHSWzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYHSWzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYHSWxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:36 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:47891 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbYHSWxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:34 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 4/8] PNP: use new vsprintf symbolic function pointer format
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:31 -0600
Message-ID: <20080819225331.28206.82730.stgit@tigger.helgaas>
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the '%pF' format to get rid of an "#ifdef DEBUG".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/quirks.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..414bb09 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -337,10 +337,8 @@ void pnp_fixup_device(struct pnp_dev *dev)
 	for (f = pnp_fixups; *f->id; f++) {
 		if (!compare_pnp_id(dev->id, f->id))
 			continue;
-#ifdef DEBUG
-		dev_dbg(&dev->dev, "%s: calling ", f->id);
-		print_fn_descriptor_symbol("%s\n", f->quirk_function);
-#endif
+		dev_dbg(&dev->dev, "%s: calling %pF\n", f->id,
+			f->quirk_function);
 		f->quirk_function(dev);
 	}
 }

