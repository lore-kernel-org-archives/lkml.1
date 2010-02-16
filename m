Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab0BPODG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:03:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396Ab0BPODC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:03:02 -0500
Date: Tue, 16 Feb 2010 15:02:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: set_personality_ia32() misses force_personality32
Message-ID: <20100216140213.GB16448@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216140126.GA16448@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05d43ed8a "x86: get rid of the insane TIF_ABI_PENDING bit" forgot
about force_personality32, fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/process_64.c |    1 +
 1 file changed, 1 insertion(+)

--- exec/arch/x86/kernel/process_64.c~1_force_personality32	2010-01-31 13:57:24.000000000 +0100
+++ exec/arch/x86/kernel/process_64.c	2010-02-16 13:26:34.000000000 +0100
@@ -527,6 +527,7 @@ void set_personality_ia32(void)
 
 	/* Make sure to be in 32bit mode */
 	set_thread_flag(TIF_IA32);
+	current->personality |= force_personality32;
 
 	/* Prepare the first "return" to user space */
 	current_thread_info()->status |= TS_COMPAT;

