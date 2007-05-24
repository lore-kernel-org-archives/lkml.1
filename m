Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbXEXSSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbXEXSSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbXEXSSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:18:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52693 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbXEXSSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:18:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org
Subject: [patch] use POSIX BRE in headers install target
Date: Thu, 24 May 2007 14:18:45 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241418.46625.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sed expression used at the moment in scripts/Makefile.headersinst relies
on the (handy) GNU extension where you can escape ERE's in an otherwise BRE
without using the GNU -r option.  The following patch replaces this "\+" usage
with a functionally equivalent POSIX BRE compliant "\{1,\}".  Tested with
`make headers_install` against blackfin/x86_64/i386 targets.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Stupid whiny OS X users and their crappy sed ;)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 8cd6301..fb6726b 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -11,13 +11,13 @@ UNIFDEF := scripts/unifdef -U__KERNEL__
 
 # Eliminate the contents of (and inclusions of) compiler.h
 HDRSED  := sed 	-e "s/ inline / __inline__ /g" \
-		-e "s/[[:space:]]__user[[:space:]]\+/ /g" \
-		-e "s/(__user[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__force[[:space:]]\+/ /g" \
-		-e "s/(__force[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__iomem[[:space:]]\+/ /g" \
-		-e "s/(__iomem[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__attribute_const__[[:space:]]\+/\ /g" \
+		-e "s/[[:space:]]__user[[:space:]]\{1,\}/ /g" \
+		-e "s/(__user[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" \
+		-e "s/(__force[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" \
+		-e "s/(__iomem[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" \
 		-e "s/[[:space:]]__attribute_const__$$//" \
 		-e "/^\#include <linux\/compiler.h>/d"
 
