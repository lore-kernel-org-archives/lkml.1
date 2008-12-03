Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbYLCKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbYLCKkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYLCKkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:40:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYLCKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:40:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Clean up namespace in kmap_types.h
Date: Wed, 3 Dec 2008 11:40:01 +0100
User-Agent: KMail/1.9.9
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
References: <20081203003620.GA32069@basil.nowhere.org>
In-Reply-To: <20081203003620.GA32069@basil.nowhere.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031140.02338.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ltdcefY7Ldr48+O+kqceES3SMrDNyaImWRcY
 fSf9WxZ5wtunBq5Tut6N6TElC/pnsifPvBQAshqkZAWDkbmZiX
 WBuBJ3utUTaeWwMAgtvDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008, Andi Kleen wrote:
> Clean up namespace in kmap_types.h
> 
> During debugging I often use custom "D" macros. But I ran
> into a name space conflict with kmap_types.h which also defines a D macro.
> Rename the kmap_types.h one to KMAPD.
> 
> No semantical changes.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

The patch looks ok, but it seems wrong to do this only on one architecture,
because kmap_types.h is mostly identical across all architectures.

I'm working on patches to consolidate a lot of generic headers, why not
add this in a generic way and make x86 use that version?

	Arnd <><

--- /dev/null
+++ b/include/asm-generic/kmap_types.h
@@ -0,0 +1,29 @@
+#ifndef __ASM_GENERIC_KMAP_TYPES_H
+#define __ASM_GENERIC_KMAP_TYPES_H
+
+#ifdef CONFIG_DEBUG_HIGHMEM
+# define KMAPD(n) __KM_FENCE_##n ,
+#else
+# define KMAPD(n)
+#endif
+
+enum km_type {
+KMAPD(0)	KM_BOUNCE_READ,
+KMAPD(1)	KM_SKB_SUNRPC_DATA,
+KMAPD(2)	KM_SKB_DATA_SOFTIRQ,
+KMAPD(3)	KM_USER0,
+KMAPD(4)	KM_USER1,
+KMAPD(5)	KM_BIO_SRC_IRQ,
+KMAPD(6)	KM_BIO_DST_IRQ,
+KMAPD(7)	KM_PTE0,
+KMAPD(8)	KM_PTE1,
+KMAPD(9)	KM_IRQ0,
+KMAPD(10)	KM_IRQ1,
+KMAPD(11)	KM_SOFTIRQ0,
+KMAPD(12)	KM_SOFTIRQ1,
+KMAPD(13)	KM_TYPE_NR
+};
+
+#undef KMAPD
+
+#endif /* __ASM_GENERIC_KMAP_TYPES_H */
