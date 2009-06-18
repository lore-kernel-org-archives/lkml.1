Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZFRJNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZFRJNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZFRJNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:13:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44171 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbZFRJNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:13:40 -0400
Date: Thu, 18 Jun 2009 11:13:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/6] perf_counter: tools: Makefile tweaks for 64-bit
	powerpc
Message-ID: <20090618091334.GB21191@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <19000.55666.866148.559620@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19000.55666.866148.559620@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> This also removes the -Werror flag when building on a 64-bit powerpc
> machine.  The userspace definition of u64 is unsigned long rather
> than unsigned long long, meaning that gcc warns every time a u64
> is printed with %Lx or %llx (though that does work properly).
> In future we may use PRI64 etc. for printing 64-bit quantities,
> which would eliminate these warnings.

> +# Don't use -Werror on ppc64; we get warnings due to using
> +# %Lx formats on __u64, which is unsigned long.
> +Werror := -Werror
> +ifeq ($(uname_M),ppc64)
> +  Werror :=
> +endif

Note, i left out this bit from the commit - we need to find a better 
solution than to allow ugly warnings on PowerPC.

Could we use the kernel's u64 type directly perhaps? That would 
allow us to change all __u64 to u64 in all of tools/perf/ which is a 
nice clean-up in any case.

	Ingo
