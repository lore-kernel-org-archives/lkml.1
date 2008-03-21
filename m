Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYCULvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYCULvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYCULvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:51:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbYCULvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:51:16 -0400
Date: Fri, 21 Mar 2008 12:50:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Arch: x86_32, fix fault_msg nul termination
Message-ID: <20080321115029.GB25225@elte.hu>
References: <1205330034-28828-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205330034-28828-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> The fault_msg text is not explictly nul terminated now in startup 
> assembly. Do so by converting .ascii to .asciz.

thanks Jiri, applied.

>  fault_msg:
> -	.ascii								\
> +	.asciz								\
>  /* fault info: */	"BUG: Int %d: CR2 %p\n"				\
>  /* pusha regs: */	"     EDI %p  ESI %p  EBP %p  ESP %p\n"		\
>  			"     EBX %p  EDX %p  ECX %p  EAX %p\n"		\

i guess in practice we were saved by a NIL following this string, but 
there's no guarantee indeed.

	Ingo
