Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbYJAGod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbYJAGod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYJAGo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:44:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYJAGoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:44:25 -0400
Date: Wed, 1 Oct 2008 08:44:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] x86: clean up speedctep-centrino and reduce cpumask_t
	usage
Message-ID: <20081001064401.GA31855@elte.hu>
References: <200810010901.55127.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810010901.55127.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> 1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
> 2) The loop can simply skip over offline cpus, rather than creating a tmp mask.
> 3) set_mask is set to either a single cpu or all online cpus in a policy.
>    Since it's just used for set_cpus_allowed(), any offline cpus in a policy
>    don't matter, so we can just use cpumask_of_cpu() or the policy->cpus.
> 
> Note: untested, since I don't have such a system.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

nice cleanup! (Dave Jones Cc:-ed)

maybe it's better to keep this in the cpumask_t series though, to not 
complicate logistics?

> diff -r dc205c205c8a arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
> --- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c	Sun Sep 28 18:04:20 2008 +1000
> +++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c	Sun Sep 28 18:05:58 2008 +1000

( minor technical request: could you please change your patch scripts to 
  include the diffstat too? )

	Ingo
