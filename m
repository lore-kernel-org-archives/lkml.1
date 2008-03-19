Return-Path: <linux-kernel-owner+w=401wt.eu-S933505AbYCSWRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbYCSWRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYCSUrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:47:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57745 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbYCSUrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:47:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and =?iso-8859-1?q?hibernation=09patchset_against?= -rc6)
Date: Wed, 19 Mar 2008 21:47:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200803120129.25585.rjw@sisk.pl> <20080319202323.GA1811@elf.ucw.cz> <47E178FE.6050500@suse.de>
In-Reply-To: <47E178FE.6050500@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192147.08942.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Alexey Starikovskiy wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> >>> Ok, 7c0... is innocent. Reverting not only the mdelay, but also rest
> >>> of drivers/acpi/ec.c patch fixed the
> >>> "rc6-breaks-backlight-in-X-over-lid-close", good.
> >> Can you clarify a bit?
> >>
> >> Do you mean that the full revert of 2c81ce4 that already got committed is 
> >> sufficient for you, or do you need to totally undo everything we've done 
> >> to ec.c since -rc5, and thus also to revert the _other_ revert we did (in 
> >> 4af8e10a6c57e7292862bd1703712f0565c7e429)?
> > 
> > I did some more testing, and realized I was wrong. We need to totally
> > undo everything we've done to ec.c since -rc5... (that has small
> > sideffect of brightness up/down keys no longer working -- regression
> > since 2.6.24, but saves us from "backlight gone after
> > closing/reopening lid" which is _NASTY_ regression from 2.6.25-rc5).
> > 
> > ACPI sucks.
> > 
> > I.e. this patch:
> > 
> > 
> > Revert ec.c to 2.6.25-rc5 state:
> > 
> > * this fixes backlight after closing/reopening the lid while in X on
> > thinkpad x60
> > 
> > * unfortunately it breaks fn-home/end keyboard brightness control
> It should also break volume up/down/mute keys. Essentially all the keys on Thinkpad.
> And it would also be regression to 2.6.24 level.

Well, and what's the underlying issue?

Rafael
