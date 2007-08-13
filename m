Return-Path: <linux-kernel-owner+w=401wt.eu-S971578AbXHMUwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971578AbXHMUwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948215AbXHMUtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:49:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37666 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940897AbXHMUtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:49:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
Date: Mon, 13 Aug 2007 22:59:41 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Meelis Roos <mroos@linux.ee>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
References: <46B9F664.9060600@googlemail.com> <6bffcb0e0708130621s74411866mc07446854fb96cd4@mail.gmail.com> <20070813183503.GA18722@uranus.ravnborg.org>
In-Reply-To: <20070813183503.GA18722@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132259.42937.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 13 August 2007 20:35, Sam Ravnborg wrote:
> On Mon, Aug 13, 2007 at 03:21:54PM +0200, Michal Piotrowski wrote:
> > > >
> > > > The patch changes the warning to a different warning, it's now
> > > > kernel/power/Kconfig:79:warning: 'select' used by config symbol 'PM_SLEEP_SMP' refers to undefined symbol 'HOTPLUG_CPU'
> 
> So we have something like this for ppc:
> 
> config PM_SLEEP_SMP
> 	bool "bla bla"

Plus a couple of "depends on ..." here, which cannot be true.

> 	select HOTPLUG_CPU
> 
> As it is not in my -linus tree it has been added by the referanced patch
> in the text I zapped.
> 
> 
> The warning is generated _independently_ of the actual configuration.
> All it says is that the symbol PM_SLEEP_SMP has a seelct statement
> for an unknown symbol - unknown for this architecture at least.
> 
> Grepping will reveal that HOTPLUG_CPU is not present for ppc and
> the easiet fix here seems to just add it like in the following:
> 
> diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
> index 6bdeeb7..e7bcd57 100644
> --- a/arch/ppc/Kconfig
> +++ b/arch/ppc/Kconfig
> @@ -65,6 +65,10 @@ config GENERIC_BUG
>         default y
>         depends on BUG
>  
> +config HOTPLUG_CPU
> +       bool
> +       default n
> +
>  source "init/Kconfig"
>  
>  menu "Processor"
> 
> [cut'n'paste so whitespace damaged...]
> This will silence the warning...
> 
> 
> Now as PM_SLEEP_SMP requires HOTPLUG_CPU there most be done
> something else to prevent this config symbol to be selected
> otherwise we would end up with a kernel that has HOTPLUG_CPU
> defined even it is not supported.

Well, the issue at hand is that PM_SLEEP_SMP will never be set on this arch
and the warning is printed nevertheless.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
