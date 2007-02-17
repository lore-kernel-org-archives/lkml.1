Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXBQQYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXBQQYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992447AbXBQQYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:24:35 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:23438 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992443AbXBQQYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:24:35 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com, Sylvain Munaut <tnt@246tnt.com>
Subject: [PATCH 2.6.21-rc1] powerpc: Make of_device_uevent() compatible with ibmebus
User-Agent: KMail/1.8.2
Cc: pmac@au1.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 17 Feb 2007 17:28:15 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702171728.15597.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ibmebus has a fake root device that's not associated with an ofdt node.
Filter out any such devices in of_device_uevent().


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


 of_device.c |    4 ++++
 1 files changed, 4 insertions(+)


diff -urp a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
--- a/arch/powerpc/kernel/of_device.c	2007-02-17 16:36:32.116368480 +0100
+++ b/arch/powerpc/kernel/of_device.c	2007-02-17 16:44:01.319366352 +0100
@@ -180,6 +180,10 @@ int of_device_uevent(struct device *dev,
 
 	ofdev = to_of_device(dev);
 
+	/* e.g. ibmebus has a fake root device w/o ofdt node -- filter that */
+	if (!ofdev->node)
+		return -ENODEV;
+
 	if (add_uevent_var(envp, num_envp, &i,
 			   buffer, buffer_size, &length,
 			   "OF_NAME=%s", ofdev->node->name))

