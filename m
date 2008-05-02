Return-Path: <linux-kernel-owner+w=401wt.eu-S965185AbYEBTFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185AbYEBTFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965121AbYEBTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:01:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30418 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965098AbYEBTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oSHoIiaedmt4Nx0cY80I/a2rhcdb2m/rY/deID5xHUHNo/1bTOzwIetXlbZkdgjRKSccoa3EjLqNFRqzMt5vLX2gcFOCOVmQzJb2K8Rn55xb5QHyYgDFr0pbham87ZdGufgujMEyiBeqdb3U9Oh3NyJ/kn0QRGWFA1tvHtg+BAM=
Subject: [PATCH 11/12] isdn: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:01:56 -0700
Message-Id: <1209754916.26173.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/isdn/gigaset/isocdata.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/gigaset/isocdata.c b/drivers/isdn/gigaset/isocdata.c
index e30a777..fbce522 100644
--- a/drivers/isdn/gigaset/isocdata.c
+++ b/drivers/isdn/gigaset/isocdata.c
@@ -247,7 +247,6 @@ static inline void dump_bytes(enum debuglevel level, const char *tag,
 #ifdef CONFIG_GIGASET_DEBUG
 	unsigned char c;
 	static char dbgline[3 * 32 + 1];
-	static const char hexdigit[] = "0123456789abcdef";
 	int i = 0;
 	while (count-- > 0) {
 		if (i > sizeof(dbgline) - 4) {
@@ -258,8 +257,8 @@ static inline void dump_bytes(enum debuglevel level, const char *tag,
 		c = *bytes++;
 		dbgline[i] = (i && !(i % 12)) ? '-' : ' ';
 		i++;
-		dbgline[i++] = hexdigit[(c >> 4) & 0x0f];
-		dbgline[i++] = hexdigit[c & 0x0f];
+		dbgline[i++] = hex_asc_hi(c);
+		dbgline[i++] = hex_asc_lo(c);
 	}
 	dbgline[i] = '\0';
 	gig_dbg(level, "%s:%s", tag, dbgline);
-- 
1.5.5.1.350.gbbbf


