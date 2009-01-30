Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZA3PRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZA3PRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbZA3PRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:17:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZA3PRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:17:25 -0500
Date: Fri, 30 Jan 2009 16:17:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86/powernow: fix cpus_allowed brokage when acpi=off
Message-ID: <20090130151701.GD27549@elte.hu>
References: <498136FC.2020206@kernel.org> <200901301210.48352.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901301210.48352.rusty@rustcorp.com.au>
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

> On Thursday 29 January 2009 15:26:28 Yinghai Lu wrote:
> > 
> > Impact: fix current->cpus_allowed overwriting.
> ...
> > caused by
> > | commit 2fdf66b491ac706657946442789ec644cc317e1a
> > | Author: Rusty Russell <rusty@rustcorp.com.au>
> > | Date:   Wed Dec 31 18:08:47 2008 -0800
> > |
> > |    cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var_t
> 
> Hi Yinghai!
> 
>    Indeed; Mike, that contained a bad conversion of 
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c.
> 
>    This patch reverts the bad change (this code should still be converted
> to work_on_cpu of course, but that's a bigger change).
> 
>    Yinghai, as far as I can tell your other fixes are independent (and
> were a problem before this commit, yes?).  Can you re-submit them on top
> of this patch (which is for Ingo, but against latest Linus).
> 
> Subject: cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
> 
> Impact: fix powernow-k8 when acpi=off (or other error).
> 
> There was a spurious change introduced into powernow-k8 in this patch:
> the cause if that we try to "restore" the cpus_allowed we never saved.
> 
> See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
> acpi=off" from Yinghai for the bug report.
> 
> Cc: Mike Travis <travis@sgi.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

applied to tip/x86/urgent, thanks guys!

Dave, is it fine if we send the fix to Linus via this route - or would you 
like to do it yourself?

	Ingo
