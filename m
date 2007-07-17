Return-Path: <linux-kernel-owner+w=401wt.eu-S934289AbXGQOVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289AbXGQOVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932777AbXGQOL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:11:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932546AbXGQOL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:11:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 16:18:59 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org> <Pine.LNX.4.64.0707162129090.19248@asgard.lang.hm> <200707171508.06921.a1426z@gawab.com>
In-Reply-To: <200707171508.06921.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171619.00868.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 14:08, Al Boldi wrote:
> david@lang.hm wrote:
> > On Mon, 16 Jul 2007, Al Boldi wrote:
> > > We have to go through ACPI, for wakeup functions to succeed.  A simple
> > > power-off won't do.
> >
> > the kexec switch being posted requires ACPI be disabled, so it's clearly
> > possible to switch kernels and initialize devices without ACPI
> 
> It's a given that kexec works in the absence of ACPI; what we have to handle 
> is the ACPI states across kernel invocations, to ensure wakeup functions 
> succeed.  If you don't need this, then just power off.
> 
> > >> suspend-to-disk-and-ram could be implemented as three
> > >> seperate steps
> > >>
> > >> 1. suspend-to-disk
> > >>
> > >> 2. resume-from-disk
> > >>
> > >> 3. suspend-to-ram
> > >>
> > >> followed by either
> > >>
> > >> 4. resume-from-ram
> > >>
> > >> or
> > >>
> > >> 4. battery dies and loptop powers off completely
> > >>
> > >> 5. power-on boot.
> > >>
> > >> 6. resume-from-disk
> > >>
> > >> all that you need to do is to make sure that the system doesn't run
> > >> anything that would affect permanent media or the outside world between
> > >> steps #2 and #3
> > >
> > > Exactly, which is why your scheme would break down on #3, and that's why
> > > you need to call S3 from within the kexec'd hibernation kernel after
> > > saving the hibernation image.
> >
> > when a kexec is called, how does the kernel know what to execute?
> > something needs to tell it what to do, and I think that something is
> > either something in the kexec image, or it's something passed as a
> > parameter to that image.
> >
> > all that would be needed to do #3 safely is to have the kernel that you
> > restarted on #2 do a suspend-to-ram before it does anything else.
> 
> If you mean by kernel 'the normal kernel', then this won't work, because it 
> would imply a change of state after saving its image.
> 
> If you mean by kernel 'the kexec'd hibernation kernel', then you wouldn't 
> need to do #2, but rather do #3 right after dumping the image in #1.
> 
> [...insert from another post...]
> > > BTW, it would be really helpful if people would actually try the kexec
> > > hibernation patches, as this may yield a much more constructive
> > > discussion.
> >
> > I would love to, but so far I don't see the nessasary pieces
> >
> > once I kexec to the new kernel, how can it find out what pages of memory
> > (and swap) need to be saved?
> 
> No need to save the swap,

Correct.

> all you need to do is to dump /dev/oldmem onto storage,

I'm not sure of that.

> and if that dump image is compatible with swsusp,

No, it's not.  swusp additionally needs to know PFNs to restore the pages into.

> then a normal kernel should be able to resume from this image via
> /dev/snapshot. 

Nope.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
