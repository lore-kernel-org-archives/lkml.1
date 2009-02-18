Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbZBRWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbZBRWgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZBRWb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:31:57 -0500
Received: from kroah.org ([198.145.64.141]:34747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757825AbZBRWb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:56 -0500
Date: Wed, 18 Feb 2009 14:29:05 -0800
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 05/36] sata_nv: give up hardreset on nf2
Message-ID: <20090218222905.GF10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_nv-give-up-hardreset-on-nf2.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 7dac745b8e367c99175b8f0d014d996f0e5ed9e5 upstream.

Kernel bz#12176 reports that nf2 hardreset simply doesn't work.  Give
up.  Argh...

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Reported-by: Saro <saro_v@hotmail.it>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_nv.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -421,19 +421,21 @@ static struct ata_port_operations nv_gen
 	.hardreset		= ATA_OP_NULL,
 };
 
-/* OSDL bz3352 reports that nf2/3 controllers can't determine device
- * signature reliably.  Also, the following thread reports detection
- * failure on cold boot with the standard debouncing timing.
+/* nf2 is ripe with hardreset related problems.
+ *
+ * kernel bz#3352 reports nf2/3 controllers can't determine device
+ * signature reliably.  The following thread reports detection failure
+ * on cold boot with the standard debouncing timing.
  *
  * http://thread.gmane.org/gmane.linux.ide/34098
  *
- * Debounce with hotplug timing and request follow-up SRST.
+ * And bz#12176 reports that hardreset simply doesn't work on nf2.
+ * Give up on it and just don't do hardreset.
  */
 static struct ata_port_operations nv_nf2_ops = {
-	.inherits		= &nv_common_ops,
+	.inherits		= &nv_generic_ops,
 	.freeze			= nv_nf2_freeze,
 	.thaw			= nv_nf2_thaw,
-	.hardreset		= nv_noclassify_hardreset,
 };
 
 /* For initial probing after boot and hot plugging, hardreset mostly

