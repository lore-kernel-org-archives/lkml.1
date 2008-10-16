Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYJPRN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYJPRN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYJPRMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:12:53 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7116 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752710AbYJPRMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:12:52 -0400
Date: Thu, 16 Oct 2008 21:12:51 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 1/7] powerpc and sparc: introduce dev_archdata node
	accessors
Message-ID: <20081016171251.GA5515@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name of the device_node field differ across the platforms, so we
have to implement inlined accessors. This is needed to avoid ugly
#ifdef in the generic code.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/include/asm/device.h |   12 ++++++++++++
 arch/sparc/include/asm/device.h   |   12 ++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index dfd504c..7d2277c 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -18,4 +18,16 @@ struct dev_archdata {
 	void			*dma_data;
 };
 
+static inline void dev_archdata_set_node(struct dev_archdata *ad,
+					 struct device_node *np)
+{
+	ad->of_node = np;
+}
+
+static inline struct device_node *
+dev_archdata_get_node(const struct dev_archdata *ad)
+{
+	return ad->of_node;
+}
+
 #endif /* _ASM_POWERPC_DEVICE_H */
diff --git a/arch/sparc/include/asm/device.h b/arch/sparc/include/asm/device.h
index 19790eb..3702e08 100644
--- a/arch/sparc/include/asm/device.h
+++ b/arch/sparc/include/asm/device.h
@@ -20,4 +20,16 @@ struct dev_archdata {
 	int			numa_node;
 };
 
+static inline void dev_archdata_set_node(struct dev_archdata *ad,
+					 struct device_node *np)
+{
+	ad->prom_node = np;
+}
+
+static inline struct device_node *
+dev_archdata_get_node(const struct dev_archdata *ad)
+{
+	return ad->prom_node;
+}
+
 #endif /* _ASM_SPARC_DEVICE_H */
-- 
1.5.6.3

