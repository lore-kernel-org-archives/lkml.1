Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0CJAIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:08:40 -0500
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:56821 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab0CJAIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:08:37 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 19:08:37 EST
X-MXL-Hash: 4b96e3052ec54fc3-f9fe04f9b3a51d9cd5ce0bd2f89adf5da8e4696d
X-MXL-Hash: 4b96e1257303b855-af7c8305b1b1bf0a0698e63fbd1e3baba742ea88
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       "zohar@us.ibm.com" <zohar@us.ibm.com>,
       "jmorris@namei.org" <jmorris@namei.org>
Date: Tue, 9 Mar 2010 17:59:59 -0600
Subject: [PATCH] security/ima: replace gcc specific __FUNCTION__ with
 __func__
Thread-Topic: [PATCH] security/ima: replace gcc specific __FUNCTION__ with
 __func__
Thread-Index: Acq/5KAq8g4vxqEMRvmXPVVteUDoKw==
Message-ID: <0D753D10438DA54287A00B027084269763682CE03C@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010030401)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.98]
X-AnalysisOut: [v=1.0 c=1 a=DvTzUY8MHoYA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=i00gxMtYAAAA:8 a=VnN]
X-AnalysisOut: [F1IyMAAAA:8 a=K6HrmWtEAAAA:8 a=3pEPeB9bZirFsIv29vIA:9 a=f9]
X-AnalysisOut: [KwhrZpmw-8RBCz3DEA:7 a=9C2X-6nlg5g5uaKJ9ZNt8Vtz-bUA:4 a=QE]
X-AnalysisOut: [XdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=ux7RaoK8vTIA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2A091mE005939

As noted by checkpatch.pl, __func__ should be used instead of gcc
specific __FUNCTION__.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>

---

diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 2d4d05d..6cc2243 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -79,17 +79,17 @@ void iint_free(struct kref *kref)
 	iint->version = 0;
 	iint->flags = 0UL;
 	if (iint->readcount != 0) {
-		printk(KERN_INFO "%s: readcount: %ld\n", __FUNCTION__,
+		printk(KERN_INFO "%s: readcount: %ld\n", __func__,
 		       iint->readcount);
 		iint->readcount = 0;
 	}
 	if (iint->writecount != 0) {
-		printk(KERN_INFO "%s: writecount: %ld\n", __FUNCTION__,
+		printk(KERN_INFO "%s: writecount: %ld\n", __func__,
 		       iint->writecount);
 		iint->writecount = 0;
 	}
 	if (iint->opencount != 0) {
-		printk(KERN_INFO "%s: opencount: %ld\n", __FUNCTION__,
+		printk(KERN_INFO "%s: opencount: %ld\n", __func__,
 		       iint->opencount);
 		iint->opencount = 0;
 	}
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 294b005..983037f 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -194,7 +194,7 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 	     (iint->writecount < 0)) &&
 	    !ima_limit_imbalance(file)) {
 		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld o:%ld)\n",
-		       __FUNCTION__, iint->readcount, iint->writecount,
+		       __func__, iint->readcount, iint->writecount,
 		       iint->opencount);
 		dump_stack();
 	}
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
