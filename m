Return-Path: <linux-kernel-owner+w=401wt.eu-S1764556AbZGAAzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764556AbZGAAzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761424AbZGAAei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:38 -0400
Received: from kroah.org ([198.145.64.141]:60248 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761423AbZGAAeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:23 2009
Message-Id: <20090701002422.816483097@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Krufky <mkrufky@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 032/108] DVB: lgdt3305: fix 64bit division in function lgdt3305_set_if
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=dvb-lgdt3305-fix-64bit-division-in-function-lgdt3305_set_if.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Krufky <mkrufky@kernellabs.com>

(cherry picked from commit 511da457340d3b30336f7a6731bad9bbe3ffaf08)

Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/lgdt3305.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/drivers/media/dvb/frontends/lgdt3305.c
+++ b/drivers/media/dvb/frontends/lgdt3305.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <asm/div64.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_math.h"
 #include "lgdt3305.h"
@@ -496,27 +497,15 @@ static int lgdt3305_set_if(struct lgdt33
 
 	nco = if_freq_khz / 10;
 
-#define LGDT3305_64BIT_DIVISION_ENABLED 0
-	/* FIXME: 64bit division disabled to avoid linking error:
-	 * WARNING: "__udivdi3" [lgdt3305.ko] undefined!
-	 */
 	switch (param->u.vsb.modulation) {
 	case VSB_8:
-#if LGDT3305_64BIT_DIVISION_ENABLED
 		nco <<= 24;
-		nco /= 625;
-#else
-		nco *= ((1 << 24) / 625);
-#endif
+		do_div(nco, 625);
 		break;
 	case QAM_64:
 	case QAM_256:
-#if LGDT3305_64BIT_DIVISION_ENABLED
 		nco <<= 28;
-		nco /= 625;
-#else
-		nco *= ((1 << 28) / 625);
-#endif
+		do_div(nco, 625);
 		break;
 	default:
 		return -EINVAL;


