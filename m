Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXCPIdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXCPIdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXCPIdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:33:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47983 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbXCPIdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:33:32 -0400
Date: Fri, 16 Mar 2007 09:32:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org, eranian@hpl.hp.com, rdunlap@xenotime.net,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] i386: Simplify smp_call_function*() by using common implementation
Message-ID: <20070316083252.GA21418@elte.hu>
References: <45F5FA97.8070705@goop.org> <20070315110805.262e1fa3.akpm@linux-foundation.org> <45F9D5DD.8040909@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F9D5DD.8040909@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Subject: Simplify smp_call_function*() by using common implementation
> 
> smp_call_function and smp_call_function_single are almost complete 
> duplicates of the same logic.  This patch combines them by 
> implementing them in terms of the more general 
> smp_call_function_mask().

> +	/* Send a message to other CPUs */
> +	if (cpus_equal(mask, allbutself))
> +		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
> +	else
> +		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);

this is a bit ugly, but i guess we cannot do much about it - the 
hardware side handles this in a bit assymetric way too.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
