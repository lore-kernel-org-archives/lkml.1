Return-Path: <linux-kernel-owner+w=401wt.eu-S936748AbYEBTFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936748AbYEBTFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbYEBTBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:01:55 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:57459 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054AbYEBTBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hEko34iVTmlgmcozmYI2Dwzw9OR+ujUAHDwyO8/vqmkHgntMRTGSrLy+a99AV0MbdJCr79g0PkT1tJy5iyL30Pn+y4djfrOyYtlwLzGZs73sUuLdyrrnuRlhIrJ1MaDZQ0Rjp/jSfN9GzAtq/iMj26EItUAkYTBaXx5BenUViAY=
Subject: [PATCH 10/12] ide: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:01:55 -0700
Message-Id: <1209754915.26173.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ide/ide.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index c758dcb..916a3e6 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -789,7 +789,6 @@ static int __init stridx (const char *s, char c)
 static int __init match_parm (char *s, const char *keywords[], int vals[], int max_vals)
 {
 	static const char *decimal = "0123456789";
-	static const char *hex = "0123456789abcdef";
 	int i, n;
 
 	if (*s++ == '=') {
@@ -814,7 +813,7 @@ static int __init match_parm (char *s, const char *keywords[], int vals[], int m
 			while ((i = stridx(decimal, *++s)) >= 0)
 				vals[n] = (vals[n] * 10) + i;
 			if (*s == 'x' && !vals[n]) {
-				while ((i = stridx(hex, *++s)) >= 0)
+				while ((i = stridx(hex_asc, *++s)) >= 0)
 					vals[n] = (vals[n] * 0x10) + i;
 			}
 			if (++n == max_vals)
-- 
1.5.5.1.350.gbbbf


