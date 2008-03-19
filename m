Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYCSTqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYCSTqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYCSTbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:31:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbYCSTav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:51 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 15/79] [PATCH] provide APIC_INTEGRATED definition for x86_64
Date: Wed, 19 Mar 2008 14:25:10 -0300
Message-Id: <12059476441057-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476393279-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

it is always integrated, so define as 1.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/apicdef.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/apicdef.h b/include/asm-x86/apicdef.h
index 550af7a..b0c6b28 100644
--- a/include/asm-x86/apicdef.h
+++ b/include/asm-x86/apicdef.h
@@ -22,7 +22,11 @@
 #define		APIC_LVR_MASK		0xFF00FF
 #define		GET_APIC_VERSION(x)	((x)&0xFFu)
 #define		GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
-#define		APIC_INTEGRATED(x)	((x)&0xF0u)
+#ifdef CONFIG_X86_32
+#  define	APIC_INTEGRATED(x)	((x)&0xF0u)
+#else
+#  define	APIC_INTEGRATED(x)	(1)
+#endif
 #define		APIC_XAPIC(x)		((x) >= 0x14)
 #define	APIC_TASKPRI	0x80
 #define		APIC_TPRI_MASK		0xFFu
-- 
1.5.0.6

