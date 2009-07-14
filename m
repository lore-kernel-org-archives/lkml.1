Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZGNKGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZGNKGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZGNKGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:06:40 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61260 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbZGNKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:06:39 -0400
Subject: [PATCH] x86: _edata should include all .data.* sections on X86_64
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org
In-Reply-To: <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
References: <4A5C20E5.6010203@fisher-privat.net>
	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 14 Jul 2009 10:52:55 +0100
Message-Id: <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 09:52:56.0924 (UTC) FILETIME=[DD4A89C0:01CA0468]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .data.read_mostly and .data.cacheline_aligned sections aren't
covered by the _sdata .. _edata range on X86_64. This affects the
kmemleak reporting leading to possible false positives by not scanning
all the whole data section.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
---

(I re-posted this patch with comments and cc'ing the relevant people)

 arch/x86/kernel/vmlinux.lds.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 367e878..59f31d2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -112,11 +112,6 @@ SECTIONS
 		_sdata = .;
 		DATA_DATA
 		CONSTRUCTORS
-
-#ifdef CONFIG_X86_64
-		/* End of data section */
-		_edata = .;
-#endif
 	} :data
 
 #ifdef CONFIG_X86_32
@@ -156,10 +151,8 @@ SECTIONS
 	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
 		*(.data.read_mostly)
 
-#ifdef CONFIG_X86_32
 		/* End of data section */
 		_edata = .;
-#endif
 	}
 
 #ifdef CONFIG_X86_64


