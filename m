Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0BPOES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:04:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab0BPOER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:04:17 -0500
Date: Tue, 16 Feb 2010 15:03:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: ELF_PLAT_INIT() shouldn't worry about TIF_IA32
Message-ID: <20100216140323.GD16448@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216140126.GA16448@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64bit vesrion of ELF_PLAT_INIT() clears TIF_IA32, but at this point it
must be already cleared by SET_PERSONALITY == set_personality_64bit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/include/asm/elf.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- exec/arch/x86/include/asm/elf.h~3_ELF_PLAT_INIT_IA32	2010-01-31 13:57:24.000000000 +0100
+++ exec/arch/x86/include/asm/elf.h	2010-02-16 14:44:31.000000000 +0100
@@ -170,10 +170,7 @@ static inline void elf_common_init(struc
 }
 
 #define ELF_PLAT_INIT(_r, load_addr)			\
-do {							\
-	elf_common_init(&current->thread, _r, 0);	\
-	clear_thread_flag(TIF_IA32);			\
-} while (0)
+	elf_common_init(&current->thread, _r, 0);
 
 #define	COMPAT_ELF_PLAT_INIT(regs, load_addr)		\
 	elf_common_init(&current->thread, regs, __USER_DS)

