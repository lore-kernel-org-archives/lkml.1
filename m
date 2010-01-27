Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683Ab0A0CSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0A0CSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788Ab0A0CSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:18:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59663 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab0A0CSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:18:32 -0500
Date: Wed, 27 Jan 2010 13:18:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ron Mercer <ron.mercer@qlogic.com>,
       Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: linux-next: net tree build failure
Message-Id: <20100127131827.6aea9bf5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/net/qlge/qlge_main.c: In function 'ql_init_device':
drivers/net/qlge/qlge_main.c:4502: error: label 'err_out' used but not defined

Caused by commit 8aae2600030f54494f9061d2cde141802d774be9 ("qlge: Add
basic firmware dump") interacting with commit
4f9a91c81273b66afe0b6a9be460b47581b28246 ("qlge: Only free resources if
they were allocated") from Linus' tree.

I applied the following merge fixup.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 27 Jan 2010 13:10:17 +1100
Subject: [PATCH] net: merge fixup for qlge_main

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/qlge/qlge_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 4adca94..5be3ae2 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -4499,7 +4499,7 @@ static int __devinit ql_init_device(struct pci_dev *pdev,
 		if (qdev->mpi_coredump == NULL) {
 			dev_err(&pdev->dev, "Coredump alloc failed.\n");
 			err = -ENOMEM;
-			goto err_out;
+			goto err_out2;
 		}
 		if (qlge_force_coredump)
 			set_bit(QL_FRC_COREDUMP, &qdev->flags);
-- 
1.6.6

