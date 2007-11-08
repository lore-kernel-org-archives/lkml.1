Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbXKHQJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbXKHQJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbXKHQJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:09:04 -0500
Received: from ryu.zarb.org ([212.85.153.228]:58385 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531AbXKHQJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:09:03 -0500
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2007 11:09:03 EST
Subject: [PATCH] cm40x0_cs.c: fix debug macros
From: Pascal Terjan <pterjan@mandriva.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Mandriva
Date: Thu, 08 Nov 2007 16:59:44 +0100
Message-Id: <1194537585.4870.35.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.1-1mdv2008.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When PCMCIA_DEBUG is set, cm40x0_cs.c and cm4000_cs.c don't build because
the definition of reader_to_dev uses a non-existent handle field of the
struct pcmcia_device in the call to handle_to_dev.
As handle_to_dev works on struct pcmcia_device, the fix is quite trivial.

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
---
 drivers/char/pcmcia/cm4000_cs.c |    2 +-
 drivers/char/pcmcia/cm4040_cs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index cc5d777..02518da 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -47,7 +47,7 @@
 /* #define ATR_CSUM */
 
 #ifdef PCMCIA_DEBUG
-#define reader_to_dev(x)	(&handle_to_dev(x->p_dev->handle))
+#define reader_to_dev(x)	(&handle_to_dev(x->p_dev))
 static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0600);
 #define DEBUGP(n, rdr, x, args...) do { 				\
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index a0b9c87..5f291bf 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -41,7 +41,7 @@
 

 #ifdef PCMCIA_DEBUG
-#define reader_to_dev(x)	(&handle_to_dev(x->p_dev->handle))
+#define reader_to_dev(x)	(&handle_to_dev(x->p_dev))
 static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0600);
 #define DEBUGP(n, rdr, x, args...) do { 				\
-- 
1.5.3.5

