Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0AOSJj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908Ab0AOSJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:09:37 -0500
Received: from [206.15.93.42] ([206.15.93.42]:21672 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757641Ab0AOSJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:09:37 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] cfi.h: quiet sparse noise
Date: Fri, 15 Jan 2010 11:09:32 -0700
Cc: dwmw2@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001151109.32890.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfi.h: quiet sparse noise

In the inline function cfi_build_cmd_addr, the cast of cmd_ofs to an
uint8_t produces a sparse warning of the type:

warning: cast truncates bits from constant value (2aa becomes aa)

Quiet the warning by masking cmd_ofs with 0xff and remove the cast.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index df89f42..a4eefc5 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -297,7 +297,7 @@ static inline uint32_t cfi_build_cmd_addr(uint32_t cmd_ofs,
 	 * and 32bit devices on 16 bit busses
 	 * set the low bit of the alternating bit sequence of the address.
 	 */
-	if (((type * interleave) > bankwidth) && ((uint8_t)cmd_ofs == 0xaa))
+	if (((type * interleave) > bankwidth) && ((cmd_ofs & 0xff) == 0xaa))
 		addr |= (type >> 1)*interleave;
 
 	return  addr;
