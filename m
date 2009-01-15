Return-Path: <linux-kernel-owner+w=401wt.eu-S1763000AbZAOLF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000AbZAOLF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZAOLFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:05:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55549 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbZAOLFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:05:11 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: [mmotm][PATCH] fix ia64 build error
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090115200315.EBE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 15 Jan 2009 20:05:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Applied after: linux-next.patch
==
Subject: [PATCH] remove duplicate EXPORT_SYMBOL()
Impact: fix build error

In past, ia64_ksyms.c had EXPORT_SYMBOL(copy_page) in wrong place.

old code was

	#include <asm/uaccess.h>
	EXPORT_SYMBOL(__copy_user);
	EXPORT_SYMBOL(__do_clear_user);
	EXPORT_SYMBOL(__strlen_user);
	EXPORT_SYMBOL(__strncpy_from_user);
	EXPORT_SYMBOL(__strnlen_user);
	EXPORT_SYMBOL(copy_page);

(but actually, copy_page is declared in asm/page.h)

And recently, commit bdc2619ab95d45d434c16d5c216bc6243761f6fb insert
EXPORT_SYMBOL(copy_page) into correct place.

then, duplicate EXPORT_SYMBOL create following build error.

arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__kcrctab_copy_page'
arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__kcrctab_copy_page' was here
arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__kstrtab_copy_page'
arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__kstrtab_copy_page' was here
arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__ksymtab_copy_page'
arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__ksymtab_copy_page' was here


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/kernel/ia64_ksyms.c |    1 -
 1 file changed, 1 deletion(-)

Index: b/arch/ia64/kernel/ia64_ksyms.c
===================================================================
--- a/arch/ia64/kernel/ia64_ksyms.c
+++ b/arch/ia64/kernel/ia64_ksyms.c
@@ -40,7 +40,6 @@ EXPORT_SYMBOL(__do_clear_user);
 EXPORT_SYMBOL(__strlen_user);
 EXPORT_SYMBOL(__strncpy_from_user);
 EXPORT_SYMBOL(__strnlen_user);
-EXPORT_SYMBOL(copy_page);
 
 /* from arch/ia64/lib */
 extern void __divsi3(void);


