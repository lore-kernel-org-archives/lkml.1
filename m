Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXD2LBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXD2LBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbXD2LBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:32 -0400
Received: from mail.suse.de ([195.135.220.2]:52046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbXD2Kw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:59 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: "Ken Chen" <kenchen@google.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [10/48] i386: type cast clean up for find_next_zero_bit
Message-Id: <20070429105258.4565E151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Ken Chen" <kenchen@google.com>

clean up unneeded type cast by properly declare data type.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/lib/bitops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/lib/bitops.c
===================================================================
--- linux.orig/arch/i386/lib/bitops.c
+++ linux/arch/i386/lib/bitops.c
@@ -43,7 +43,7 @@ EXPORT_SYMBOL(find_next_bit);
  */
 int find_next_zero_bit(const unsigned long *addr, int size, int offset)
 {
-	unsigned long * p = ((unsigned long *) addr) + (offset >> 5);
+	const unsigned long *p = addr + (offset >> 5);
 	int set = 0, bit = offset & 31, res;
 
 	if (bit) {
@@ -64,7 +64,7 @@ int find_next_zero_bit(const unsigned lo
 	/*
 	 * No zero yet, search remaining full bytes for a zero
 	 */
-	res = find_first_zero_bit (p, size - 32 * (p - (unsigned long *) addr));
+	res = find_first_zero_bit(p, size - 32 * (p - addr));
 	return (offset + set + res);
 }
 EXPORT_SYMBOL(find_next_zero_bit);
