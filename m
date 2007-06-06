Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbXFFNGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbXFFNGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbXFFNGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:06:13 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:27765 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153AbXFFNGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:06:12 -0400
Message-ID: <4666B141.8000102@fr.ibm.com>
Date: Wed, 06 Jun 2007 15:06:09 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

here's a minor fix for x86_64,

C.


when CONFIG_PM=y and CONFIG_SOFTWARE_SUSPEND=n, 

  CC      arch/x86_64/kernel/e820.o
/home/legoater/linux/2.6.22-rc4-mm1/arch/x86_64/kernel/e820.c: In function `e820_mark_nosave_regions':
/home/legoater/linux/2.6.22-rc4-mm1/arch/x86_64/kernel/e820.c:248: warning: implicit declaration of function `register_nosave_region'

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 include/linux/suspend.h |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: 2.6.22-rc4-mm1/include/linux/suspend.h
===================================================================
--- 2.6.22-rc4-mm1.orig/include/linux/suspend.h
+++ 2.6.22-rc4-mm1/include/linux/suspend.h
@@ -74,6 +74,14 @@
 extern void hibernation_set_ops(struct hibernation_ops *ops);
 extern int hibernate(void);
 #else /* CONFIG_SOFTWARE_SUSPEND */
+static inline void register_nosave_region(unsigned long b, unsigned long e)
+{
+}
+
+static inline void register_nosave_region_late(unsigned long b, unsigned long e)
+{
+}
+
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
