Return-Path: <linux-kernel-owner+w=401wt.eu-S1946372AbXBQCwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946372AbXBQCwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946373AbXBQCwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:52:32 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:28203 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946372AbXBQCwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:52:31 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com, Sylvain Munaut <tnt@246tnt.com>
Subject: [PATCH 2.6.21-rc1] ibmebus: Use of_device_uevent()
Date: Sat, 17 Feb 2007 03:56:12 +0100
User-Agent: KMail/1.8.2
Cc: pmac@au1.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702170356.12600.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces ibmebus_uevent() by Sylvain's generic function.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


 ibmebus.c |   37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)


diff -urp a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c	2007-02-17 03:25:53.403375784 +0100
+++ b/arch/powerpc/kernel/ibmebus.c	2007-02-17 03:27:28.230336112 +0100
@@ -372,41 +372,10 @@ static int ibmebus_bus_match(struct devi
 	return 0;
 }
 
-static int ibmebus_uevent(struct device *dev, char **envp, int num_envp,
-			char *buffer, int buffer_size)
-{
-	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
-	char *name, *cp, *loc_code;
-	int length;
-
-	if (!num_envp)
-		return -ENOMEM;
-
-	if (!ebus_dev->ofdev.node)
-		return -ENODEV;
-
-	name = (char *)get_property(ebus_dev->ofdev.node, "name", NULL);
-	cp = (char *)get_property(ebus_dev->ofdev.node, "compatible", NULL);
-	loc_code = (char *)get_property(ebus_dev->ofdev.node,
-					"ibm,loc-code", NULL);
-	if (!(name && cp && loc_code))
-		return -ENODEV;
-
-	envp[0] = buffer;
-	length = scnprintf(buffer, buffer_size,
-			   "MODALIAS=ibmebus:T%s:S%s:L%s",
-			   name, cp, loc_code);
-	if (buffer_size - length <= 0)
-		return -ENOMEM;
-	envp[1] = NULL;
-
-	return 0;
-}
-
 struct bus_type ibmebus_bus_type = {
-	.name = "ibmebus",
-	.uevent = ibmebus_uevent,
-	.match = ibmebus_bus_match,
+	.name   = "ibmebus",
+	.uevent = of_device_uevent,
+	.match  = ibmebus_bus_match,
 };
 EXPORT_SYMBOL(ibmebus_bus_type);
 


