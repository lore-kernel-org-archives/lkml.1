Return-Path: <linux-kernel-owner+w=401wt.eu-S1763032AbXGQPzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763032AbXGQPzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXGQPy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:54:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbXGQPy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:54:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 18:02:29 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org> <200707171640.39955.rjw@sisk.pl> <Pine.LNX.4.64.0707170824570.19248@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707170824570.19248@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171802.30903.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 17:29, david@lang.hm wrote:
> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
> 
> > On Tuesday, 17 July 2007 16:15, Alan Stern wrote:
> >> On Mon, 16 Jul 2007 david@lang.hm wrote:
> >>
> >>>> I agree, it would be good to have a non-ACPI-specific hibernation mode,
> >>>> something which would look to ACPI like a normal shutdown.  But I'm not
> >>>> so sure this is possible.
> >>>
> >>> why would it not be possible?
> >>
> >>> I can't think of anything much more frustrating then thinking that I
> >>> suspended a system and then discovering that becouse the battery went dead
> >>> (a complete power loss) that the system wouldn't boot up properly. to me
> >>> this would be a fairly common condition (when I'm mobile I use the machine
> >>> until I am out of battery, then stop and it may be a long time (days)
> >>> before I can charge the thing up again) this would not be a reliable
> >>> suspend as far as I'm concerned.
> >>>
> >>> for suspend-to-ram you have to worry about ACPI states and what you are
> >>> doing with them, for suspend-to-disk you can ignore them and completely
> >>> power the system off instead.
> >>
> >> If the only problem with doing this would be lack of wakeup support
> >> then I'm all for it.  There must be a lot of people who would like
> >> their computers to hibernate with power drain as close to 0 as possible
> >> and who don't care about remote wakeup.  In fact they might even prefer
> >> not to have wakeup support, so the computer doesn't resume at
> >> unexpected times.
> >
> > I'm afraid of one thing, though.
> >
> > If we create a framework without ACPI (well, ACPI needs to be enabled in the
> > kernel anyway for other reasons, like the ability to suspend to RAM) and then
> > it turns out that we have to add some ACPI hooks to it, that might be difficult
> > to do cleanly.
> 
> doing suspend-to-ram should be orthoginal to doing hibernate-to-disk. some 
> people will want both, some won't.
> 
> at the moment kexec doesn't work with ACPI, that is a limitation that 
> should be fixed, but makeing it able to work with ACPI enabled doesn't 
> mean that it needs to be changed to depend on ACPI and it especially 
> doesn't mean that it should pick up the limitations of the existing ACPI 
> based hibernation approaches.
> 
> if there is no ACPI on the system it should work, if ther is ACPI on the 
> system it should still work.
> 
> > Thus, it seems reasonable to think of the ACPI handling in advance.
> 
> but don't become dependant on ACPI.

Not dependent, but with the possibility of ACPI support taken into account.

Arguably you can create a framework that, for example, will not allow the user
to adjust the size of the image, but then adding such a functionality may
require you to change the entire design.  Same thing with ACPI.

I would rather avoid such pitfalls, if I could.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
