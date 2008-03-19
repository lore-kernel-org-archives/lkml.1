Return-Path: <linux-kernel-owner+w=401wt.eu-S937880AbYCSXWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937880AbYCSXWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765650AbYCSV4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:56:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58172 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939350AbYCSV4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:56:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation patchset against -rc6)
Date: Wed, 19 Mar 2008 22:56:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200803172317.33745.rjw@sisk.pl> <20080319205812.GC1811@elf.ucw.cz> <200803192243.14520.rjw@sisk.pl>
In-Reply-To: <200803192243.14520.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192256.25347.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Rafael J. Wysocki wrote:
> On Wednesday, 19 of March 2008, Pavel Machek wrote:
> > On Wed 2008-03-19 23:35:10, Alexey Starikovskiy wrote:
> > > Pavel Machek wrote:
> > >> Hi!
> > >>
> > >>>> Ok, 7c0... is innocent. Reverting not only the mdelay, but also rest
> > >>>> of drivers/acpi/ec.c patch fixed the
> > >>>> "rc6-breaks-backlight-in-X-over-lid-close", good.
> > >>> Can you clarify a bit?
> > >>>
> > >>> Do you mean that the full revert of 2c81ce4 that already got committed is 
> > >>> sufficient for you, or do you need to totally undo everything we've done 
> > >>> to ec.c since -rc5, and thus also to revert the _other_ revert we did (in 
> > >>> 4af8e10a6c57e7292862bd1703712f0565c7e429)?
> > >>
> > >> I did some more testing, and realized I was wrong. We need to totally
> > >> undo everything we've done to ec.c since -rc5... (that has small
> > >> sideffect of brightness up/down keys no longer working -- regression
> > >> since 2.6.24, but saves us from "backlight gone after
> > >> closing/reopening lid" which is _NASTY_ regression from 2.6.25-rc5).
> > >>
> > >> ACPI sucks.
> > >>
> > >> I.e. this patch:
> > >>
> > >>
> > >> Revert ec.c to 2.6.25-rc5 state:
> > >>
> > >> * this fixes backlight after closing/reopening the lid while in X on
> > >> thinkpad x60
> > >>
> > >> * unfortunately it breaks fn-home/end keyboard brightness control
> > > It should also break volume up/down/mute keys. Essentially all the keys on Thinkpad.
> > > And it would also be regression to 2.6.24 level.
> > 
> > As I explained above.
> > 
> > Unfortunately, applying this means I loose screen as soon as I
> > close/reopen lid. 2.6.24 did not behave like that. And it makes my
> > machine mostly unusable -- as soon as you try to carry it away, you
> > loose video. BAD.
> 
> Pavel,
> 
> Can you text the current -git (preferably without anything on top) pretty please?

s/text/test/  (sorry)

Rafael
