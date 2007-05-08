Return-Path: <linux-kernel-owner+w=401wt.eu-S967664AbXEHCzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967664AbXEHCzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 22:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967630AbXEHCzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 22:55:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40845 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967610AbXEHCzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 22:55:20 -0400
Date: Mon, 7 May 2007 19:54:26 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, Greg KH <gregkh@suse.de>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Re: [patch] suspend/resume debugging: device filter
Message-ID: <20070508025426.GA28166@kroah.com>
References: <20070125110501.GA25151@elte.hu> <20070126015536.GA14917@suse.de> <20070505092425.GA23125@elte.hu> <20070505100855.GC25704@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505100855.GC25704@elf.ucw.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 12:08:55PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > Here's a (compile tested only) patch that does this on a per-device 
> > > basis, which is smaller, and should work just as well as your patch.
> > > 
> > > It creates a new file in the power/ directory for every device called 
> > > "can_suspend".  Write a '0' to it to prevent that device from being 
> > > suspended.
> > > 
> > > Does this work for you?
> > 
> > yeah, i was able to use this too to debug suspend/resume problems. But 
> > i've added the check to the resume path too - for example sw-suspend 
> > does a resume of devices during its suspend cycle, cutting off much of 
> > the netconsole output.
> > 
> > which makes the can_suspend flag mis-named - perhaps rename it to 
> > exclude_pm ?
> 
> debug_exclude_pm? I do not want people playing with it, then
> complaining that they broke the suspend.

I can make the attribute only show up if CONFIG_DEBUG_DRIVER is enabled.
Would that be better?  We can also write to the syslog when the
attribute is changed that they just might have broken something.

thanks,

greg k-h
