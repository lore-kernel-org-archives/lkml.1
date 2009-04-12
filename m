Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbZDLKwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbZDLKwB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759253AbZDLKvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:51:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56628 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758920AbZDLKvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:51:51 -0400
Date: Sun, 12 Apr 2009 12:51:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH -tip] x86: apic/x2apic_cluster.c
	x86_cpu_to_logical_apicid should be static
Message-ID: <20090412105132.GA25392@elte.hu>
References: <1239434726.4418.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239434726.4418.24.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Impact: reduce kernel size a bit, avoid sparse warning
> 
> Fixes sparse warning:
>   arch/x86/kernel/apic/x2apic_cluster.c:13:1: warning: symbol 'per_cpu__x86_cpu_to_logical_apicid' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

There is a not so small nit:

> Impact: reduce kernel size a bit, avoid sparse warning
> 
> Fixes sparse warning:

the thing is, we dont 'fix', nor do we 'avoid' Sparse warnings!

We _read_ them, _understand_ them, and then we act upon them, fixing 
the problem they expose.

Or, if there is no problem exposed, we annotate the code to fix the 
Sparse false positive warning.

Your changelog does not tell us anything whether you went through 
that thought process. I had to double-check it and had to create 
this information from scratch.

Please take this as a last warning: you send lots of patches that 
address various things mechanically, often without thinking through 
the effects. They are expensive to maintain, because they cause 
churn and because people often have to do more work accepting them 
than you did creating them!

You sent a hundred patches in two weeks and they are not applied yet 
- and this is why: it is expensive to filter through them and if you 
dont do it we can only do it by simply not taking them all that 
easily. Taking them simply does not scale.

And if you write a hundred patches in two weeks you _really_ have to 
ask yourself whether your quality controls are strong enough before 
emitting them. There are highly productive members of the Linux 
community who only send a dozen patches per _year_.

You really want to avoid the 'also sends clueless patches' 
contributor label, because the only way to deal with such patches as 
a maintainer is to rate-throttle them.

Thanks,

	Ingo
