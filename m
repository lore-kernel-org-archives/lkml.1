Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbXKOGQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbXKOGQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbXKOGQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50963 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXKOGQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:04 -0500
Date: Wed, 14 Nov 2007 22:14:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/19] Fix sparc64 niagara optimized RAID xor asm
Message-ID: <20071115061426.GB7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-sparc64-niagara-optimized-raid-xor-asm.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Miller <davem@davemloft.net>

patch d060db63fd38a8a75f666576ef9999c28cdc31cf in mainline.

[SPARC64]: Fix register usage in xor_raid_4().

Some typos led to using %i6/%i7 instead of %l6/%l7 in loads which is
really really bad because those are the frame pointer and return PC.

Based upon a raid5 crash report by Bertrand Joel.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/lib/xor.S |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/sparc64/lib/xor.S
+++ b/arch/sparc64/lib/xor.S
@@ -491,12 +491,12 @@ xor_niagara_4:		/* %o0=bytes, %o1=dest, 
 	ldda		[%i1 + 0x10] %asi, %i2	/* %i2/%i3 = src1 + 0x10 */
 	xor		%g2, %i4, %g2
 	xor		%g3, %i5, %g3
-	ldda		[%i7 + 0x10] %asi, %i4	/* %i4/%i5 = src2 + 0x10 */
+	ldda		[%l7 + 0x10] %asi, %i4	/* %i4/%i5 = src2 + 0x10 */
 	xor		%l0, %g2, %l0
 	xor		%l1, %g3, %l1
 	stxa		%l0, [%i0 + 0x00] %asi
 	stxa		%l1, [%i0 + 0x08] %asi
-	ldda		[%i6 + 0x10] %asi, %g2	/* %g2/%g3 = src3 + 0x10 */
+	ldda		[%l6 + 0x10] %asi, %g2	/* %g2/%g3 = src3 + 0x10 */
 	ldda		[%i0 + 0x10] %asi, %l0	/* %l0/%l1 = dest + 0x10 */
 
 	xor		%i4, %i2, %i4
@@ -504,12 +504,12 @@ xor_niagara_4:		/* %o0=bytes, %o1=dest, 
 	ldda		[%i1 + 0x20] %asi, %i2	/* %i2/%i3 = src1 + 0x20 */
 	xor		%g2, %i4, %g2
 	xor		%g3, %i5, %g3
-	ldda		[%i7 + 0x20] %asi, %i4	/* %i4/%i5 = src2 + 0x20 */
+	ldda		[%l7 + 0x20] %asi, %i4	/* %i4/%i5 = src2 + 0x20 */
 	xor		%l0, %g2, %l0
 	xor		%l1, %g3, %l1
 	stxa		%l0, [%i0 + 0x10] %asi
 	stxa		%l1, [%i0 + 0x18] %asi
-	ldda		[%i6 + 0x20] %asi, %g2	/* %g2/%g3 = src3 + 0x20 */
+	ldda		[%l6 + 0x20] %asi, %g2	/* %g2/%g3 = src3 + 0x20 */
 	ldda		[%i0 + 0x20] %asi, %l0	/* %l0/%l1 = dest + 0x20 */
 
 	xor		%i4, %i2, %i4
@@ -517,12 +517,12 @@ xor_niagara_4:		/* %o0=bytes, %o1=dest, 
 	ldda		[%i1 + 0x30] %asi, %i2	/* %i2/%i3 = src1 + 0x30 */
 	xor		%g2, %i4, %g2
 	xor		%g3, %i5, %g3
-	ldda		[%i7 + 0x30] %asi, %i4	/* %i4/%i5 = src2 + 0x30 */
+	ldda		[%l7 + 0x30] %asi, %i4	/* %i4/%i5 = src2 + 0x30 */
 	xor		%l0, %g2, %l0
 	xor		%l1, %g3, %l1
 	stxa		%l0, [%i0 + 0x20] %asi
 	stxa		%l1, [%i0 + 0x28] %asi
-	ldda		[%i6 + 0x30] %asi, %g2	/* %g2/%g3 = src3 + 0x30 */
+	ldda		[%l6 + 0x30] %asi, %g2	/* %g2/%g3 = src3 + 0x30 */
 	ldda		[%i0 + 0x30] %asi, %l0	/* %l0/%l1 = dest + 0x30 */
 
 	prefetch	[%i1 + 0x40], #one_read

-- 
