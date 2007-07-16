Return-Path: <linux-kernel-owner+w=401wt.eu-S1765818AbXGPPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765818AbXGPPV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbXGPPVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:21:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbXGPPVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:21:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jim Crilly <jim@why.dont.jablowme.net>
Subject: Re: Hibernation considerations
Date: Mon, 16 Jul 2007 17:29:15 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <200707151433.34625.rjw@sisk.pl> <200707161406.28539.rjw@sisk.pl> <20070716123849.GC14212@grifter.jdc.home>
In-Reply-To: <20070716123849.GC14212@grifter.jdc.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161729.16440.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 16 July 2007 14:38, Jim Crilly wrote:
> On 07/16/07 02:06:27PM +0200, Rafael J. Wysocki wrote:
> > On Monday, 16 July 2007 01:49, david@lang.hm wrote:
> > > On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:
> > > 
> > > > On Monday, 16 July 2007 00:42, david@lang.hm wrote:
> > > >> On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:
> > > >>
> > > >>> On Sunday, 15 July 2007 22:13, david@lang.hm wrote:
> > > >>>> On Sun, 15 Jul 2007, Rafael J. Wysocki wrote:
> > > >>>>
> > > >>>>>    The ACPI specification requires us to invoke some global ACPI methods
> > > >>>>>    during the hibernation and during the restore.  Moreover, the ordering of
> > > >>>>>    code related to these ACPI methods may not be arbitrary (eg. some of
> > > >>>>>    them have to be executed after devices are put into low power states etc.).
> > > >>>>
> > > >>>> for a pure hibernate mode, you will be powering off the box after saving
> > > >>>> the suspend image. why are there any special ACPI modes involved?
> > > >>>
> > > >>> Because, for example, on my machine the status of power supply (present
> > > >>> vs not present) is not updated correctly after the restore if ACPI callbacks
> > > >>> aren't used during the hibernation.  That's just experience and it's in line
> > > >>> with the ACPI spec.
> > > >>
> > > >> so if a machine is actually powered off the /dev/suspend process won't
> > > >> work?
> > > >
> > > > No, it sort of works as usual, but after the restore the platform is not in the
> > > > correct state.
> > > 
> > > this is not hibernate as I and many others are thinking of it.
> > > 
> > > hibernate as we are thinking would work on basicly any hardware, including 
> > > things with no ACPI or power savings support. and the system could be in 
> > > hibernate mode for any time period.
> > > 
> > > for that matter, after a system is put into hibernate mode the system 
> > > could be completely disassembled and any components replaced and the 
> > > system would work after a resume (assuming you still have access to the 
> > > suspend image)
> > 
> > Well, this is not how ACPI defines the S4 sleep state.  If the system is in
> > S4, that corresponds to our hibernation, you are _not_ allowed to disassemble
> > it.
> > 
> > I've just done an experiment on my test desktop.  I had enabled suspend support
> > in the CMOS setup and afterwards I made Linux hibernate in the "platform" mode.
> > Then, when the system was powred on, the BIOS showed me a nice "Resume from
> > hibernation" screen that is not normally displayed during boot.  This clearly
> > means that some information has been preserved by the platform across the
> > hibernate/restore cycle.  We are supposed to handle that.
> > 
> 
> What I believe he's getting at is that Linux hibernation shouldn't be tied
> to any ACPI states. Yes, when available and working most people will want
> to enter ACPI S4 but we should still have the option of doing a normal
> poweroff. With the latter method it would look just like regular power off/on
> cycle to the firmware. And that would definitely be useful for things like
> working around buggy ACPI implementations or supporting platforms that don't
> do ACPI at all. That is the difference between the platform and shutdown
> options in /sys/power/disk, isn't it?

Yes, but this is not my point.

The point is that there are systems that _require_ the ACPI handling to work
correctly after the restore and we need to that _that_ into consideration.

IOW, there are poeple for whom the non-ACPI framework won't work as expected.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
