Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYLBNxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYLBNxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYLBNw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:52:58 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:42147 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYLBNw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:52:57 -0500
Date: Tue, 2 Dec 2008 14:52:51 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg K-H <greg@kroah.com>
Cc: Jason Baron <jbaron@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] DEBUG_KOBJECT vs. DYNAMIC_PRINTK_DEBUG
Message-ID: <20081202145251.6555d4cc@gondolin>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_KOBJECT has no effect when DYNAMIC_PRINTK_DEBUG is set
(and you can get the messages via that feature), so let's make
it depend on !DYNAMIC_PRINTK_DEBUG.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -450,7 +450,7 @@ config STACKTRACE
 
 config DEBUG_KOBJECT
 	bool "kobject debugging"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && !DYNAMIC_PRINTK_DEBUG
 	help
 	  If you say Y here, some extra kobject debugging messages will be sent
 	  to the syslog. 
