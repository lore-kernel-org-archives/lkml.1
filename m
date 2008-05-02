Return-Path: <linux-kernel-owner+w=401wt.eu-S965091AbYEBTB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965091AbYEBTB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933743AbYEBTBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:01:33 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:48598 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbYEBTBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c2c21/RlrVgC2sOq6HntYbd/xn9oPtkzZUhhJ4FtvpOOg948eFopPaAH9XyEGltJ+Epa2g/Q0kTsb6GODNKfKIp1T2AntNh6NqGibD4CLqAaRVE2H/FAB4kC3p2HWlV59beXFVnWRe43iDYgjcLfgs1pOhKLqBVsj/IMNBo86G4=
Subject: [PATCH 02/12] scsi: use the common hex_asc array rather than a
	private one
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:01:52 -0700
Message-Id: <1209754912.26173.27.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also use the hi/lo helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/ibmmca.c    |    3 +--
 drivers/scsi/ultrastor.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 4d15a62..6765a05 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1002,12 +1002,11 @@ static char *ti_p(int dev)
 /* interpreter for logical device numbers (ldn) */
 static char *ti_l(int val)
 {
-	const char hex[16] = "0123456789abcdef";
 	static char answer[2];
 
 	answer[1] = (char) (0x0);
 	if (val <= MAX_LOG_DEV)
-		answer[0] = hex[val];
+		answer[0] = hex_asc[val];
 	else
 		answer[0] = '-';
 	return (char *) &answer;
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 27aa40f..25828ce 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -876,8 +876,8 @@ static int ultrastor_abort(struct scsi_cmnd *SCpnt)
 	for (i = 0; i < 16; i++)
 	  {
 	    unsigned char p = inb(port0 + i);
-	    out[28 + i * 3] = "0123456789abcdef"[p >> 4];
-	    out[29 + i * 3] = "0123456789abcdef"[p & 15];
+	    out[28 + i * 3] = hex_asc_hi(p);
+	    out[29 + i * 3] = hex_asc_lo(p);
 	    out[30 + i * 3] = ' ';
 	  }
 	out[28 + i * 3] = '\n';
-- 
1.5.5.1.350.gbbbf


