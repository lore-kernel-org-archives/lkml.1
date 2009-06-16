Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZFPMzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZFPMzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZFPMzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 9/9] x86: remove .gnu.warning* sections from the vDSO
Date: Tue, 16 Jun 2009 14:55:29 +0200
Message-Id: <1245156929-30395-10-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .gnu.warning* sections are only processed by ld, but ld will never
explicitly link against the vDSO, so it can be discarded.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 0bef418..d199f25 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -112,6 +112,12 @@ SECTIONS
 		*(.altinstructions)
 		*(.altinstr_replacement)
 	}
+
+	/* These sections are not useful to user-space */
+	/DISCARD/ : {
+		*(.gnu.warning*)
+		*(.discard)
+	}
 }
 
 /*
-- 
1.6.0.2

