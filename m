Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYEZSmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYEZSmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbYEZSlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:41:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53776 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbYEZSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:41:45 -0400
Date: Mon, 26 May 2008 20:42:31 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: aperture_64.c: cleanups
Message-ID: <20080526184231.GA17024@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some small cleanups for aperture_64.c; they should not really change
any code.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 4a3d8cf..2088b6a 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -1,8 +1,9 @@
 /*
  * Firmware replacement code.
  *
- * Work around broken BIOSes that don't set an aperture or only set the
- * aperture in the AGP bridge.
+ * Work around broken BIOSes that don't set an aperture, only set the
+ * aperture in the AGP bridge, or set too small aperture.
+ *
  * If all fails map the aperture over some low memory.  This is cheaper than
  * doing bounce buffering. The memory is lost. This is done at early boot
  * because only the bootmem allocator can allocate 32+MB.
@@ -93,7 +94,7 @@ static int __init aperture_valid(u64 ape
 }
 
 /* Find a PCI capability */
-static __u32 __init find_cap(int num, int slot, int func, int cap)
+static u32 __init find_cap(int num, int slot, int func, int cap)
 {
 	int bytes;
 	u8 pos;
@@ -119,7 +120,7 @@ static __u32 __init find_cap(int num, in
 }
 
 /* Read a standard AGPv3 bridge header */
-static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
+static u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
 {
 	u32 apsize;
 	u32 apsizereg;
@@ -168,7 +169,7 @@ static __u32 __init read_agp(int num, in
  * the AGP bridges should be always an own bus on the HT hierarchy,
  * but do it here for future safety.
  */
-static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
+static u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 {
 	int num, slot, func;
 
@@ -383,6 +387,7 @@ void __init gart_iommu_hole_init(void)
 			 * early.
 			 */
 			panic("Not enough memory for aperture");
+			/* Could we fall back to iommu=soft here? */
 		}
 	} else {
 		return;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
