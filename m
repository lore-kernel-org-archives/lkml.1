Return-Path: <linux-kernel-owner+w=401wt.eu-S939874AbXHIMzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939874AbXHIMzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933882AbXHIMz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:55:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXHIMz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:55:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION (updated 2x)
Date: Thu, 9 Aug 2007 15:04:50 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>,
       Andi Kleen <ak@suse.de>
References: <200708070023.27404.rjw@sisk.pl> <20070808150307.378bf385.akpm@linux-foundation.org>
In-Reply-To: <20070808150307.378bf385.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091504.51976.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 9 August 2007 00:03, Andrew Morton wrote:
> On Tue, 7 Aug 2007 00:23:26 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION introduced by commit
> > 296699de6bdc717189a331ab6bbe90e05c94db06 "Introduce CONFIG_SUSPEND for
> > suspend-to-Ram and standby" are incorrect, as they don't cover the facts that
> > (1) not all architectures support suspend and (2) SMP hibernation is only
> > possible on X86 and PPC64 (if CONFIG_PPC64_SWSUSP is set).
> > 
> > Moreover, SMP suspend and hibernation are only possible if CONFIG_HOTPLUG is
> > set, because they select HOTPLUG_CPU that depends on it. __Also, since suspend
> > and hibernation don't depend on EXPERIMENTAL, arrange things so that CPU
> > hotplug can be selected if it is not set.
> 
> The version of this which I have (version eighty eight, afaict :),
> reproduced below) breaks ia64 allmodconfig:
> 
> init/Kconfig:416:error: found recursive dependency: HOTPLUG -> SUSPEND_SMP_POSSIBLE -> PM_SLEEP_SMP -> HOTPLUG_CPU -> HOTPLUG
>  -> PCCARD -> PCMCIA -> USB_ARCH_HAS_HCD -> MOUSE_APPLETOUCH -> USB -> USB_SISUS

Well, I have no idea how this is even possible.

On ia64 HOTPLUG_CPU depends only on SMP && EXPERIMENTAL and the patch doesn't
change that.  Moreover, SUSPEND_SMP_POSSIBLE cannot be set on ia64, either with the
patch or without it.

Anyway, I'm going to drop the "HOTPLUG depends on PM_SLEEP_SMP" bits and retest
with allmodconfig on everyting I can test.

BTW, the patch is needed to fix compilation problems on PPC.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
