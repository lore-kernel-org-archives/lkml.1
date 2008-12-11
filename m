Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbYLKT05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbYLKT05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbYLKTSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:30 -0500
Received: from kroah.org ([198.145.64.141]:56028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756851AbYLKTSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:21 -0500
Date: Thu, 11 Dec 2008 11:14:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: [patch 25/83] edac: fix enabling of polling cell module
Message-ID: <20081211191426.GY5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="edac-fix-enabling-of-polling-cell-module.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 992b692dcf43612be805465ca4b76f434c715023 upstream.

The edac driver on cell turned out to be not enabled because of a missing
op_state.  This patch introduces it.  Verified to work on top of Ben's
next branch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Osterkamp <jens@linux.vnet.ibm.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/cell_edac.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -9,6 +9,7 @@
  */
 #undef DEBUG
 
+#include <linux/edac.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -164,6 +165,8 @@ static int __devinit cell_edac_probe(str
 	if (regs == NULL)
 		return -ENODEV;
 
+	edac_op_state = EDAC_OPSTATE_POLL;
+
 	/* Get channel population */
 	reg = in_be64(&regs->mic_mnt_cfg);
 	dev_dbg(&pdev->dev, "MIC_MNT_CFG = 0x%016lx\n", reg);

