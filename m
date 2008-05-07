Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbYEGMni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbYEGMni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbYEGMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:43:15 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:47578 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbYEGMnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:43:11 -0400
Subject: [PATCH 1/3] [2.6.26] memory: Introduce exports for memory notifiers
Content-Disposition: inline
From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Date: Wed, 7 May 2008 14:43:01 +0200
MIME-Version: 1.0
Organization: IBM
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       tklein@de.ibm.com
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805071443.02145.hannes.hering@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two exports to allow modules to use memory notifiers.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
---

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 8ce6de5..937e825 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -53,11 +53,13 @@ int register_memory_notifier(struct notifier_block *nb)
 {
         return blocking_notifier_chain_register(&memory_chain, nb);
 }
+EXPORT_SYMBOL(register_memory_notifier);
 
 void unregister_memory_notifier(struct notifier_block *nb)
 {
         blocking_notifier_chain_unregister(&memory_chain, nb);
 }
+EXPORT_SYMBOL(unregister_memory_notifier);
 
 /*
  * register_memory - Setup a sysfs device for a memory block
-- 
1.5.5.1
