Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbXFOJcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbXFOJcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXFOJcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:32:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbXFOJcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:32:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 11:31:37 +0200
User-Agent: KMail/1.9.6
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <1181897905.26853.66.camel@localhost.localdomain> <200706151128.39566.arnd@arndb.de>
In-Reply-To: <200706151128.39566.arnd@arndb.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151131.38429.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1941xISdBrKJc9+slWnks6dqpSTYD6WEYGQmNG
 3GS6ppcOX+oMatlX8hovTrdxB+P6SVjrUCQifqUlCOe6Of6qdI
 Od5GkpmgSuWMzNZMcA/zg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One common problem with 32 bit system call and ioctl emulation
is the different alignment rules between i386 and 64 bit machines.
A number of drivers work around this by marking the compat
structures as 'attribute((packed))', which is not the right
solution because it breaks all the non-x86 architectures that
want to use the same compat code.

Hopefully, this patch improves the situation, it introduces two
new types, compat_u64 and compat_s64. These are defined on all
architectures to have the same size and alignment as the 32 bit
version of u64 and s64.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

See the discussions about 'Re: drm: fix radeon setparam on
32/64 bit systems.' and 'diskquota: 32bit quota tools on
64bit architectures' about where this comes from.

Index: linux-2.6/include/asm-ia64/compat.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/compat.h
+++ linux-2.6/include/asm-ia64/compat.h
@@ -31,8 +31,10 @@ typedef s32		compat_timer_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64 __attribute__((aligned(4))) compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64 __attribute__((aligned(4))) compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
Index: linux-2.6/include/asm-mips/compat.h
===================================================================
--- linux-2.6.orig/include/asm-mips/compat.h
+++ linux-2.6/include/asm-mips/compat.h
@@ -37,8 +37,10 @@ typedef s32		compat_key_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
Index: linux-2.6/include/asm-parisc/compat.h
===================================================================
--- linux-2.6.orig/include/asm-parisc/compat.h
+++ linux-2.6/include/asm-parisc/compat.h
@@ -31,8 +31,10 @@ typedef s32	compat_timer_t;
 
 typedef s32	compat_int_t;
 typedef s32	compat_long_t;
+typedef s64	compat_s64;
 typedef u32	compat_uint_t;
 typedef u32	compat_ulong_t;
+typedef u64	compat_u64;
 
 struct compat_timespec {
 	compat_time_t		tv_sec;
Index: linux-2.6/include/asm-powerpc/compat.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/compat.h
+++ linux-2.6/include/asm-powerpc/compat.h
@@ -33,8 +33,10 @@ typedef s32		compat_timer_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
Index: linux-2.6/include/asm-s390/compat.h
===================================================================
--- linux-2.6.orig/include/asm-s390/compat.h
+++ linux-2.6/include/asm-s390/compat.h
@@ -60,8 +60,10 @@ typedef s32		compat_timer_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
Index: linux-2.6/include/asm-sparc64/compat.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/compat.h
+++ linux-2.6/include/asm-sparc64/compat.h
@@ -31,8 +31,10 @@ typedef s32		compat_timer_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
Index: linux-2.6/include/asm-x86_64/compat.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/compat.h
+++ linux-2.6/include/asm-x86_64/compat.h
@@ -33,8 +33,10 @@ typedef s32		compat_key_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64 __attribute__((aligned(4))) compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64 __attribute__((aligned(4))) compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
