Return-Path: <linux-kernel-owner+w=401wt.eu-S936404AbXGQVg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936404AbXGQVg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936298AbXGQVf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:35:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50531 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936253AbXGQVf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:35:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 23:43:55 +0200
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
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org> <200707172323.51702.rjw@sisk.pl> <Pine.LNX.4.64.0707171414370.2467@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707171414370.2467@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172343.56411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 23:17, david@lang.hm wrote:
> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
> 
> > On Tuesday, 17 July 2007 22:34, david@lang.hm wrote:
> >> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
> >>
> >>> On Tuesday, 17 July 2007 20:32, Alan Stern wrote:
> >>>
> >>>> I'm still not entirely clear on how "suspend-to-both" ought to be
> >>>> handled.  Presumably it will start off as a normal hibernation.  But
> >>>> instead of shutting down, wouldn't the kexec'd kernel return to the
> >>>> original kernel?
> >>>
> >>> No, I think the image-saving kernel should suspend.  Then, on resume the
> >>> platform will go back to it and it will jump back to the hibernated kernel.
> >>>
> >>>> After all, the original kernel knows about all the devices and can put them
> >>>> into a low-power state, while the kexec'd kernel might not have sufficient
> >>>> information.
> >>>
> >>> That's correct, but ...
> >>>
> >>>> But what about the freezer?  The original reason for using kexec was to
> >>>> avoid the need for the freezer.  With no freezer, while the original
> >>>> kernel is busy powering down its devices, user tasks will be free to
> >>>> carry out I/O -- which will make the memory snapshot inconsistent with
> >>>> the on-disk data structures.
> >>>
> >>> ... we can't return to the hibernated kernel unless we are going to cancel the
> >>> hibernation.
> >>
> >> this is where we disagree.
> >>
> >> why not? if all that the hibernated kernel does is to suspend-to-ram and
> >> makes no changes to disks or TCP connections anything that it does do
> >> would be lost if power were to fail and you instead did a restore from
> >> disk.
> >
> > How do you guarantee that no tasks are scheduled when you get back to the
> > hibernated kernel?
> 
> just don't schedule any userspace tasks. all you need to do is to execute 
> the ACPI sleep functions. you normally do that after stopping userspace 
> anyway.

This is plain reinventing the freezer under another guise, sorry. ;-)

> >> there is only a problem if something takes place that would prevent the
> >> restore-from-disk from working. if this is done in a non-ACPI way that
> >> will work across a power cycle you don't have to worry about the hardware
> >> state not matching anyway.
> >>
> >>> That's why I think that for the suspend-to-both the image-saving kernel will
> >>> need to support the same set of devices as the hibernated kernel.
> >>
> >> suspend-to-both doesn't really make sense if the suspend-to-disk portion
> >> is useing the ACPI S4 mode.
> >
> > Well, not exactly.  If your battery runs out of power while you're suspended,
> > but you have the image saved, it's still better to restore from the image, even
> > if something may not work correctly after the restore, than to risk a loss of
> > data.
> 
> if things don't work correctly you are still risking the loss of data, the 
> user just doesn't know it.

The experience shows that this is not the case.  The disks usually work (you
have to initialize them without ACPI anyway to load the image, no?).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
