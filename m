Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbXLTUJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbXLTUJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbXLTUIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:08:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbXLTUIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:08:37 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 03/15] cleanup write_tsc
Date: Thu, 20 Dec 2007 18:03:58 -0200
Message-Id: <11981812041672-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981811852758-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_tsc() does not need to be enclosed in any paravirt closure,
as it uses wrmsr(). So we rip off the duplicate in msr.h
and the definition from paravirt.h

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/msr.h      |    2 --
 include/asm-x86/paravirt.h |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

Index: linux-2.6-x86/include/asm-x86/msr.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/msr.h	2007-12-20 19:06:59.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/msr.h	2007-12-20 19:07:18.000000000 -0800
@@ -153,8 +153,6 @@
 #define rdtscll(val)						\
 	((val) = native_read_tsc())
 
-#define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
-
 #define rdpmc(counter,low,high)					\
 	do {							\
 		u64 _l = native_read_pmc(counter);		\
Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:07:17.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:07:18.000000000 -0800
@@ -657,8 +657,6 @@
 }
 #define calculate_cpu_khz() (pv_time_ops.get_cpu_khz())
 
-#define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
-
 static inline unsigned long long paravirt_read_pmc(int counter)
 {
 	return PVOP_CALL1(u64, pv_cpu_ops.read_pmc, counter);
