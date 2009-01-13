Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbZAMBeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbZAMBeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbZAMB3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:09 -0500
Received: from kroah.org ([198.145.64.141]:36036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758157AbZAMB3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:06 -0500
Date: Mon, 12 Jan 2009 17:27:16 -0800
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
       alan@lxorguk.ukuu.org.uk, Gernot Hillier <gernot.hillier@siemens.com>,
       Tomas Henzl <thenzl@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       AACRAID list <aacraid@adaptec.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 13/21] SCSI: aacraid: disable Dell Percraid quirk on
	Adaptec 2200S and 2120S
Message-ID: <20090113012716.GN4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hillier, Gernot <gernot.hillier@siemens.com>

commit b21227c5fcadab206e2a2373e5b288a351919abb upstream.

A lot of 64bit machines with Adaptec 2200S and 2120S controllers don't
recognize SCSI disks any more with the patch

commit 94cf6ba11b068b8a8f68a1e88bffb6827e92124b
Author: Salyzyn, Mark <mark_salyzyn@adaptec.com>
Date:   Thu Dec 13 16:14:18 2007 -0800

    [SCSI] aacraid: fix driver failure with Dell PowerEdge Expandable RAID Controller 3/Di

but fail with tons of "aac_srb: aac_fib_send failed with status: 8195"
instead. This patch disables the quirk introduced in the change cited
above for those two controllers again.

[thenzl: added 2120S Controller]
Signed-off-by: Gernot Hillier <gernot.hillier@siemens.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Cc: AACRAID list <aacraid@adaptec.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/aacraid/linit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -175,8 +175,8 @@ static struct aac_driver_ident aac_drive
 	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Boxster/PERC3DiB) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* catapult */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* tomcat */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2120S (Crusader) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2120S (Crusader) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2200S (Vulcan) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan-2m) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S220 (Legend Crusader) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S230 (Legend Vulcan) */

