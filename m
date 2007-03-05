Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbXCEXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbXCEXVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXCEXVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:21:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47912
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbXCEXVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:21:31 -0500
Date: Mon, 05 Mar 2007 15:21:29 -0800 (PST)
Message-Id: <20070305.152129.112853008.davem@davemloft.net>
To: rolandd@cisco.com, swise@opengridcomputing.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH]: CXGB3 infiniband build fix
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Uses dma_alloc_coherent() et al. thus needs linux/dma-mapping.h
include in order to build reliably.

Noticed on sparc64.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index d737c73..818cf1a 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -36,6 +36,7 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/dma-mapping.h>
 
 #include "cxio_resource.h"
 #include "cxio_hal.h"
