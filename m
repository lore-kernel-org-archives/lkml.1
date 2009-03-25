Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbZCYMk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbZCYMk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbZCYMkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:40:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44637 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708AbZCYMkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:40:17 -0400
Date: Wed, 25 Mar 2009 13:38:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frank Seidel <fseidel@kernel.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Jim Keniston <jkenisto@us.ibm.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] trivial: remove warning from arch/x86/kernel/kprobes.c
Message-ID: <20090325123812.GA30755@elte.hu>
References: <49CA24B6.103@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49CA24B6.103@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Seidel <fseidel@kernel.org> wrote:

> From: Frank Seidel <frank@f-seidel.de>
> 
> Remove warning (makes integer from pointer without a cast)
> from build messages.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  arch/x86/kernel/kprobes.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -193,7 +193,7 @@ static int __kprobes can_boost(kprobe_op
>  	kprobe_opcode_t opcode;
>  	kprobe_opcode_t *orig_opcodes = opcodes;
>  
> -	if (search_exception_tables(opcodes))
> +	if (search_exception_tables((unsigned long)opcodes))
>  		return 0;	/* Page fault may occur on this address. */

fixed in the x86 tree:

  http://people.redhat.com/mingo/tip.git/README

a couple of days ago. (see the commit below)

	Ingo

---------->
>From cde5edbda8ba7d600154ce4171125a48e4d2a21b Mon Sep 17 00:00:00 2001
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Wed, 18 Mar 2009 17:37:45 +0530
Subject: [PATCH] x86: kprobes.c fix compilation warning
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

arch/x86/kernel/kprobes.c:196: warning: passing argument 1 of ‘search_exception_tables’ makes integer from pointer without a cast

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference:<49BED952.2050809@redhat.com>
LKML-Reference: <1237378065.13488.2.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 4558dd3..55b9461 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -193,7 +193,7 @@ static int __kprobes can_boost(kprobe_opcode_t *opcodes)
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
 
-	if (search_exception_tables(opcodes))
+	if (search_exception_tables((unsigned long)opcodes))
 		return 0;	/* Page fault may occur on this address. */
 
 retry:
