Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZA0Lh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZA0Lh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZA0Lht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:37:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZA0Lhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:37:48 -0500
Date: Tue, 27 Jan 2009 12:37:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 #tj-percpu] x86: fix build breakage on voyage
Message-ID: <20090127113734.GA28249@elte.hu>
References: <20090126103243.GA31307@elte.hu> <1232977445-11815-1-git-send-email-brgerst@gmail.com> <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org> <497E8778.9060503@gmail.com> <1233032609.3248.78.camel@localhost.localdomain> <497E9B9D.4010102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E9B9D.4010102@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> Impact: build fix
> 
> x86_cpu_to_apicid and x86_bios_cpu_apicid aren't defined for voyage. 
> Earlier patch forgot to conditionalize early percpu clearing.  Fix it.

> +#ifdef CONFIG_X86_LOCAL_APIC
>  	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
>  	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
> +#endif

That patch is not acceptable - it is ugly and it adds another set of
#ifdefs to an already complex piece of code.

As i explained it to James in recent threads, the clean and acceptable 
solution to this class of problems is to switch Voyager away from that 
fragile subarch code to proper generic x86 code. (just like we did it for 
other subarchitectures)

There is nothing in Voyager that justifies special treatment in the area 
of x86 percpu code.

This is one of the mails that explains the principles:

  http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00954.html

Or - if there's no time/interest in doing that, we can mark Voyager as 
CONFIG_BROKEN.

	Ingo
