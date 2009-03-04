Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZCDN4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZCDN4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZCDNz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:55:57 -0500
Received: from mx1.emlix.com ([193.175.82.87]:57890 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZCDNz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:55:57 -0500
Date: Wed, 4 Mar 2009 14:56:18 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] xtensa: enforce slab alignment to maximum register width
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Message-Id: <E1LerZg-0000Rp-AX@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskar Schirmer <os@emlix.com>

XCHAL_DATA_WIDTH is the maximum register width, slab caches should be
aligned to this.

Theoretical fix as all variants have had an XCHAL_DATA_WIDTH of 4
(wordsize) for now.  But the S6000 variant will raise this to 16.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/include/asm/processor.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -25,6 +25,8 @@
 # error Linux requires the Xtensa Windowed Registers Option.
 #endif
 
+#define ARCH_SLAB_MINALIGN	XCHAL_DATA_WIDTH
+
 /*
  * User space process size: 1 GB.
  * Windowed call ABI requires caller and callee to be located within the same
