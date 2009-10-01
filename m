Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZJAXjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZJAXjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZJAXjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:39:37 -0400
Received: from kroah.org ([198.145.64.141]:42099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbZJAXiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:22 2009
Message-Id: <20091001233322.806126675@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       bernhard.weirich@riedel.net, RFeany@mrv.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 27/30] powerpc: Fix incorrect setting of __HAVE_ARCH_PTE_SPECIAL
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-fix-incorrect-setting-of-__have_arch_pte_special.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Weirich, Bernhard <Bernhard.Weirich@riedel.net>

[I'm going to fix upstream differently, by having all CPU types
actually support _PAGE_SPECIAL, but I prefer the simple and obvious
fix for -stable. -- Ben]

The test that decides whether to define __HAVE_ARCH_PTE_SPECIAL on
powerpc is bogus and will end up always defining it, even when
_PAGE_SPECIAL is not supported (in which case it's 0) such as on
8xx or 40x processors.

Signed-off-by: Bernhard Weirich <bernhard.weirich@riedel.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/powerpc/include/asm/pte-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/pte-common.h
+++ b/arch/powerpc/include/asm/pte-common.h
@@ -176,7 +176,7 @@ extern unsigned long bad_call_to_PMD_PAG
 #define HAVE_PAGE_AGP
 
 /* Advertise support for _PAGE_SPECIAL */
-#ifdef _PAGE_SPECIAL
+#if _PAGE_SPECIAL != 0
 #define __HAVE_ARCH_PTE_SPECIAL
 #endif
 


