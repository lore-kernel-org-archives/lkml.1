Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbXKUKTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbXKUKTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbXKUKTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:19:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbXKUKTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:19:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/5] x86: get_desc_base
X-Zippy-Says: Yow!  I'm imagining a surfer van filled with soy sauce!
Message-Id: <20071121101928.A08CF26F8BE@magilla.localdomain>
Date: Wed, 21 Nov 2007 02:19:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This defines the get_desc_base function in asm-x86/desc_64.h to match the
one in desc_32.h.  If these two files ever get merged together, this
function could be the same in both.

Signed-off-by: Roland McGrath <roland@redhat.com>

diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 7d9c938..70bd72f 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -199,6 +199,16 @@ static inline void load_LDT(mm_context_t *pc)
 
 extern struct desc_ptr idt_descr;
 
+static inline unsigned long get_desc_base(const void *ptr)
+{
+	const u32 *desc = ptr;
+	unsigned long base;
+	base = ((desc[0] >> 16)  & 0x0000ffff) |
+		((desc[1] << 16) & 0x00ff0000) |
+		(desc[1] & 0xff000000);
+	return base;
+}
+
 #endif /* !__ASSEMBLY__ */
 
 #endif
