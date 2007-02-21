Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXBUDmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXBUDmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 22:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965076AbXBUDmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 22:42:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:21090 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932AbXBUDmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 22:42:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=MamG/N+SzpevX0dtCVLOok29WXEZ95C/nS5Yw2KUDW/IJXgObxIIGNuQ5Onvnc+w7
	2O4FEKohqBAJrYNj1IJNQ==
Message-ID: <b040c32a0702201942p5cfaa95wc9876d6c350df280@mail.gmail.com>
Date: Tue, 20 Feb 2007 19:42:11 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [patch] trivial type cast clean up for find_next_zero_bit
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clean up unneeded type cast by properly declare data type.

Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/arch/i386/lib/bitops.c b/arch/i386/lib/bitops.c
index 97db385..afd0045 100644
--- a/arch/i386/lib/bitops.c
+++ b/arch/i386/lib/bitops.c
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
