Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYIMGeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYIMGeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 02:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbYIMGdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 02:33:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:52686 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbYIMGdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 02:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=DQ0TxJplgMLDPRmuWRsjCdwjMEHmOTsmrwifha/n2uuMyZ/JoPqqu/zRxAVjOYZG5A
         LuSForlDRKwqqkFlcRD7Fv/NFSptP2CZzKg277O+7Kkfv4JDY20OsAa/gBN46NvZl7NJ
         OCPraTJFzmPUEKmCkDvriXymbXYwwjYLuPdWg=
Message-ID: <48CB5EA4.10907@gmail.com>
Date: Fri, 12 Sep 2008 23:33:08 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [MTD] physmap.c: Add a dummy release function
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding a dummy release function to the physmap device so as to silence a log
warning on initialization.

Signed-off-by: Zev Weiss <zevweiss@gmail.com>
---
  drivers/mtd/maps/physmap.c |    5 +++++
  1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 49e2039..73a8d3c 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -277,11 +277,16 @@ static struct resource physmap_flash_resource = {
  	.flags		= IORESOURCE_MEM,
  };

+static void physmap_dummy_release(struct device *dev)
+{
+}
+
  static struct platform_device physmap_flash = {
  	.name		= "physmap-flash",
  	.id		= 0,
  	.dev		= {
  		.platform_data	= &physmap_flash_data,
+		.release	= &physmap_dummy_release,
  	},
  	.num_resources	= 1,
  	.resource	= &physmap_flash_resource,
-- 
1.5.4.1


