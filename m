Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZFPMzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZFPMzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZFPMza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 2/9] x86: Remove .sdata from the vDSO linker script
Date: Tue, 16 Jun 2009 14:55:22 +0200
Message-Id: <1245156929-30395-3-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no .sdata section on either i386 or x86_64.

The existence of this line probably dates back to the (long abandoned)
idea that x86_64 would have .sdata for "small" data and .data for large
data. However, the final ABI has .data for "normal" data and .ldata
for large data, so this line is no longer pertinent.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
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

