Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbYFEUUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbYFEUUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYFEUUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:20:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53009 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYFEUT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type:sender;
        b=jbxZ8dYIIK+spD2s0jkxW4dHlRhfmoHf3WqnYzCtp/CpJX8bMGvtgRZbiuQNdKdWQl
         n1gmIDpJqxaORhyumdFjihlgQwLVF3foXPzVyM1GKePPKF2dDm8Xc5/pHlIz4bbsj61M
         IGkUuKgIjiSb9PXCWWFbc9TDxRjmmniNw+9MA=
Date: Thu, 5 Jun 2008 22:19:53 +0200 (CEST)
From: Marcin Obara <marcin_obara@users.sourceforge.net>
X-X-Sender: marcin_obara@ip-195-3-221-75.vnet.pl
To: tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpm@selhorst.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tpm:correct tpm timeouts to jiffies conversion
Message-ID: <alpine.DEB.0.99.0806052204440.8295@ip-195-3-221-75.vnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes timeouts conversion to jiffies,
by replacing msecs_to_jiffies() calls with usecs_to_jiffies().
According to TCG TPM Specification Version 1.2 Revision 103 (pages 166, 167)
TPM timeouts and durations are returned in microseconds (usec)
not in miliseconds (msec).

Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>

--- linux/drivers/char/tpm/tpm.c	2008-06-05 20:57:06.000000000 +0200
+++ linux_tpm/drivers/char/tpm/tpm.c	2008-06-05 20:54:52.000000000 +0200
@@ -524,19 +524,19 @@ void tpm_get_timeouts(struct tpm_chip *c
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX)));
 	if (timeout)
-		chip->vendor.timeout_a = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_a = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_2_IDX)));
 	if (timeout)
-		chip->vendor.timeout_b = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_b = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_3_IDX)));
 	if (timeout)
-		chip->vendor.timeout_c = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_c = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_4_IDX)));
 	if (timeout)
-		chip->vendor.timeout_d = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_d = usecs_to_jiffies(timeout);
 
 duration:
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
@@ -553,15 +553,15 @@ duration:
 		return;
 
 	chip->vendor.duration[TPM_SHORT] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_1_IDX))));
 	chip->vendor.duration[TPM_MEDIUM] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_2_IDX))));
 	chip->vendor.duration[TPM_LONG] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_3_IDX))));
 }
