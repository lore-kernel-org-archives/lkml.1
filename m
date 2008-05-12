Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbYELTF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbYELTF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYELTFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:05:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:42516 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbYELTFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d4Wub30+rk6BDlkrpQEgWp6lGZQH0HbtVlxpTKywal+TQkYkriK9b6M47yXt2wbWN8wm+fUamp+/YgWRIZjGKZoB/U7SzSCETpkwiOesyIbreV/DQ9mgLwrujonLrAinWM8cBqO7VCmDd6GfLic7akdwoS+2Ibdz5Gbj+s7iAFI=
Subject: [PATCH 03/12] ide: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 12:05:36 -0700
Message-Id: <1210619136.24092.54.camel@brick>
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
1.5.5.1.404.g981f6


