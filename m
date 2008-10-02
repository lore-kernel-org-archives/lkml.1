Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYJCBbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYJCBbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 21:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbYJCBbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 21:31:14 -0400
Received: from ozlabs.org ([203.10.76.45]:60463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbYJCBbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 21:31:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: clean up speedctep-centrino and reduce cpumask_t usage
Date: Thu, 2 Oct 2008 15:05:21 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, Dave Jones <davej@redhat.com>
References: <200810010901.55127.rusty@rustcorp.com.au> <20081001064401.GA31855@elte.hu>
In-Reply-To: <20081001064401.GA31855@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021505.21946.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008 16:44:01 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
> > 2) The loop can simply skip over offline cpus, rather than creating a tmp
> > mask. 3) set_mask is set to either a single cpu or all online cpus in a
> > policy. Since it's just used for set_cpus_allowed(), any offline cpus in
> > a policy don't matter, so we can just use cpumask_of_cpu() or the
> > policy->cpus.
> >
> > Note: untested, since I don't have such a system.
> >
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> nice cleanup! (Dave Jones Cc:-ed)

One interesting side effect of making onstack cpumasks harder to use is that 
people will put effort into avoiding them.  So far many have been an 
arbitrary implementation choice rather than a fundamental requirement for a 
mask.

> maybe it's better to keep this in the cpumask_t series though, to not
> complicate logistics?

Yeah, I'll keep it for the moment for simplicity; it's really orthogonal, so 
don't really mind.

> > diff -r dc205c205c8a arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
> > --- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c	Sun Sep 28
> > 18:04:20 2008 +1000 +++
> > b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c	Sun Sep 28 18:05:58
> > 2008 +1000
>
> ( minor technical request: could you please change your patch scripts to
>   include the diffstat too? )

Oops, my bad.  They do, but this patch was manual :)

Thanks,
Rusty.
