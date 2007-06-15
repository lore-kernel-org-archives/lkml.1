Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXFOQ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXFOQ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXFOQ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:56:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:56849 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbXFOQ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GeRzIO6reHMy6SOu/H0RS7HUbx5XtztvCWdetk4YwPsJjAEpljldhSVYHQM447dwC7gx7QyAsy2E1vIHMH/ewawKI6wmklMQASjlB1d2LTVJA+j7L7XhxEZaIsyET3lm3aUaynyjY7IcDotk9216meIxJx34DVmO9IJyRvlw+uk=
Subject: [PATCH] Optimize is_power_of_2().
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 15 Jun 2007 18:56:42 +0200
Message-Id: <1181926602.25193.5.camel@grianne>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard@peltkore.net>
Date: Fri, 15 Jun 2007 18:35:49 +0200
Subject: [PATCH] Optimize is_power_of_2().

Rationale: Removes one conditional branch and reduces icache footprint.
Proof: If n is false, the product of n and any value is false. If n is
true, the truth of (n * x) is the truth of x.

Signed-off-by: Vegard Nossum <vegard@peltkore.net>
---
 include/linux/log2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 1b8a2c1..56196b1 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -51,7 +51,7 @@ int __ilog2_u64(u64 n)
 static inline __attribute__((const))
 bool is_power_of_2(unsigned long n)
 {
-	return (n != 0 && ((n & (n - 1)) == 0));
+	return n * !(n & (n - 1));
 }
 
 /*
-- 
1.5.0.6

