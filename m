Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZAGQgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZAGQgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZAGQg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:36:26 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:59734 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZAGQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:36:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=oh5iHxo3120ArGS0FMatZ3f1Uif5PV6wAj2x2mBXgByAzQ0dgQ3MzsJZO80Z6XVgNZ
         TsY/Gsxy/VL0/DzByuIql7Z/dAl82OzHDzUhCLYBXAtqFbLeEVQclOFjbbje3/u0re77
         VXSjBkhDjRm5i7cN5VF3iVVybIXEIyPGZe0xI=
From: Bryan Wu <cooloney@kernel.org>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] pata: fix bug - __pata_platform_remove() should not be in discarded section
Date: Thu,  8 Jan 2009 00:37:12 +0800
Message-Id: <1231346232-27861-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

--
  UPD     include/linux/compile.h
`___pata_platform_remove' referenced in section `__ksymtab_gpl' of
drivers/built-in.o: defined in discarded section `.devexit.text' of
drivers/built-in.o
make: *** [.tmp_vmlinux1] Error 1
--

__pata_platform_remove() should not be in discarded section
__pata_platform_remove(struct device *dev) is invoked in both
pata_platform.c and pata_of_platform.c by reomve function defined in
discarded section ".devexit.text". An exported function should not be put
into discarded section.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/ata/pata_platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 6afa07a..d8d743a 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -186,7 +186,7 @@ EXPORT_SYMBOL_GPL(__pata_platform_probe);
  *	A platform bus ATA device has been unplugged. Perform the needed
  *	cleanup. Also called on module unload for any active devices.
  */
-int __devexit __pata_platform_remove(struct device *dev)
+int __pata_platform_remove(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
 
-- 
1.5.6

