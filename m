Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYEBFUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYEBFUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYEBFTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:19:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:32305 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbYEBFTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ym3aclfg2qQoZpypzkjKyfwGTMIbgIIh/ABgWiJMSl9qp9GzoMre+NVa8E6Ku3RKYRiOIxxQyms3fhQb9K9zMA1h7zLBubCEMWdqI1e4/czScC+Bj7kWEutEtr3oaFFfzfLZI1YOG44YbJcIhDLAj5GaM6DoL3yZCUFVSq0UF1s=
Subject: [PATCH 1/6] hid: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 22:19:32 -0700
Message-Id: <1209705572.22362.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/hid/hid-core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f43d6d3..426ac5a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -780,7 +780,7 @@ static __inline__ __u32 extract(__u8 *report, unsigned offset, unsigned n)
  */
 static __inline__ void implement(__u8 *report, unsigned offset, unsigned n, __u32 value)
 {
-	__le64 x;
+	u64 x;
 	u64 m = (1ULL << n) - 1;
 
 	if (n > 32)
@@ -796,10 +796,10 @@ static __inline__ void implement(__u8 *report, unsigned offset, unsigned n, __u3
 	report += offset >> 3;
 	offset &= 7;
 
-	x = get_unaligned((__le64 *)report);
-	x &= cpu_to_le64(~(m << offset));
-	x |= cpu_to_le64(((u64) value) << offset);
-	put_unaligned(x, (__le64 *) report);
+	x = get_unaligned_le64(report);
+	x &= ~(m << offset);
+	x |= ((u64)value) << offset;
+	put_unaligned_le64(x, report);
 }
 
 /*
-- 
1.5.5.1.350.gbbbf


