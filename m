Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXGaGjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXGaGjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXGaGjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 02:39:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51172 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751002AbXGaGjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 02:39:04 -0400
Date: Tue, 31 Jul 2007 08:38:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] create CONFIG_SUSPEND_UP_POSSIBLE
Message-ID: <20070731063833.GD22419@elf.ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <200707292323.29601.rjw@sisk.pl> <alpine.LFD.0.999.0707291717410.3442@woody.linux-foundation.org> <200707302354.23237.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707302354.23237.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Without this change, it is possible to build CONFIG_HIBERNATE
> on all !SMP architectures, but not necessarily their SMP versions.

Did you want to say "CONFIG_SUSPEND"?

> I don't know for sure if the architecture list under SUSPEND_UP_POSSIBLE
> is correct.  For now it simply matches the list for
> SUSPEND_SMP_POSSIBLE.

I do not think it is.

> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  Kconfig |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 412859f..ccf6576 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -72,6 +72,11 @@ config PM_TRACE
>  	CAUTION: this option will cause your machine's real-time clock to be
>  	set to an invalid time after a resume.
>  
> +config SUSPEND_UP_POSSIBLE
> +	bool
> +	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES ||

At least ARM can do suspend, too... probably others. I was under
impression that SUSPEND is "supported" by all the architectures, just
some of them veto it at runtime (using pm_ops or how was it renamed).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
