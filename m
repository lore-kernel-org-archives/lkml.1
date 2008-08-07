Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYHGWRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYHGWRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYHGWRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:17:04 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25665 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYHGWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:17:03 -0400
Date: Thu, 7 Aug 2008 15:13:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, steiner@sgi.com
Subject: [PATCH] GRU: fix preprocessor symbol for sparse
Message-Id: <20080807151344.c3808969.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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
cc: steiner@sgi.com

Fix preprocessor symbol so that sparse sees it and does not
generate errors:

linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutlbpurge.c:185:11: error: undefined identifier 'GRUREGION'
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"
linux-next-20080807/drivers/misc/sgi-gru/grutables.h:286:2: error: "Unsupported architecture"

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/misc/sgi-gru/grutables.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080807.orig/drivers/misc/sgi-gru/grutables.h
+++ linux-next-20080807/drivers/misc/sgi-gru/grutables.h
@@ -279,7 +279,7 @@ struct gru_stats_s {
 #if defined CONFIG_IA64
 #define VADDR_HI_BIT		64
 #define GRUREGION(addr)		((addr) >> (VADDR_HI_BIT - 3) & 3)
-#elif defined __x86_64
+#elif defined CONFIG_X86_64
 #define VADDR_HI_BIT		48
 #define GRUREGION(addr)		(0)		/* ZZZ could do better */
 #else


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
