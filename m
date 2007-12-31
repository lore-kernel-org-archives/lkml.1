Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbXLaFpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbXLaFpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 00:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXLaFp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 00:45:26 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:60566 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXLaFpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 00:45:25 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: asm-x86/msr.h for sanitized headers: clean it or punt it
Date: Mon, 31 Dec 2007 00:45:23 -0500
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712310045.24069.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current asm-x86/msr.h does not actually define anything for (!__KERNEL__
&& __i386__).  For x86_64, it fails to build due to u32/u64 types being used.
Simply not installing the header seems easiest to me.  Otherwise, x86_64 will
need sanitizing and i386 should have things added back, otherwise it's just a
pointless empty header.

Signed-Off-By: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
index 12db5a1..6453804 100644
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -4,7 +4,6 @@ header-y += boot.h
 header-y += bootparam.h
 header-y += debugreg.h
 header-y += ldt.h
-header-y += msr-index.h
 header-y += prctl.h
 header-y += ptrace-abi.h
 header-y += sigcontext32.h
@@ -14,7 +13,6 @@ header-y += vsyscall32.h
 unifdef-y += e820.h
 unifdef-y += ist.h
 unifdef-y += mce.h
-unifdef-y += msr.h
 unifdef-y += mtrr.h
 unifdef-y += page_32.h
 unifdef-y += page_64.h
