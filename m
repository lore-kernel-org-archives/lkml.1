Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYLDONI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYLDONI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYLDOMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:12:55 -0500
Received: from ozlabs.org ([203.10.76.45]:41310 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYLDOMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:12:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Yet more ARM breakage in linux-next
Date: Fri, 5 Dec 2008 00:42:27 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <20081203192905.GA12502@flint.arm.linux.org.uk> <20081203124109.79f8f15b.akpm@linux-foundation.org> <Pine.LNX.4.64.0812041017470.10635@anakin>
In-Reply-To: <Pine.LNX.4.64.0812041017470.10635@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050042.28222.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 19:48:06 Geert Uytterhoeven wrote:
> Also broke m68k (a bit more hidden due to other build failures).

And m68knommu has similar issues.

Here's what I have for m68k for tomorrow's linux-next.  Please steal.

m68k: define __fls

Like fls, but can't be handed 0 and returns the bit number.

(I broke this arch in linux-next by using __fls in generic code).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -315,6 +315,11 @@ static inline int fls(int x)
 	return 32 - cnt;
 }
 
+static inline int __fls(int x)
+{
+	return fls(x) - 1;
+}
+
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>



