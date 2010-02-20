Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0BTAIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:08:13 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:53472 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab0BTAET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BjmjBEnaKWnG/3tvO4fNWxcBtfzcOjTp07yyOz1p2L+ZW4TattxiB7VO0fH7AdQICj
         iHSmer4XFStMfa/fJ4GB8/11TpALiWSbgSipA41OdDqWqQOEc6Ny5m5Ao+S6dcpsFKPa
         trCEe65xj5EZaVyGI5Oe7J3CbwEIHvmonvjsw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 03/24] powerpc: remove unused __page_aligned definition.
Date: Sat, 20 Feb 2010 01:03:36 +0100
Message-Id: <1266624237-22372-4-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@ksplice.com>

There is already an architecture-independent __page_aligned_data macro
for this purpose, so removing the powerpc-specific macro should be
harmless.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/powerpc/include/asm/page_64.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
index bfc4e02..358ff14 100644
--- a/arch/powerpc/include/asm/page_64.h
+++ b/arch/powerpc/include/asm/page_64.h
@@ -162,14 +162,6 @@ do {						\
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 
-#ifdef MODULE
-#define __page_aligned __attribute__((__aligned__(PAGE_SIZE)))
-#else
-#define __page_aligned \
-	__attribute__((__aligned__(PAGE_SIZE), \
-		__section__(".data.page_aligned")))
-#endif
-
 #define VM_DATA_DEFAULT_FLAGS \
 	(test_thread_flag(TIF_32BIT) ? \
 	 VM_DATA_DEFAULT_FLAGS32 : VM_DATA_DEFAULT_FLAGS64)
-- 
1.6.2.4

