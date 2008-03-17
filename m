Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYCQJ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYCQJ72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYCQJ7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:59:20 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:21955 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYCQJ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:59:20 -0400
Date: Mon, 17 Mar 2008 10:58:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] thermal: fix Kconfig dependencies
Message-ID: <20080317095845.GA6500@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9
"thermal: fix generic thermal I/F for hwmon" adds a select HWMON
to THERMAL. This causes HWMON to be selected regardless of its
other dependencies. In this case depends on HAS_IOMEM gets ignored
which causes this build error on s390:

drivers/hwmon/w83627hf.c: In function 'superio_outb':
drivers/hwmon/w83627hf.c:117: error: implicit declaration of function 'outb'

Change the select to a depends on to fix this. Should work as well.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/thermal/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/thermal/Kconfig
===================================================================
--- linux-2.6.orig/drivers/thermal/Kconfig
+++ linux-2.6/drivers/thermal/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig THERMAL
 	bool "Generic Thermal sysfs driver"
-	select HWMON
+	depends on HWMON
 	default y
 	help
 	  Generic Thermal Sysfs driver offers a generic mechanism for
