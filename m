Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZDWHa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZDWHa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZDWH13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:29 -0400
Received: from sous-sol.org ([216.99.217.87]:48162 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754736AbZDWH1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:19 -0400
Message-Id: <20090423072135.806792741@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:26 -0700
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
       alan@lxorguk.ukuu.org.uk, dann frazier <dannf@dannf.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 006/100] MIPS: Compat: Zero upper 32-bit of offset_high and offset_low.
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=mips-compat-zero-upper-32-bit-of-offset_high-and-offset_low.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ralf Baechle <ralf@linux-mips.org>

upstream commit: d6c178e9694e7e0c7ffe0289cf4389a498cac735

Through sys_llseek() arguably should do exactly that it doesn't which
means llseek(2) will fail for o32 processes if offset_low has bit 31 set.

As suggested by Heiko Carstens.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
---
 arch/mips/kernel/linux32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -134,9 +134,9 @@ SYSCALL_DEFINE4(32_ftruncate64, unsigned
 	return sys_ftruncate(fd, merge_64(a2, a3));
 }
 
-SYSCALL_DEFINE5(32_llseek, unsigned long, fd, unsigned long, offset_high,
-	unsigned long, offset_low, loff_t __user *, result,
-	unsigned long, origin)
+SYSCALL_DEFINE5(32_llseek, unsigned int, fd, unsigned int, offset_high,
+		unsigned int, offset_low, loff_t __user *, result,
+		unsigned int, origin)
 {
 	return sys_llseek(fd, offset_high, offset_low, result, origin);
 }

