Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYFAQ1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYFAQ1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYFAQ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:26:57 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:54361 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYFAQ04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:26:56 -0400
Date: Mon, 02 Jun 2008 01:28:14 +0900 (JST)
Message-Id: <20080602.012814.35471915.anemo@mba.ocn.ne.jp>
To: adrian.bunk@movial.fi
Cc: chris@mips.com, ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: mips: CONF_CM_DEFAULT build error
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080525170718.GD1791@cs181133002.pp.htv.fi>
References: <20080525170718.GD1791@cs181133002.pp.htv.fi>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008 20:07:24 +0300, Adrian Bunk <adrian.bunk@movial.fi> wrote:
> Commit 351336929ccf222ae38ff0cb7a8dd5fd5c6236a0
> ([MIPS] Allow setting of the cache attribute at run time.)
> causes the following build error with pnx8550-jbs_defconfig
> and pnx8550-stb810_defconfig:

I wondered why the commit has my S-O-B, and finally found that I had
fixed a section mismatch caused by the original patch (on queue tree
on linux-mips.org) and Ralf had folded my fix into the original patch,
with my S-O-B.  Folding on the queue tree will be good on many case,
but sometimes a bit confusing. :-)


Anyway, here is a patch to fix the build failure.  Thank you for reporting.

------------------------------------------------------
Subject: [PATCH] MIPS: Fix CONF_CM_DEFAULT build error
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/include/asm-mips/pgtable-bits.h b/include/asm-mips/pgtable-bits.h
index 60e2f93..8a75677 100644
--- a/include/asm-mips/pgtable-bits.h
+++ b/include/asm-mips/pgtable-bits.h
@@ -134,6 +134,6 @@
 
 #define _PAGE_CHG_MASK  (PAGE_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED | _CACHE_MASK)
 
-#define CONF_CM_DEFAULT		(PAGE_CACHABLE_DEFAULT>>_CACHE_SHIFT)
+#define CONF_CM_DEFAULT		(_page_cachable_default >> _CACHE_SHIFT)
 
 #endif /* _ASM_PGTABLE_BITS_H */
