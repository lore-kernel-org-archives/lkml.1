Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYGVAbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYGVAbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbYGVA3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:29:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbYGVA3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JSf1thw55tFP6C6wmF6UmsgVFV9hEsldoDkSoxgF2AzeGyeE8mTtnuI/vHio2JdTBU
         iCvEvlu+I5E1ze/lc9yxGuxDt6bt/pDo14x5njwelWMPCnGt1No8aGIpwqJdYvi2lzc5
         gGWM0Fvi5P8hKCRAXmBsgpjzf9bagGs6An4Js=
Message-ID: <488529FA.2070705@gmail.com>
Date: Mon, 21 Jul 2008 20:29:46 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: mchehab@infradead.org, video4linux-list@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] mt20xx: test below 0 on unsigned lo1a and lo2a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lo1a and lo2a are unsigned ints so these tests won't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/common/tuners/mt20xx.c b/drivers/media/common/tuners/mt20xx.c
index fbcb282..35b763a 100644
--- a/drivers/media/common/tuners/mt20xx.c
+++ b/drivers/media/common/tuners/mt20xx.c
@@ -148,7 +148,8 @@ static int mt2032_compute_freq(struct dvb_frontend *fe,
 	tuner_dbg("mt2032: rfin=%d lo2=%d lo2n=%d lo2a=%d num=%d lo2freq=%d\n",
 		  rfin,lo2,lo2n,lo2a,lo2num,lo2freq);
 
-	if(lo1a<0 || lo1a>7 || lo1n<17 ||lo1n>48 || lo2a<0 ||lo2a >7 ||lo2n<17 || lo2n>30) {
+	if (lo1a > 7 || lo1n < 17 || lo1n > 48 || lo2a > 7 || lo2n < 17 ||
+			lo2n > 30) {
 		tuner_info("mt2032: frequency parameters out of range: %d %d %d %d\n",
 			   lo1a, lo1n, lo2a,lo2n);
 		return(-1);
