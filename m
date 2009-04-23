Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZDWRol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZDWRol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZDWRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:44:32 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:36419 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZDWRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:44:31 -0400
Date: Thu, 23 Apr 2009 13:43:34 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Introduce a boolean "single_bit_set" function.
Message-ID: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A boolean single_bit_set() routine would simplify the numerous
constructs of the form (((n & (n - 1)) == 0)) when testing for
single-bitness.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

This is similar to the current is_power_of_2() routine defined in
include/linux/log2.h, which is mathematically identical but,
semantically, should be defined independently just so the code is more
readable.

I'm open to an alternative function name.

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 6182913..1c0c840 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -45,6 +45,13 @@ static inline unsigned long hweight_long(unsigned long w)
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }

+static inline __attribute__((const))
+bool single_bit_set(unsigned long n)
+{
+        return (n != 0 && ((n & (n - 1)) == 0));
+}
+
+
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
