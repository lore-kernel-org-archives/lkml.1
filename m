Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab0CKSGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:06:38 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:43634 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619Ab0CKSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:06:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 25/37] drivers/infiniband: use .dev.of_node instead of .node
	in struct of_device
To: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Date: Thu, 11 Mar 2010 11:06:06 -0700
Message-ID: <20100311180605.4824.3613.stgit@angua>
In-Reply-To: <20100311174830.4824.19820.stgit@angua>
References: <20100311174830.4824.19820.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.node is being removed

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/infiniband/hw/ehca/ehca_main.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 129a6be..2639185 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -291,8 +291,9 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 	};
 
 	ehca_gen_dbg("Probing adapter %s...",
-		     shca->ofdev->node->full_name);
-	loc_code = of_get_property(shca->ofdev->node, "ibm,loc-code", NULL);
+		     shca->ofdev->dev.of_node->full_name);
+	loc_code = of_get_property(shca->ofdev->dev.of_node, "ibm,loc-code",
+				   NULL);
 	if (loc_code)
 		ehca_gen_dbg(" ... location lode=%s", loc_code);
 
@@ -720,16 +721,16 @@ static int __devinit ehca_probe(struct of_device *dev,
 	int ret, i, eq_size;
 	unsigned long flags;
 
-	handle = of_get_property(dev->node, "ibm,hca-handle", NULL);
+	handle = of_get_property(dev->dev.of_node, "ibm,hca-handle", NULL);
 	if (!handle) {
 		ehca_gen_err("Cannot get eHCA handle for adapter: %s.",
-			     dev->node->full_name);
+			     dev->dev.of_node->full_name);
 		return -ENODEV;
 	}
 
 	if (!(*handle)) {
 		ehca_gen_err("Wrong eHCA handle for adapter: %s.",
-			     dev->node->full_name);
+			     dev->dev.of_node->full_name);
 		return -ENODEV;
 	}
 

