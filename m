Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZBTMhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZBTMhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZBTMh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:37:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32956 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZBTMh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:37:28 -0500
Date: Fri, 20 Feb 2009 13:37:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: mingo@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] IA64: cast has a higher precedence than '?'
Message-ID: <20090220123703.GB26418@elte.hu>
References: <499E9C71.3050003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499E9C71.3050003@gmail.com>
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


* Roel Kluin <roel.kluin@gmail.com> wrote:

> because of the ?: this is not strictly necessary, but I think the added
> parentheses are nice here.
> 
> --------------------------->8-------------8<------------------------------
> A cast has a higher precedence than '?'

> @@ -61,7 +61,7 @@ static inline void syscall_set_return_value(struct task_struct *task,
>  					    struct pt_regs *regs,
>  					    int error, long val)
>  {
> -	regs->ax = (long) error ?: val;
> +	regs->ax = (long) (error ?: val);

it doesnt matter, does it? the 32-bit entity here is 'error', so 
casting it to 64-bit long is just as fine as casting the end 
result to long. In fact this should be the best:

	regs->ax = error ?: val;

as the 32-bit 'error' will be extended to 64 bits anyway.

	Ingo
