Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZCHKju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZCHKju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZCHKjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:39:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:37048 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZCHKjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:39:39 -0400
Subject: Re: [git-pull -tip] x86:perf_counter cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236507643.22914.3642.camel@twins>
References: <1236507232.28127.2.camel@localhost.localdomain>
	 <1236507643.22914.3642.camel@twins>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 16:09:13 +0530
Message-Id: <1236508753.3638.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Sun, 2009-03-08 at 11:20 +0100, Peter Zijlstra wrote:
> On Sun, 2009-03-08 at 15:43 +0530, Jaswinder Singh Rajput wrote:
> 
> > +/*
> > + * Exported because of ACPI idle
> > + */
> >  u64 hw_perf_save_disable(void)
> >  {
> >  	if (unlikely(!perf_counters_initialized))
> > @@ -270,9 +272,6 @@ u64 hw_perf_save_disable(void)
> >  
> >  	return pmc_ops->save_disable_all();
> >  }
> > -/*
> > - * Exported because of ACPI idle
> > - */
> >  EXPORT_SYMBOL_GPL(hw_perf_save_disable);
> >  
> >  static void pmc_intel_restore_all(u64 ctrl)
> > @@ -301,6 +300,9 @@ static void pmc_amd_restore_all(u64 ctrl)
> >  	}
> >  }
> >  
> > +/*
> > + * Exported because of ACPI idle
> > + */
> >  void hw_perf_restore(u64 ctrl)
> >  {
> >  	if (unlikely(!perf_counters_initialized))
> > @@ -308,9 +310,6 @@ void hw_perf_restore(u64 ctrl)
> >  
> >  	pmc_ops->restore_all(ctrl);
> >  }
> > -/*
> > - * Exported because of ACPI idle
> > - */
> >  EXPORT_SYMBOL_GPL(hw_perf_restore);
> 
> Please leave those comments where they are, they do not describe the
> function, but comment on the export.

Have you checked this:
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=commitdiff;h=1ae843834668af3a30484e256fb27dc1a49f59cb

These leads to warnings:
 WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
 WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

So we have two options:
1. which I already shown above
2. remove these comments

Please let me know, which option you will prefer.

Thanks,
--
JSR

