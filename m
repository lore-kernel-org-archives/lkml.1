Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYBAQQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYBAQQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYBAQQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:16:36 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:64648 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYBAQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:16:34 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/base: export (un)register_memory_notifier
Date: Fri, 1 Feb 2008 17:16:31 +0100
User-Agent: KMail/1.8.2
Cc: "Jan-Bernd Themann" <themann@de.ibm.com>,
       Thomas Klein <osstklei@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200802011716.32511.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers like eHEA need memory notifiers in order to 
update their internal DMA memory map when memory is added
to or removed from the system.

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

---
 Comment: eHEA patches that exploit these functions will follow


 drivers/base/memory.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7ae413f..1e1bd4c 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -52,11 +52,13 @@ int register_memory_notifier(struct notifier_block *nb)
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
1.5.2

