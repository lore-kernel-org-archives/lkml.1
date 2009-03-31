Return-Path: <linux-kernel-owner+w=401wt.eu-S1765131AbZCaXj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765131AbZCaXj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764305AbZCaXWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:22:45 -0400
Received: from sous-sol.org ([216.99.217.87]:33368 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759042AbZCaXWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:22:44 -0400
Message-Id: <20090331231702.070064793@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mikael Pettersson <mikpe@it.uu.se>,
       Nicolas Pitre <nico@cam.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 33/45] ARM: 5435/1: fix compile warning in sanity_check_meminfo()
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=arm-5435-1-fix-compile-warning-in-sanity_check_meminfo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mikael Pettersson <mikpe@it.uu.se>

upstream commit: f0bba9f934517533acbda7329be93f55d5a01c03

Compiling recent 2.6.29-rc kernels for ARM gives me the following warning:

arch/arm/mm/mmu.c: In function 'sanity_check_meminfo':
arch/arm/mm/mmu.c:697: warning: comparison between pointer and integer

This is because commit 3fd9825c42c784a59b3b90bdf073f49d4bb42a8d
"[ARM] 5402/1: fix a case of wrap-around in sanity_check_meminfo()"
in 2.6.29-rc5-git4 added a comparison of a pointer with PAGE_OFFSET,
which is an integer.

Fixed by casting PAGE_OFFSET to void *.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Nicolas Pitre <nico@cam.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/arm/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -694,7 +694,7 @@ static void __init sanity_check_meminfo(
 		 * the vmalloc area.
 		 */
 		if (__va(bank->start) >= VMALLOC_MIN ||
-		    __va(bank->start) < PAGE_OFFSET) {
+		    __va(bank->start) < (void *)PAGE_OFFSET) {
 			printk(KERN_NOTICE "Ignoring RAM at %.8lx-%.8lx "
 			       "(vmalloc region overlap).\n",
 			       bank->start, bank->start + bank->size - 1);

