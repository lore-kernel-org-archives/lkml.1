Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbXJaG3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbXJaG3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbXJaG33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:29:29 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45823 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbXJaG32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:29:28 -0400
Date: Wed, 31 Oct 2007 00:28:48 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] [POWERPC] Fix region size check in mpc5200 FEC driver
In-reply-to: <20071031062842.7966.99739.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-id: <20071031062848.7966.35512.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071031062842.7966.99739.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Driver shouldn't complain if the register range is larger than what
it expects.  This works around failures with some device trees.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/net/fec_mpc52xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/fec_mpc52xx.c b/drivers/net/fec_mpc52xx.c
index fc1cf0b..a8a0ee2 100644
--- a/drivers/net/fec_mpc52xx.c
+++ b/drivers/net/fec_mpc52xx.c
@@ -879,9 +879,9 @@ mpc52xx_fec_probe(struct of_device *op, const struct of_device_id *match)
 				"Error while parsing device node resource\n" );
 		return rv;
 	}
-	if ((mem.end - mem.start + 1) != sizeof(struct mpc52xx_fec)) {
+	if ((mem.end - mem.start + 1) < sizeof(struct mpc52xx_fec)) {
 		printk(KERN_ERR DRIVER_NAME
-			" - invalid resource size (%lx != %x), check mpc52xx_devices.c\n",
+			" - invalid resource size (%lx < %x), check mpc52xx_devices.c\n",
 			(unsigned long)(mem.end - mem.start + 1), sizeof(struct mpc52xx_fec));
 		return -EINVAL;
 	}

