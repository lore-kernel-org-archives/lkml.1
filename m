Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZLSOTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZLSOTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 09:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZLSOTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 09:19:34 -0500
Received: from sr-smtp.usish.com ([210.5.144.203]:51888 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZLSOTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 09:19:33 -0500
Date: Sat, 19 Dec 2009 22:08:11 +0800
From: "jack_wang" <jack_wang@usish.com>
To: "Julia Lawall" <julia@diku.dk>, "lindar_liu" <lindar_liu@usish.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "linux-scsi" <linux-scsi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "kernel-janitors" <kernel-janitors@vger.kernel.org>
References: <Pine.LNX.4.64.0912190817110.30546@ask.diku.dk>
Subject: Re: [PATCH 5/7] drivers/scsi/pm8001: Use kzalloc for allocating onlyone thing
Message-ID: <200912192208103123212@usish.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RE:[PATCH 5/7] drivers/scsi/pm8001: Use kzalloc for allocating onlyone thing

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


[Jack]Acked-by:Jack Wang <jack_wang@usish.com>
Thanks, Julia

