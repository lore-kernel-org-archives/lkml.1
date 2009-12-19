Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZLSOTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZLSOTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 09:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZLSOTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 09:19:30 -0500
Received: from sr-smtp.usish.com ([210.5.144.203]:51887 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZLSOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 09:19:29 -0500
X-Greylist: delayed 747 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Dec 2009 09:19:28 EST
Date: Sat, 19 Dec 2009 22:08:03 +0800
From: "jack_wang" <jack_wang@usish.com>
To: "Julia Lawall" <julia@diku.dk>, "lindar_liu" <lindar_liu@usish.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "linux-scsi" <linux-scsi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "kernel-janitors" <kernel-janitors@vger.kernel.org>
References: <Pine.LNX.4.64.0912190817110.30546@ask.diku.dk>
Subject: Re: [PATCH 5/7] drivers/scsi/pm8001: Use kzalloc for allocating onlyone thing
Message-ID: <200912192208027036843@usish.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nBJEKS16001080

RE£º[PATCH 5/7] drivers/scsi/pm8001: Use kzalloc for allocating onlyone thing

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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
