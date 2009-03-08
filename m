Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbZCHKl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbZCHKl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZCHKls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:41:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35767 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZCHKlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:41:47 -0400
Date: Sun, 8 Mar 2009 11:41:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86:perf_counter cleanup
Message-ID: <20090308104133.GA3360@elte.hu>
References: <1236507232.28127.2.camel@localhost.localdomain> <1236507643.22914.3642.camel@twins> <1236508753.3638.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236508753.3638.3.camel@localhost.localdomain>
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

> Hello Peter,
> 
> On Sun, 2009-03-08 at 11:20 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-03-08 at 15:43 +0530, Jaswinder Singh Rajput wrote:
> > 
> > > +/*
> > > + * Exported because of ACPI idle
> > > + */
> > >  u64 hw_perf_save_disable(void)
> > >  {
> > >  	if (unlikely(!perf_counters_initialized))
> > > @@ -270,9 +272,6 @@ u64 hw_perf_save_disable(void)
> > >  
> > >  	return pmc_ops->save_disable_all();
> > >  }
> > > -/*
> > > - * Exported because of ACPI idle
> > > - */
> > >  EXPORT_SYMBOL_GPL(hw_perf_save_disable);
> > >  
> > >  static void pmc_intel_restore_all(u64 ctrl)
> > > @@ -301,6 +300,9 @@ static void pmc_amd_restore_all(u64 ctrl)
> > >  	}
> > >  }
> > >  
> > > +/*
> > > + * Exported because of ACPI idle
> > > + */
> > >  void hw_perf_restore(u64 ctrl)
> > >  {
> > >  	if (unlikely(!perf_counters_initialized))
> > > @@ -308,9 +310,6 @@ void hw_perf_restore(u64 ctrl)
> > >  
> > >  	pmc_ops->restore_all(ctrl);
> > >  }
> > > -/*
> > > - * Exported because of ACPI idle
> > > - */
> > >  EXPORT_SYMBOL_GPL(hw_perf_restore);
> > 
> > Please leave those comments where they are, they do not describe the
> > function, but comment on the export.
> 
> Have you checked this:
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=commitdiff;h=1ae843834668af3a30484e256fb27dc1a49f59cb
> 
> These leads to warnings:
>  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

ignore those checkpatch warnings, they are wrong in this case.

> So we have two options:
> 1. which I already shown above
> 2. remove these comments

  3. ignore incorrect warnings

	Ingo
