Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbYC0RNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbYC0RNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760534AbYC0RLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:11:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760367AbYC0RLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:11:15 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 4/9] [PATCH] x86: surround apic headers in apic definitions
Date: Thu, 27 Mar 2008 14:05:59 -0300
Message-Id: <1206637582638-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although those constants are always defined in x86_64,
and will have the effect of just including the headers
in the very way we did before, I'm doing this in a separate
patch to be conservative and avoid surprises.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp_64.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 015d36e..b83151d 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -7,9 +7,13 @@
 /*
  * We need the APIC definitions automatically as part of 'smp.h'
  */
-#include <asm/apic.h>
-#include <asm/io_apic.h>
-#include <asm/mpspec.h>
+#ifdef CONFIG_X86_LOCAL_APIC
+#  include <asm/mpspec.h>
+#  include <asm/apic.h>
+#  ifdef CONFIG_X86_IO_APIC
+#   include <asm/io_apic.h>
+#  endif
+#endif
 #include <asm/pda.h>
 #include <asm/thread_info.h>
 
-- 
1.5.0.6

