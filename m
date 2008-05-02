Return-Path: <linux-kernel-owner+w=401wt.eu-S966129AbYEBTKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129AbYEBTKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965216AbYEBTFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:38960 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209AbYEBTFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i0jfMPgMNrKL+BklZ+qw+2uAGxA/rhUPh7Vko6YlTZIFd1maQZBFjOR573ZMOGM3P2X4+lEaHdSTqslKmseVGHy87hOXzO9V2eJah6wfVey8qBQ0b5n5ybK299awtXLvjrCfIa9FzVss+BJioJTLyPUrfv9njl2tBV3eqwcZfHw=
Subject: [PATCH 09/14] hid: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:57 -0700
Message-Id: <1209755157.26173.75.camel@brick>
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


