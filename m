Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYJQFit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYJQFit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYJQFik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:38:40 -0400
Received: from sineb-mail-1.sun.com ([192.18.19.6]:64144 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYJQFik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:38:40 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 01:38:34 EDT
Date: Fri, 17 Oct 2008 13:25:07 +0800
From: Jike Song <albcamus@gmail.com>
Subject: Re: questions about rd{msr|tsc|pmc} instruction with x86-64
In-reply-to: <48F76FA3.1000602@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Message-id: <48F821B3.2060300@gmail.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <df9815e70810152330h7886c77arb01e1fd308b4a7ae@mail.gmail.com>
 <48F6E1A7.2070602@zytor.com>
 <df9815e70810160931s86c9058rc18d426ce278aa30@mail.gmail.com>
 <48F76FA3.1000602@zytor.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>  Jike Song wrote:
> > Thanks, Peter!  So I misunderstood the gcc constraint 'A' for x86-64,
> > but seems the comment "while x86_64 returns at rax" still wrong,
> > should this be fixed?
>
>  Yes, feel free to submit a patch.
>
>     -hpa
Here you go... CC trivial@kernel.org as well.

 From 6eed2948d41f959dc113eb3ff30927bcacf34d08 Mon Sep 17 00:00:00 2001
From: Jike Song <albcamus@gmail.com>
Date: Fri, 17 Oct 2008 10:51:13 +0800
Subject: [PATCH] x86: correct wrong comment

The rdmsr instruction(et al) for i386 and x86-64 are semantically same.
The only difference is how gcc interpret constraint "A" for these targets.

Signed-off-by: Jike Song <albcamus@gmail.com>
---
 include/asm-x86/msr.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 530af1f..fd0e1a1 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -22,10 +22,10 @@ static inline unsigned long long 
native_read_tscp(unsigned int *aux)
 }
 
 /*
- * i386 calling convention returns 64-bit value in edx:eax, while
- * x86_64 returns at rax. Also, the "A" constraint does not really
- * mean rdx:rax in x86_64, so we need specialized behaviour for each
- * architecture
+ * both i386 and x86_64 returns 64-bit value in edx:eax, but gcc's "A"
+ * constraint has different meanings. For i386, "A" means exactly
+ * edx:eax, while for x86_64 it doesn't mean rdx:rax or edx:eax. Instead,
+ * it means rax *or* rdx.
  */
 #ifdef CONFIG_X86_64
 #define DECLARE_ARGS(val, low, high)    unsigned low, high
-- 
1.6.0.1


