Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZIYWT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZIYWT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZIYWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:19:55 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:51553 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZIYWTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:19:53 -0400
Message-ID: <4ABD4213.9010700@oracle.com>
Date: Fri, 25 Sep 2009 15:20:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Subject: [PATCH -next]  i2c: uses/select RT_MUTEXES
References: <20090925133830.1ba29584.sfr@canb.auug.org.au>
In-Reply-To: <20090925133830.1ba29584.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt013.oracle.com [141.146.116.22]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ABD41D9.013C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

i2c-core uses rt mutexes, so it needs to select that
kconfig symbol since there is no prompt for it.

ERROR: "rt_mutex_lock" [drivers/i2c/i2c-core.ko] undefined!
ERROR: "__rt_mutex_init" [drivers/i2c/i2c-core.ko] undefined!
ERROR: "rt_mutex_trylock" [drivers/i2c/i2c-core.ko] undefined!
ERROR: "rt_mutex_unlock" [drivers/i2c/i2c-core.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/i2c/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090925.orig/drivers/i2c/Kconfig
+++ linux-next-20090925/drivers/i2c/Kconfig
@@ -5,6 +5,7 @@
 menuconfig I2C
 	tristate "I2C support"
 	depends on HAS_IOMEM
+	select RT_MUTEXES
 	---help---
 	  I2C (pronounce: I-square-C) is a slow serial bus protocol used in
 	  many micro controller applications and developed by Philips.  SMBus,
