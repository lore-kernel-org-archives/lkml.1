Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYCSTvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYCSTvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYCSTe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:34:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756126AbYCSTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:34:24 -0400
Date: Wed, 19 Mar 2008 11:48:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, <lenb@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: +
 pm-convert-wakeup-flag-accessors-to-inline-functions-fix.patch added to -mm
 tree
Message-Id: <20080319114829.bf993b72.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0803191033430.4958-100000@netrider.rowland.org>
References: <200803190315.m2J3FXnK029022@imap1.linux-foundation.org>
	<Pine.LNX.4.44L0.0803191033430.4958-100000@netrider.rowland.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 10:55:35 -0400 (EDT) Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 18 Mar 2008 akpm@linux-foundation.org wrote:
> 
> > Subject: pm-convert-wakeup-flag-accessors-to-inline-functions fix
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > ia64 allmodconfig:
> > 
> > In file included from include/linux/device.h:381,
> >                  from include/linux/rtc.h:110,
> >                  from include/linux/efi.h:19,
> >                  from include/asm/sal.h:40,
> >                  from include/asm-ia64/mca.h:20,
> >                  from arch/ia64/kernel/asm-offsets.c:17:
> > include/linux/pm_wakeup.h: In function `device_init_wakeup':
> > include/linux/pm_wakeup.h:35: error: structure has no member named `should_wakeup'
> > include/linux/pm_wakeup.h: In function `device_set_wakeup_enable':
> > include/linux/pm_wakeup.h:45: error: structure has no member named `should_wakeup'
> > include/linux/pm_wakeup.h: In function `device_may_wakeup':
> > include/linux/pm_wakeup.h:50: error: structure has no member named `should_wakeup'
> > 
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Greg KH <greg@kroah.com>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Len Brown <lenb@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  include/linux/pm_wakeup.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff -puN include/linux/pm_wakeup.h~pm-convert-wakeup-flag-accessors-to-inline-functions-fix include/linux/pm_wakeup.h
> > --- a/include/linux/pm_wakeup.h~pm-convert-wakeup-flag-accessors-to-inline-functions-fix
> > +++ a/include/linux/pm_wakeup.h
> > @@ -25,7 +25,7 @@
> >  # error "please don't include this file directly"
> >  #endif
> >  
> > -#ifdef CONFIG_PM
> > +#ifdef CONFIG_PM_SLEEP
> >  
> >  /* changes to device_may_wakeup take effect on the next pm state change.
> >   * by default, devices should wakeup if they can.
> 
> This is completely wrong.
> 
> Andrew, I don't know what happened.  But if you go back and compare my
> original patch to the
> pm-make-wakeup-flags-available-whenever-config_pm-is-set patch you
> actually applied, you'll see that you managed to leave out a hunk.  
> Possibly because of a conflict with one of Rafael's patches affecting 
> the same area of code.
> 
> Here's a URL for that patch as rebased by Rafael:
> 
> 	http://marc.info/?l=linux-kernel&m=120528034413861&w=2

But there was a patch with the same title from yourself sent four days
later, which is what I merged.

Plus Greg has been merging and dropping older versions under our feet and
maybe Len has too.

> The very first hunk in that patch makes the should_wakeup flag
> available always, not just when CONFIG_PM_SLEEP is set.  If you go back
> and import it with that first hunk intact then there should be no need 
> for this "fix" patch.

> (In order to do this, you'll first have to revert
> pm-convert-wakeup-flag-accessors-to-inline-functions.patch and then
> re-apply it afterward, because it depends on this one.)

<shudder>

I'll drop everything, let's start again.

Only how?  umm, please review Greg's driver tree, let us know which patches
shoudl be dropped from that then send new ones, I guess.
