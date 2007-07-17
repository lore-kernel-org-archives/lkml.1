Return-Path: <linux-kernel-owner+w=401wt.eu-S935946AbXGQTqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946AbXGQTqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760469AbXGQTqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:46:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369AbXGQTqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:46:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 21:54:06 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org> <200707171640.39955.rjw@sisk.pl> <87hco3ypt5.fsf@jbms.ath.cx>
In-Reply-To: <87hco3ypt5.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172154.07703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 18:09, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [snip]
> 
> > I'm afraid of one thing, though.
> 
> > If we create a framework without ACPI (well, ACPI needs to be enabled in the
> > kernel anyway for other reasons, like the ability to suspend to RAM) and then
> > it turns out that we have to add some ACPI hooks to it, that might be difficult
> > to do cleanly.
> 
> > Thus, it seems reasonable to think of the ACPI handling in advance.
> 
> As far as I understand, ACPI support is only useful for hibernate to the
> extent that it allows some or all of the following features:
> 
>  - possibly shows a nice looking "hibernate" LED
>  - possibly allows the BIOS to show something about hibernate
>  - possibly allows the lid or keyboard to "wake up" (turn on) the system
> 
> Note that properly restoring device state (or even properly determining
> whether on external/mains power vs. battery) on resume is not something
> that should require special hibernate ACPI support, since it should be
> possible to make hibernate (and in general it will be the case that
> hibernate will) look exactly like a reboot to the BIOS/ACPI/devices.
> The problem that you mentioned on your system regarding power source
> information would seem to just be a problem with how ACPI is
> reinitialized after resuming from hibernation, which is not at all
> surprising since we know it (the use of driver calls for hibernate) is
> currently broken in many ways.
> 
> It seems that enabling S4 mode should just be treated as a special
> shutdown mode, independent of hibernate.  In practice, it may likely
> only be useful in conjunction with hibernate, but there doesn't seem to
> be any reason it needs to be coupled.
> 
> It would be useful to determine whether it is necessary to initialize
> ACPI specially after "resuming" from S4 mode, though, or whether they
> can be initialized normally (i.e. by a normal kernel for instance,
> completely unaware of hibernate).  If they can be initialized normally,
> then it seems that it is unnecessary to have any ACPI S4 mode support in
> the resume path, and it can merely exist as a special shutdown mode.
> Note that it seems a bit odd if ACPI can't be initialized normally after
> resume from S4 (and still work), since the "load image" kernel
> initializes everything normally before attempting to resume the
> hibernated system.

Unfortunately, this is more complicated (please see my recent reply to David).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
