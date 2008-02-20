Return-Path: <linux-kernel-owner+w=401wt.eu-S1763845AbYBTBAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763845AbYBTBAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbYBTBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:00:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:3863 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759860AbYBTBAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:00:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,378,1199692800"; 
   d="scan'208";a="258642790"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Tue, 19 Feb 2008 17:00:11 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <b6a2187b0802191653q4dfaa32cl96b9278e97606ef0@mail.gmail.com>
In-Reply-To: <b6a2187b0802191653q4dfaa32cl96b9278e97606ef0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191700.12050.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the same poweroff issue on my T61.  It turned out to be related to the 
C state code disabling interrupts when it shouldn't iirc.  Booting 
with 'idle=poll' seems to work around the problem.

The "green screen" problem should be fixed (see the DRM git tree for details).

Jesse

On Tuesday, February 19, 2008 4:53 pm Jeff Chua wrote:
> On Feb 16, 2008 5:00 AM, Greg KH <gregkh@suse.de> wrote:
> > > Also, I've tried CONFIG_DETECT_SOFTLOCKUP=n, but this doesn't fix it
> > > either.
> >
> > Ok, this looks to be something else.
> >
> > > Here's the last dmesg after suspend-to-disk and hang there...
> > >
> > > CPU 1 is now offline
> > > SMP alternatives: switching to UP code
> > > PM: Syncing filesystems ... done.
> > > Freezing user space processes ... (elapsed 0.00 seconds) done.
> > > Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > > PM: Shrinking memory...  ^H-^Hdone (0 pages freed)
> > > PM: Freed 0 kbytes in 0.10 seconds (0.00 MB/s)
> > > ACPI: Preparing to enter system sleep state S4
> > > Suspending console(s)
> > >
> > > [ ... it just hangs here ... press power-switch does the job, and
> > > system is able to resume upon powering on ]
> >
> > Wait, this is a suspend-to-disk issue.  Totally different than the "will
> > not power off" issue.
> >
> > Can you start a new thread on this, and add the suspend people to it?
>
> I bisected down this one commit that causes the problem with
> suspend-to-disk on Lenovo X60s (i945 chipset).
>
> commit ba8bbcf6ff4650712f64c0ef61139c73898e2165
> Author: Jesse Barnes <jesse.barnes@intel.com>
> Date:   Thu Nov 22 14:14:14 2007 +1000
>
>     i915: add suspend/resume support
>
>     Add suspend/resume support to the i915 driver.  Moves some of the
>     initialization into the driver load routine, and fixes up places where
> we assumed no dev_private existed in some of the cleanup paths.  This
> allows us to suspend/resume properly even if X isn't running.
>
>     Signed-off-by: Dave Airlie <airlied@linux.ie>
>
>
> There where problem reverting the some i915 files with the latest
> linux git pull, so I copied those i915*.{h,c} prior to this commit,
> and problem went away.
>
>
> Suspend-to-ram, suspend-to-disk all working now.
>
>
> Thanks,
> Jeff.


