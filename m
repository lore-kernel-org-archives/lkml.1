Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbXJ2SWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbXJ2SWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbXJ2SV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:21:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26827 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbXJ2SV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:21:56 -0400
Date: Mon, 29 Oct 2007 11:20:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: perex@perex.cz
Subject: [PATCH] sound/ad1848: fix printk format
Message-Id: <20071029112010.1cecaefd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

sound/isa/ad1848/ad1848_lib.c:216: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/isa/ad1848/ad1848_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2624-rc1g4-v1.orig/sound/isa/ad1848/ad1848_lib.c
+++ linux-2624-rc1g4-v1/sound/isa/ad1848/ad1848_lib.c
@@ -213,7 +213,7 @@ static void snd_ad1848_mce_down(struct s
 	for (timeout = 12000; timeout > 0 && (inb(AD1848P(chip, REGSEL)) & AD1848_INIT); timeout--)
 		udelay(100);
 
-	snd_printdd("(1) timeout = %d\n", timeout);
+	snd_printdd("(1) timeout = %lu\n", timeout);
 
 #ifdef CONFIG_SND_DEBUG
 	if (inb(AD1848P(chip, REGSEL)) & AD1848_INIT)
