Return-Path: <linux-kernel-owner+w=401wt.eu-S1764990AbXLTOhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764990AbXLTOhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934085AbXLTOXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:23:08 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:8993 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934033AbXLTOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:23:04 -0500
Message-ID: <476A790A.2060203@ru.mvista.com>
Date: Thu, 20 Dec 2007 17:15:38 +0300
From: Egor Starkov <estarkov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: mingo@elte.hu
Cc: rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: PPC64 doesn't compile with CONFIG_SMP=n
Content-Type: multipart/mixed;
 boundary="------------090808080300070509010501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090808080300070509010501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Ingo

I've found out that real-time tree doesn't compile for PPC64 with 
CONFIG_SMP=n.

Think this is due to patch-2.6.21.4-rt10 patch. It has
definitions of following symbols missing: __get_cpu_lock,
__get_cpu_var_locked.

I've attached the patch to fix the problem.

Egor Starkov

--------------090808080300070509010501
Content-Type: text/plain;
 name="powerpc_smp_bugfix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="powerpc_smp_bugfix"

Signed-off-by: Egor Starkov <estarkov@ru.mvista.com>

Index: linux-2.6.21/include/asm-powerpc/percpu.h
===================================================================
--- linux-2.6.21.orig/include/asm-powerpc/percpu.h
+++ linux-2.6.21/include/asm-powerpc/percpu.h
@@ -61,6 +61,8 @@ extern void setup_per_cpu_areas(void);
 
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
+#define __get_cpu_lock(var, cpu)		per_cpu_lock__##var##_locked
+#define __get_cpu_var_locked(var, cpu)		per_cpu__##var##_locked
 
 #endif	/* SMP */
 

--------------090808080300070509010501--
