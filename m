Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYJXXpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYJXXpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYJXXpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:45:02 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:22411 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYJXXpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ikTsezBK9m2D2vi3ybiRpbWr2Agn+aWwh+OFJvd+8d6Gh6J3rNr/+l31yGL8+tVc0x
         pccP1cHRGG3mXgZG33SdKFnJ36niUoyRU9FytLGwzaoxs+qB/M8srfPxp8+Ubx1EpqLM
         kEQW9kaeevVQL/zb95dzt8jBBAhy3miUtjvgg=
Subject: [PATCH] ibmpex: trivial endian annotation in extract_data helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 16:44:58 -0700
Message-Id: <1224891898.5784.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper is used in few enough locations that open-coding it
at the call sites may be better than the helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/hwmon/ibmpex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 537d9fb..a363633 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -40,7 +40,7 @@
 
 static inline u16 extract_value(const char *data, int offset)
 {
-	return be16_to_cpup((u16 *)&data[offset]);
+	return be16_to_cpup((__be16 *)&data[offset]);
 }
 
 #define TEMP_SENSOR		1
-- 
1.6.0.3.729.g6ea410



