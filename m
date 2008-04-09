Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbYDIPs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYDIPs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYDIPss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:48:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:50376 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYDIPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:48:48 -0400
Date: Wed, 9 Apr 2008 08:48:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] Re: build issue #470 for v2.6.25-rc8-166-g6fdf5e6
 :rtc-s35390a.c:144: undefined reference to `byte_rev_table'
Message-Id: <20080409084819.78eaa342.randy.dunlap@oracle.com>
In-Reply-To: <200804090957.55929.toralf.foerster@gmx.de>
References: <200804090957.55929.toralf.foerster@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

rtc-s35390a uses BITREVERSE functions so it needs to select that
config symbol to ensure that the functions are built.

drivers/built-in.o: In function `s35390a_set_datetime':
linux-2.6.25-rc8-git7/drivers/rtc/rtc-s35390a.c:144: undefined reference to `byte_rev_table'
drivers/built-in.o: In function `s35390a_get_datetime':
linux-2.6.25-rc8-git7/drivers/rtc/rtc-s35390a.c:163: undefined reference to `byte_rev_table'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.25-rc8-git7.orig/drivers/rtc/Kconfig
+++ linux-2.6.25-rc8-git7/drivers/rtc/Kconfig
@@ -252,6 +252,7 @@ config RTC_DRV_TWL92330
 
 config RTC_DRV_S35390A
 	tristate "Seiko Instruments S-35390A"
+	select BITREVERSE
 	help
 	  If you say yes here you will get support for the Seiko
 	  Instruments S-35390A.
