Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbXJWOtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbXJWOtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXJWOtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:49:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXJWOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:49:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH][SG] fix typo in ps3rom.c
Date: Tue, 23 Oct 2007 16:48:58 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710231648.59438.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/mxJuCtIcdkf2Y1TXmLkmpmYg5pdLBxvrdBWj
 PYqInJYMUiSdhqR1plfHpXtRWZZ5PFEkiTbEjwSIn9sqRLEzzi
 1InaMKTyNBLMFiGI2EmrQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This was accidentally introduced by yesterday's change to the SG handling.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

On Monday 22 October 2007, Jens Axboe wrote:
> 
> I split the patch up into a few pieces, so it can be applied safely.
> It builds with allyesconfig on i386 and x86-64, and it's been booted
> and tested on both those archs and ppc64 as well.

Not sure if this has been reported already, but I needed the trivial fix
to build the ps3rom driver.

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 03f19b8..17b4a7c 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -147,7 +147,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *cmd, void *buf)
 
 	req_len = fin = 0;
 	scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
-		kaddr = kmap_atomic(sg_page(sgpnt->page), KM_IRQ0);
+		kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);
 		len = sgpnt->length;
 		if ((req_len + len) > buflen) {
 			len = buflen - req_len;
