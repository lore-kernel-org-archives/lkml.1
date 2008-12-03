Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYLCXtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYLCXtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYLCXt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:49:27 -0500
Received: from ozlabs.org ([203.10.76.45]:53942 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbYLCXt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:49:26 -0500
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 4 Dec 2008 10:19:21 +1030
Subject: [PATCH 1/1] avr32: define __fls
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812041019.21926.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like fls, but can't be handed 0 and returns the bit number.

(I added find_last_bit() to bitmap.h which broke archs which didn't
 define this)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/avr32/include/asm/bitops.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -263,6 +263,11 @@ static inline int fls(unsigned long word
 	return 32 - result;
 }
 
+static inline int __fls(unsigned long word)
+{
+	return fls(word) - 1;
+}
+
 unsigned long find_first_zero_bit(const unsigned long *addr,
 				  unsigned long size);
 unsigned long find_next_zero_bit(const unsigned long *addr,


