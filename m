Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbYECPVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbYECPVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbYECPVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:21:45 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54358 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752961AbYECPVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:21:44 -0400
From: monstr@seznam.cz
To: paulus@samba.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 1/2] OF: Fix coding style violation in of_device.c and of_platform.c
Date: Sat,  3 May 2008 16:22:11 +0200
Message-Id: <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1209824532-7939-1-git-send-email-monstr@seznam.cz>
References: <monstr@seznam.cz>
 <1209824532-7939-1-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/powerpc/kernel/of_device.c   |   25 ++++++++++++++-----------
 arch/powerpc/kernel/of_platform.c |    5 ++++-
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
index 5748ddb..db9ed02 100644
--- a/arch/powerpc/kernel/of_device.c
+++ b/arch/powerpc/kernel/of_device.c
@@ -8,7 +8,10 @@
 #include <linux/of_device.h>
 
 #include <asm/errno.h>
+
+#ifdef CONFIG_PPC_PSERIES
 #include <asm/dcr.h>
+#endif
 
 static void of_device_make_bus_id(struct of_device *dev)
 {
@@ -106,7 +109,7 @@ ssize_t of_device_get_modalias(struct of_device *ofdev,
 		return csize;
 
 	/* Find true end (we tolerate multiple \0 at the end */
-	for (i=(cplen-1); i>=0 && !compat[i]; i--)
+	for (i = (cplen-1); i >= 0 && !compat[i]; i--)
 		cplen--;
 	if (!cplen)
 		return csize;
@@ -116,26 +119,27 @@ ssize_t of_device_get_modalias(struct of_device *ofdev,
 	tsize = csize + cplen;
 	repend = tsize;
 
-	if (csize>=len)		/* @ the limit, all is already filled */
+	if (csize >= len)	/* @ the limit, all is already filled */
 		return tsize;
 
-	if (tsize>=len) {		/* limit compat list */
-		cplen = len-csize-1;
+	if (tsize >= len) {	/* limit compat list */
+		cplen = len - csize - 1;
 		repend = len;
 	}
 
 	/* Copy and do char replacement */
 	memcpy(&str[csize+1], compat, cplen);
-	for (i=csize; i<repend; i++) {
+	for (i = csize; i < repend; i++) {
 		char c = str[i];
-		if (c=='\0')
+		if (c == '\0')
 			str[i] = 'C';
-		else if (c==' ')
+		else if (c == ' ')
 			str[i] = '_';
 	}
 
 	return tsize;
 }
+EXPORT_SYMBOL(of_device_get_modalias);
 
 int of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -154,9 +158,9 @@ int of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (add_uevent_var(env, "OF_TYPE=%s", ofdev->node->type))
 		return -ENOMEM;
 
-        /* Since the compatible field can contain pretty much anything
-         * it's not really legal to split it out with commas. We split it
-         * up using a number of environment variables instead. */
+	/* Since the compatible field can contain pretty much anything
+	 * it's not really legal to split it out with commas. We split it
+	 * up using a number of environment variables instead. */
 
 	compat = of_get_property(ofdev->node, "compatible", &cplen);
 	while (compat && *compat && cplen > 0) {
@@ -184,4 +188,3 @@ int of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 EXPORT_SYMBOL(of_device_uevent);
-EXPORT_SYMBOL(of_device_get_modalias);
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index e79ad8a..cd9336e 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -26,9 +26,12 @@
 #include <asm/errno.h>
 #include <asm/topology.h>
 #include <asm/pci-bridge.h>
-#include <asm/ppc-pci.h>
 #include <asm/atomic.h>
 
+#ifdef CONFIG_PPC_PSERIES
+#include <asm/ppc-pci.h>
+#endif
+
 /*
  * The list of OF IDs below is used for matching bus types in the
  * system whose devices are to be exposed as of_platform_devices.
-- 
1.5.4.GIT

