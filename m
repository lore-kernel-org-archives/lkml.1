Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZJBVgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZJBVgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZJBVgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:36:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbZJBVgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:36:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Lutomirski <luto@mit.edu>
Subject: Re: High power consumption after suspend/resume cycle
Date: Fri, 2 Oct 2009 23:37:42 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-thinkpad@linux-thinkpad.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <cb0375e10910021044n182d696dy8fd566925e46b134@mail.gmail.com> <cb0375e10910021229x7924ec56o61627ec0f625a70c@mail.gmail.com>
In-Reply-To: <cb0375e10910021229x7924ec56o61627ec0f625a70c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910022337.42283.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Andrew Lutomirski wrote:
> [Adding cc's to linux-pm and linux-acpi and ]
> 
> On Fri, Oct 2, 2009 at 1:44 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> > Hi all-
> >
> > I'm running a git kernel that's slightly newer than 2.6.32-rc1.
> >
> > First, thanks for all the great work everywhere on laptop power
> > consumption -- on my Lenovo X200s, it looks like Linux is getting
> > close to Windows (Windows wins by about 0.7W, except that its power
> > usage frequently spikes since Windows apparently still doesn't know
> > how to sit still and do nothing, whereas Linux's seems more stable.),
> > even running KDE with compositing enabled and
> > while connected to wifi, at least after some tweaking.
> 
> [fixed irrelevant typo above, too.]
> 
> >
> > There's a catch, though: after a suspend/resume cycle, power
> > consumption goes up by over well over a watt.  (On a system that draws
> > about 7 watts before suspending, that's a big deal.)  I've tried
> > turning off X, suspending with 'echo mem > /sys/power/state' to avoid
> > any distro scripts running, and manually restoring SATA power saving
> > settings, but it still happens.  I even tried unbinding e1000e and
> > both USB drivers, unloading the i2400 (wimax) driver, iwlagn, and
> > iwlcore, and it still happens.  This is 100% reproducible, and I'd be
> > happy to test things.
> >
> > This could be a BIOS bug I suppose (although I'm running the latest
> > BIOS), but Windows 7 does not have this problem at all.
> >
> > Any ideas about what to try or what subsystem to blame?

It's quite hard to say.  Most likely one of devices is put into the full power
state during resume and not put back into the low power state it was in before.

That may be a result of the PCI core handling of resume, which puts all devices
into D0 in order to restore their standard config registers and doesn't put
them into low power states afterwards.

If that's really the case, PCI run-time PM should help here once implemented,
although that's going to take some time to achieve.

Thanks,
Rafael
