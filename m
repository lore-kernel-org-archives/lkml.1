Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbYBTIlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbYBTIlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbYBTIkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:40:01 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42879 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbYBTIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:39:59 -0500
Date: Wed, 20 Feb 2008 00:36:25 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 4/4] driver: use dev_to_node in pci_call_probe
In-reply-to: <200802200015.43547.yinghai.lu@sun.com>
To: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802200036.25222.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802200015.43547.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to make sure get one online node.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -181,8 +181,8 @@ static int pci_call_probe(struct pci_dri
 	   any need to change it. */
 	struct mempolicy *oldpol;
 	cpumask_t oldmask = current->cpus_allowed;
-	int node = pcibus_to_node(dev->bus);
-	if (node >= 0 && node_online(node))
+	int node = dev_to_node(&dev->dev);
+	if (node >= 0)
 	    set_cpus_allowed(current, node_to_cpumask(node));
 	/* And set default memory allocation policy */
 	oldpol = current->mempolicy;
