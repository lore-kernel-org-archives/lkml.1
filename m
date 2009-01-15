Return-Path: <linux-kernel-owner+w=401wt.eu-S934278AbZAOUws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbZAOUws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762842AbZAOUC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:56 -0500
Received: from kroah.org ([198.145.64.141]:49801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932343AbZAOUCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:54 -0500
Date: Thu, 15 Jan 2009 12:00:31 -0800
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
       alan@lxorguk.ukuu.org.uk, Reinhard Nissl <rnissl@gmx.de>,
       Ke Wei <kewei@marvell.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 85/94] [SCSI] mvsas: increase port type detection delay to
	suit Seagates 10k6 drive ST3450856SS 0003
Message-ID: <20090115200031.GG14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mvsas-increase-port-type-detection-delay-to-suit-seagate-s-10k6-drive-st3450856ss-0003.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Reinhard Nissl <rnissl@gmx.de>

commit ddccf307a3599e452804e228d8ed30fba578923e upstream.

I increased the delay step by step until loading of mvsas
reliably detected the drive 200 times in sequence. A much better
approach would be to monitor the hardware for some flag which
indicates that port detection has finished, but I do not have any
hardware documentation.

Signed-off-by: Reinhard Nissl <rnissl@gmx.de>
Cc: Ke Wei <kewei@marvell.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mvsas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2959,7 +2959,7 @@ static int __devinit mvs_hw_init(struct 
 
 	/* enable auto port detection */
 	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
-	msleep(100);
+	msleep(1100);
 	/* init and reset phys */
 	for (i = 0; i < mvi->chip->n_phy; i++) {
 		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);

