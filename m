Return-Path: <linux-kernel-owner+w=401wt.eu-S933688AbZGQAJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbZGQAJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933687AbZGQAFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:05:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39119 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933681AbZGQAFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH 07/21] Blackfin: fix miscompilation in lshrdi3
Date: Thu, 16 Jul 2009 20:05:32 -0400
Message-Id: <1247789146-18786-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

The code used in the Blackfin lshrdi3 utilizes gcc constructs.  However,
the structures declared don't line up with the code gcc generates, so
under certain optimizations, we get bad code and things crap out in fun
random ways.  So rather than trying to maintain different gcc definitions
ourselves, just use the ones available in gcclib.h.

URL: http://blackfin.uclinux.org/gf/tracker/5286
Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/lib/lshrdi3.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/arch/blackfin/lib/lshrdi3.c b/arch/blackfin/lib/lshrdi3.c
index 84b9c55..e57bf6f 100644
--- a/arch/blackfin/lib/lshrdi3.c
+++ b/arch/blackfin/lib/lshrdi3.c
@@ -27,21 +27,7 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#define BITS_PER_UNIT 8
-
-typedef int SItype __attribute__ ((mode(SI)));
-typedef unsigned int USItype __attribute__ ((mode(SI)));
-typedef int DItype __attribute__ ((mode(DI)));
-typedef int word_type __attribute__ ((mode(__word__)));
-
-struct DIstruct {
-	SItype high, low;
-};
-
-typedef union {
-	struct DIstruct s;
-	DItype ll;
-} DIunion;
+#include "gcclib.h"
 
 #ifdef CONFIG_ARITHMETIC_OPS_L1
 DItype __lshrdi3(DItype u, word_type b)__attribute__((l1_text));
-- 
1.6.3.3

