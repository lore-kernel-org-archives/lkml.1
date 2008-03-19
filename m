Return-Path: <linux-kernel-owner+w=401wt.eu-S939314AbYCSV4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939314AbYCSV4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYCSUWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:22:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2169 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932594AbYCSUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:22:19 -0400
Date: Wed, 19 Mar 2008 10:55:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, <lenb@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: + pm-convert-wakeup-flag-accessors-to-inline-functions-fix.patch
 added to -mm tree
In-Reply-To: <200803190315.m2J3FXnK029022@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0803191033430.4958-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 akpm@linux-foundation.org wrote:

> Subject: pm-convert-wakeup-flag-accessors-to-inline-functions fix
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> ia64 allmodconfig:
> 
> In file included from include/linux/device.h:381,
>                  from include/linux/rtc.h:110,
>                  from include/linux/efi.h:19,
>                  from include/asm/sal.h:40,
>                  from include/asm-ia64/mca.h:20,
>                  from arch/ia64/kernel/asm-offsets.c:17:
> include/linux/pm_wakeup.h: In function `device_init_wakeup':
> include/linux/pm_wakeup.h:35: error: structure has no member named `should_wakeup'
> include/linux/pm_wakeup.h: In function `device_set_wakeup_enable':
> include/linux/pm_wakeup.h:45: error: structure has no member named `should_wakeup'
> include/linux/pm_wakeup.h: In function `device_may_wakeup':
> include/linux/pm_wakeup.h:50: error: structure has no member named `should_wakeup'
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg KH <greg@kroah.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Len Brown <lenb@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/pm_wakeup.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN include/linux/pm_wakeup.h~pm-convert-wakeup-flag-accessors-to-inline-functions-fix include/linux/pm_wakeup.h
> --- a/include/linux/pm_wakeup.h~pm-convert-wakeup-flag-accessors-to-inline-functions-fix
> +++ a/include/linux/pm_wakeup.h
> @@ -25,7 +25,7 @@
>  # error "please don't include this file directly"
>  #endif
>  
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  
>  /* changes to device_may_wakeup take effect on the next pm state change.
>   * by default, devices should wakeup if they can.

This is completely wrong.

Andrew, I don't know what happened.  But if you go back and compare my
original patch to the
pm-make-wakeup-flags-available-whenever-config_pm-is-set patch you
actually applied, you'll see that you managed to leave out a hunk.  
Possibly because of a conflict with one of Rafael's patches affecting 
the same area of code.

Here's a URL for that patch as rebased by Rafael:

	http://marc.info/?l=linux-kernel&m=120528034413861&w=2

The very first hunk in that patch makes the should_wakeup flag
available always, not just when CONFIG_PM_SLEEP is set.  If you go back
and import it with that first hunk intact then there should be no need 
for this "fix" patch.

(In order to do this, you'll first have to revert
pm-convert-wakeup-flag-accessors-to-inline-functions.patch and then
re-apply it afterward, because it depends on this one.)

Alan Stern

