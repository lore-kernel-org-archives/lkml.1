Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYACKpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYACKpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYACKpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:45:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYACKpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:45:44 -0500
Date: Thu, 3 Jan 2008 11:45:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: andreas.herrmann3@amd.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [11/20] x86: Use the correct cpuid method to detect
	MWAIT support for C states
Message-ID: <20080103104526.GC29194@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005006.BE79A14D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005006.BE79A14D40@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> +static int mwait_usable(const struct cpuinfo_x86 *c)
> +{
> +	if (force_mwait)
> +		return 1;
> +	/* Any C1 states supported? */
> +	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
> +}
> +
>  void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
>  {
> -	if (cpu_has(c, X86_FEATURE_MWAIT)) {
> +	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
>  		printk("monitor/mwait feature present.\n");

hm, why not clear FEATURE_MWAIT if it's "not usable"? That's the 
standard approach we do for CPU features that do not work.

	Ingo
