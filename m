Return-Path: <linux-kernel-owner+w=401wt.eu-S934177AbZFLNsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbZFLNsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbZFLNkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:40:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:42284 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201AbZFLNki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:40:38 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v2 2/8] x86: Remove .sdata from the vDSO linker script
Date: Fri, 12 Jun 2009 15:40:34 +0200
Message-Id: <1244814040-5810-3-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no .sdata section on either i386 or x86_64.

The existence of this line probably dates back to the (long abandoned)
idea that x86_64 would have .sdata for "small" data and .data for large
data. However, the final ABI has .data for "normal" data and .ldata
for large data, so this line is no longer pertinent.
---
 arch/x86/vdso/vdso-layout.lds.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 917df03..af3fa61 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -50,7 +50,6 @@ SECTIONS
 	} :text
 	.data : {
 		*(.data*)
-		*(.sdata*)
 		*(.got.plt) *(.got)
 		*(.gnu.linkonce.d.*)
 		*(.bss*)
-- 
1.6.0.2

