Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYBVQMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYBVQMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbYBVQMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:12:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbYBVQMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:12:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Date: Fri, 22 Feb 2008 17:10:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <20080222103727.GA25781@srcf.ucam.org> <20080222130615.GA29123@elte.hu>
In-Reply-To: <20080222130615.GA29123@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221710.58211.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of February 2008, Ingo Molnar wrote:
> 
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > The s2ram command has a built-in whitelist used to set up video 
> > rePOSTing. If you want to test, reboot and do
> > 
> > echo mem >/sys/power/state
> > 
> > without i915 being loaded. If you get a console back on resume then 
> > the platform is reinitialising video for you, but otherwise it's your 
> > userspace.
> 
> btw., why isnt there an in-kernel whitelist, with perhaps a dynamic, 
> convenient /debug/s2r/whitelist append-API for distros (and testers) to 
> add more entries to the whitelist/blacklist? (for cases where the kernel 
> whitelist has not caught up yet) Which would eventually converge to 
> Utopia: s2ram that just works out of box.
>  
> This would be a lot more flexible (people could even temporarily extend 
> the whitelist via rc.local if need to be, etc.), a lot more robust and a 
> lot more user friendly than the "dont use /sys/power/state, rely on some 
> user-space tool to work around bugs" approach.
> 
> Really, i couldnt make the s2ram API/quirks situation much worse even if 
> i deliberately tried to design the whole code to be as hard to use and 
> as confusing as possible :-/ These types of half-kernel half-userspace 
> solutions usually result in constant finger-pointing and constant lag, 
> and they result in about the crappiest user experience that is possible 
> to achieve physically.
> 
> ( Sorry about the strong words, while there's lots of good and positive
>   development lately i havent seen much change in this particular area
>   of s2ram in the past 1-2 years, and the whole chain is only as strong
>   as the weakest link - so someone finally has to deliver this message
>   to the cozy fire of s2r hackers while our testers and users are 
>   standing out in the cold rain ... )

The problem with the whitelists is that they have to use quite a lot of data to
reliably match the system.  The s2ram whitelist is not 100% reliable, because
it uses too little information to distinguish different versions of the same
machine model, for example.

Plus, in an ideal world, we should be able to match all possible working
graphics/chipset/BIOS combinations and that would be quite a bit of a database.
Also, there are some quirks that need to be run from the user land, AFAICS
(eg. in an i86 real-mode compatible manner).

IMO, whitelisting is not a solution.  It's only a sort-of-working workaround
and as such it shouldn't be put into the kernel.

Thanks,
Rafael
