Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZLSHRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZLSHRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZLSHRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:17:32 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:49335 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZLSHR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:17:29 -0500
Date: Sat, 19 Dec 2009 08:17:27 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jack_wang@usish.com, lindar_liu@usish.com,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/7] drivers/scsi/pm8001: Use kzalloc for allocating only
 one thing
Message-ID: <Pine.LNX.4.64.0912190817110.30546@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/pm8001/pm8001_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
--- a/drivers/scsi/pm8001/pm8001_init.c 2009-12-12 00:23:19.000000000 +0100
+++ b/drivers/scsi/pm8001/pm8001_init.c 2009-12-19 07:52:44.000000000 +0100
@@ -654,7 +654,7 @@ static int __devinit pm8001_pci_probe(st
 	}
 	chip = &pm8001_chips[ent->driver_data];
 	SHOST_TO_SAS_HA(shost) =
-		kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);
+		kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
 	if (!SHOST_TO_SAS_HA(shost)) {
 		rc = -ENOMEM;
 		goto err_out_free_host;
