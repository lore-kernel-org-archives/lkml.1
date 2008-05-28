Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbYE1QFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbYE1QFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYE1QFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:05:22 -0400
Received: from gw.goop.org ([64.81.55.164]:33856 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYE1QFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:05:21 -0400
Message-ID: <483D82A1.7080406@goop.org>
Date: Wed, 28 May 2008 17:04:49 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/3] arch/powerpc: use __page_aligned_bss
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "make page-aligned data and bss less fragile" introduces
__page_aligned_data and __page_aligned_bss to make sure that page
aligned things remain so, even if there are non-page-sized
page-aligned things.

This paragraph converts an instance of an explicit section attribute
to __page_aligned_data.  It's purely decorative.

(It should be noted that powerpc already defines __page_aligned to
have the same meaning as __page_aligned_data in non-MODULE code.  Also
this particular case looks like it could be __page_aligned_bss rather
than data, but I didn't want to change the meaning of the code.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/vdso.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
+#include <linux/linkage.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/slab.h>
@@ -74,7 +75,7 @@
 static union {
 	struct vdso_data	data;
 	u8			page[PAGE_SIZE];
-} vdso_data_store __attribute__((__section__(".data.page_aligned")));
+} vdso_data_store __page_aligned_data;
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
 /* Format of the patch table */


