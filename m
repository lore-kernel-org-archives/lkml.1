Return-Path: <linux-kernel-owner+w=401wt.eu-S936206AbXGZSFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbXGZSFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936015AbXGZSFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:05:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:52412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934793AbXGZSFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:05:16 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
Date: Thu, 26 Jul 2007 14:05:09 -0400
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200707251238.50218.lenb@kernel.org> <200707260026.08183.lenb@kernel.org> <46A8727F.3030005@googlemail.com>
In-Reply-To: <46A8727F.3030005@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261405.09278.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 06:07, Gabriel C wrote:

> > If you feel that your system has been degraded
> > because it now includes what used to be excluded under
> > CONFIG_ACPI_SLEEP=n, please let me know how.
> 
> Even if I want to SUSPEND* to <something> I can't on my Dell Precision 530 boxes , 
> SCSI is broken with suspend therefore all these boxes have the whole SUSPEND* off, 
> all I need is ACPI.

Linux is already way behind the competition on both STR and STD.
Disabling it because it doesn't work will makes this situation
worse, not better.

> So why you think I want to have this all enabled by default now ? 
> Just to bloat the kernel with something doesn't even work for me ?

Can you be specific about how much additional "bloat" your system
must endure with CONFIG_ACPI_SLEEP=y

> >> config ACPI_SLEEP
> >>          select HOTPLUG_CPU if X86 && SMP
> >>          select SUSPEND_SMP if X86 && SMP
> >>
> >> instead of makeing it dependant on ACPI.
> > 
> > If more config options where better, then this
> > would indeed be an improvement over 2.6.22.
> > But more config options isn't better -- except for "some people":-)
> 
> But in this case some config / new config is better.
> 
> I do not need ACPI to SUSPEND but to make the box work properly.

You also don't need a lot of other code in your kernel.

At some point the complexity of supporting more configuration options
out-weights the benefits of having them.  I have a pretty good idea
of the cost of maintaining the code.  So my question to you is
is what, exactly, is the benefit of having 2.6.22 CONFIG_ACPI_SLEEP=y
that is now lost in 2.6.23-git?

> Ohh and isn't better to make 'ACPI_PROCESSOR  select SUSPEND_SMP and HOTPLUG_CPU if X86 && SMP' ?
>
> ...
> 
> config ACPI_PROCESSOR
>         tristate "Processor"
>         default y
>         help
>           This driver installs ACPI as the idle handler for Linux, and uses
>           ACPI C2 and C3 processor states to save power, on systems that
>           support it.  It is required by several flavors of cpufreq
>           Performance-state drivers.
> 
> ...
> 
> Is more logical for me to do it here but I may be wrong.

ACPI_PROCESSOR supports C-states and P-states and is not directly
related to support for system sleep states.  If your system is recent,
then it is likely that you want to enable this (and cpufreq) to save power --
even if you are not interested in system-wide sleep states.

-Len
