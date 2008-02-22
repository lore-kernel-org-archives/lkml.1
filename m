Return-Path: <linux-kernel-owner+w=401wt.eu-S1764620AbYBVNHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764620AbYBVNHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYBVNGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:06:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44146 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYBVNGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:06:51 -0500
Date: Fri, 22 Feb 2008 14:06:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off
	aftersuspend-to-disk. Screen becomes green.
Message-ID: <20080222130615.GA29123@elte.hu>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211302.27002.jesse.barnes@intel.com> <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com> <200802211623.55450.jesse.barnes@intel.com> <b6a2187b0802211642i17730ccav6744b614c086df72@mail.gmail.com> <20080222103727.GA25781@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222103727.GA25781@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> The s2ram command has a built-in whitelist used to set up video 
> rePOSTing. If you want to test, reboot and do
> 
> echo mem >/sys/power/state
> 
> without i915 being loaded. If you get a console back on resume then 
> the platform is reinitialising video for you, but otherwise it's your 
> userspace.

btw., why isnt there an in-kernel whitelist, with perhaps a dynamic, 
convenient /debug/s2r/whitelist append-API for distros (and testers) to 
add more entries to the whitelist/blacklist? (for cases where the kernel 
whitelist has not caught up yet) Which would eventually converge to 
Utopia: s2ram that just works out of box.
 
This would be a lot more flexible (people could even temporarily extend 
the whitelist via rc.local if need to be, etc.), a lot more robust and a 
lot more user friendly than the "dont use /sys/power/state, rely on some 
user-space tool to work around bugs" approach.

Really, i couldnt make the s2ram API/quirks situation much worse even if 
i deliberately tried to design the whole code to be as hard to use and 
as confusing as possible :-/ These types of half-kernel half-userspace 
solutions usually result in constant finger-pointing and constant lag, 
and they result in about the crappiest user experience that is possible 
to achieve physically.

( Sorry about the strong words, while there's lots of good and positive
  development lately i havent seen much change in this particular area
  of s2ram in the past 1-2 years, and the whole chain is only as strong
  as the weakest link - so someone finally has to deliver this message
  to the cozy fire of s2r hackers while our testers and users are 
  standing out in the cold rain ... )

	Ingo
