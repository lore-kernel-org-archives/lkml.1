Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYK2Ltf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYK2Ltf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 06:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYK2Lt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 06:49:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:48605 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYK2Lt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 06:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=K/AbR5lAJMEyww6ZCje0oudcvXiVbhYzbUAaJ43fTA0m3b6ywku9w/5JWQp0NP83ZU
         Ik/AXc58ssez4xM5rMbOgkzOxYylKRXpFaWXHyDPs7XhpPPipxAqeh6s9Q6BY00Dg5Js
         1BLTGMCpfQV6HL8v337WzbFxpDBfBkRFOE8Fs=
Message-ID: <49312C40.3080909@gmail.com>
Date: Sat, 29 Nov 2008 06:49:20 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: ben-linux@fluff.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] sm501: unsigned ptr cannot be negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned ptr cannot be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index f94ae84..dcd9879 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -159,6 +159,9 @@ static int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
 		break;
 
 	case SM501_MEMF_PANEL:
+		if (size > inf->fbmem_len)
+			return -ENOMEM;
+
 		ptr = inf->fbmem_len - size;
 		fbi = inf->fb[HEAD_CRT];
 
@@ -172,9 +175,6 @@ static int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
 		if (fbi && ptr < fbi->fix.smem_len)
 			return -ENOMEM;
 
-		if (ptr < 0)
-			return -ENOMEM;
-
 		break;
 
 	case SM501_MEMF_CRT:

