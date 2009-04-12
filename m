Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbZDLMYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbZDLMYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 08:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760244AbZDLMYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 08:24:43 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:11640 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135AbZDLMYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 08:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=nmT8gNOPOHoFiJZGnD/mGM3TQh8zD1zd71YcSuxILOrshf1kxT7aASIxLd8xNWVGcU
         HWkDWzPfrBuhOjSuoS6fhkgUEVTNaF4alaZMnsbRNfvmteOXbBmyNIgqbYwtXnIS5OSG
         scYG4fSnxnXg+VccANP0XH+e/9jv/XlsjX1ZA=
Date: Sun, 12 Apr 2009 20:23:17 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: sean.hefty@intel.com
Cc: hal.rosenstock@gmail.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix a warning on drivers/infiniband/hw/nes/nes_cm.c:862:
Message-ID: <20090412122317.GA4787@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this warning:
drivers/infiniband/hw/nes/nes_cm.c:862: warning: unused variable ‘tmp_addr’

the 'tmp_addr' is defined for debug, so it should be defined in
CONFIG_INFINIBAND_NES_DEBUG


>From 5f67884bcda5450807dcd080378d829628e4db1c Mon Sep 17 00:00:00 2001
From: Zhenwen Xu <Helight.Xu@gmail.com>
Date: Sun, 12 Apr 2009 20:12:18 +0800
Subject: [PATCH] fix a warning on drivers/infiniband/hw/nes/nes_cm.c:862:

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/infiniband/hw/nes/nes_cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index dbd9a75..1bad93b 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -854,8 +854,9 @@ static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
 {
 	unsigned long flags;
 	struct nes_cm_listener *listen_node;
+#ifdef CONFIG_INFINIBAND_NES_DEBUG
 	__be32 tmp_addr = cpu_to_be32(dst_addr);
-
+#endif
 	/* walk list and find cm_node associated with this session ID */
 	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
 	list_for_each_entry(listen_node, &cm_core->listen_list.list, list) {
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
