Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYIMGda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYIMGda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 02:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYIMGdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 02:33:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:31032 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYIMGdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 02:33:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=N7uJ/EtjF+mFZjYCDF/3rdUai5ITrqy9dTngp4KVzmfDGOV4EZ0I1M7QK6s2Mb+Oyw
         W6xA6//hpA5wkLjtE5WVaJOqBN7ZJQE2Y6ZFWzCCdinkecKH9OZxx/Rt3iML6+9hpqRK
         DRbTP8qIDUp6hIKD4DG+bwcViTfksol3aBJkk=
Message-ID: <48CB5E9A.4010000@gmail.com>
Date: Fri, 12 Sep 2008 23:32:58 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [MTD] physmap.c: Check return of platform_device_register()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The PHYSMAP_COMPAT code had been ignoring the return value of
platform_device_register() in the physmap_init() function.

Signed-off-by: Zev Weiss <zevweiss@gmail.com>
---
  drivers/mtd/maps/physmap.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 42d844f..6fba0d4 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -312,7 +312,7 @@ static int __init physmap_init(void)
  	err = platform_driver_register(&physmap_flash_driver);
  #ifdef PHYSMAP_COMPAT
  	if (err == 0)
-		platform_device_register(&physmap_flash);
+		err = platform_device_register(&physmap_flash);
  #endif

  	return err;
-- 
1.5.4.1


