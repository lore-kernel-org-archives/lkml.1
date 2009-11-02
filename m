Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZKBJW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZKBJW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZKBJWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:22:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZKBJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:22:24 -0500
Date: Mon, 2 Nov 2009 10:22:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
Message-ID: <20091102092214.GB8933@elte.hu>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-3-git-send-email-gleb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257076590-29559-3-git-send-email-gleb@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gleb Natapov <gleb@redhat.com> wrote:

> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f4cee90..14707dc 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -952,6 +952,9 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	int write;
>  	int fault;
>  
> +	if (arch_handle_page_fault(regs, error_code))
> +		return;
> +

This patch is not acceptable unless it's done cleaner. Currently we 
already have 3 callbacks in do_page_fault() (kmemcheck, mmiotrace, 
notifier), and this adds a fourth one. Please consolidate them into a 
single callback site, this is a hotpath on x86.

And please always Cc: the x86 maintainers to patches that touch x86 
code.

	Ingo
