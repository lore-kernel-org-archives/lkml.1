Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbYEAXFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbYEAXFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763270AbYEAXFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:05:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:8094 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762924AbYEAXFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RS5GXHg8Qwnh7NKj9EO8Ek3lz3+07ZSa9+aNR4DSfFqO4nWxm8F4y73hZnXG+7btbIFmN3e/kxTfKT7dpbYDZ6eowuzl4qYmrLzlobwcP5oZpW6lvD1mf/UUpx5X8DNtXRUWEEfDTheSoA1s3dU2V86ln3ROfac1o6s8Dd+mY3I=
Subject: [PATCH 2/9] scsi: use the common hex_asc array rather than a
	private one
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 16:05:35 -0700
Message-Id: <1209683135.24729.204.camel@brick>
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
1.5.5.1.305.g7c84


