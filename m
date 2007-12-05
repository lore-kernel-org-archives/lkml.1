Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbXLERx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbXLERx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXLERxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:53:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXLERxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:53:22 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/9] remove volatile keyword from clflush.
Date: Wed,  5 Dec 2007 13:08:25 -0200
Message-Id: <1196867319253-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1196867313972-git-send-email-gcosta@redhat.com>
References: 20071204204931.GC32018@elte.hu <1196867313972-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the p parameter is an explicit memory reference, and is
enough to prevent gcc to being nasty here. The volatile
seems completely not needed.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/system_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/system_32.h b/include/asm-x86/system_32.h
index ef84688..27e106d 100644
--- a/include/asm-x86/system_32.h
+++ b/include/asm-x86/system_32.h
@@ -161,7 +161,7 @@ static inline void native_wbinvd(void)
 	asm volatile("wbinvd": : :"memory");
 }
 
-static inline void clflush(volatile void *__p)
+static inline void clflush(void *__p)
 {
 	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
 }
-- 
1.4.4.2

