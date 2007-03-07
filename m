Return-Path: <linux-kernel-owner+w=401wt.eu-S1751108AbXCGXu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbXCGXu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXCGXu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:50:58 -0500
Received: from mta9.adelphia.net ([68.168.78.199]:58312 "EHLO
	mta9.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbXCGXu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:50:56 -0500
Message-ID: <45EF502C.9090207@walsh.ws>
Date: Wed, 07 Mar 2007 18:52:12 -0500
From: Brian Walsh <brian@walsh.ws>
User-Agent: Thunderbird 1.5.0.9 (X11/20070127)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] include/asm-arm/arch-ixp4xx:  Consolidate check_signature
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The check_signature function is now in linux/include/io.h.  This platform
was missed in the previous consolidation.

Signed-off-by:  Brian Walsh <brian@walsh.ws>


diff -ur a/include/asm-arm/arch-ixp4xx/io.h b/include/asm-arm/arch-ixp4xx/io.h
--- a/include/asm-arm/arch-ixp4xx/io.h	2007-03-07 14:59:47.000000000 -0500
+++ b/include/asm-arm/arch-ixp4xx/io.h	2007-03-07 14:58:54.000000000 -0500
@@ -238,23 +238,6 @@
 #define memcpy_fromio(a,c,l)		_memcpy_fromio((a),(c),(l))
 #define memcpy_toio(c,a,l)		_memcpy_toio((c),(a),(l))

-static inline int
-check_signature(const unsigned char __iomem *bus_addr, const unsigned char
*signature,
-		int length)
-{
-	int retval = 0;
-	do {
-		if (readb(bus_addr) != *signature)
-			goto out;
-		bus_addr++;
-		signature++;
-		length--;
-	} while (length);
-	retval = 1;
-out:
-	return retval;
-}
-
 #endif

 #ifndef CONFIG_PCI
