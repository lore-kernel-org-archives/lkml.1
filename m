Return-Path: <linux-kernel-owner+w=401wt.eu-S1763049AbYGaDFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763049AbYGaDFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYGaDE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:04:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbYGaDEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:04:55 -0400
Date: Wed, 30 Jul 2008 20:03:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Fries <david@fries.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] W1: w1 core fixes, ds2490 updates, strong pullup
Message-Id: <20080730200349.81edf43a.akpm@linux-foundation.org>
In-Reply-To: <20080731023702.GA12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
	<20080729161356.2de456fb.akpm@linux-foundation.org>
	<20080731023702.GA12181@spacedout.fries.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 21:37:02 -0500 David Fries <david@fries.net> wrote:

> On Tue, Jul 29, 2008 at 04:13:56PM -0700, Andrew Morton wrote:
> > On Mon, 28 Jul 2008 21:04:33 -0500
> > David Fries <david@fries.net> wrote:
> > 
> > > What follows is a long list of fixes and enhancements to the one wire
> > > system, and even some documentation.
> > > 
> > > I no longer have any deadlocks, a thread was eliminated (along with
> > > its one second wakeup interval), the cpu and time overhead are much
> > > reduced for one wire accesses.  The time for the ds2490 to read a
> > > temperature sensor went from 3.91 seconds (.002s user, 3.001s system)
> > > to 0.860 seconds (0.004s user, 0.004s system).  I also added support
> > > for the strong pullup to provide more current when requested.
> > 
> > This is all dreadfully late for 2.6.27, but it does seem to be rather
> > important, so let's aim for 2.6.27.
> 
> Arguments for sooner: fixes some bad bugs, lower risk as it is
> isolated to the w1 driver.
> 
> Arguments for later, the bugs aren't new, the first version of the
> patch was sent in March and I have yet to get a response from anyone
> using the ds1wm master (in some ARM handhelds for battery readings),
> maybe if it gets in the merge window someone with the hardware will
> actually try it before a kernel release.
> 
> I'm fine with either.

It all seems to fix more than it looks like it breaks ;) Let's shoot
for 2.6.27.

> 
> > Please be aware that this:
> > 
> > Mime-Version: 1.0
> > Content-Type: multipart/signed; micalg=pgp-sha1;
> > 	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
> > 
> > is rather receiver-hostile.  My MUA (at least) (sylpheed) manages to
> > make a complete mess when saving-to-file, so I needed to go through all
> > the patches and do various manual steps to fix this up.  I may still have
> > some "=066"s in the changelogs.
> 
> I would have resubmitted it if you had asked, I'm using mutt, which
> isn't exactly new or unknown, I guess the incompatibility is why
> encryption and signing e-mail hasn't taken taken off as it could have.
> There are some problems left in the changelog.
> 
> How about one tar.gz?

eek, terror. Lots of error-prone handwork is needed for that.

One patch per text/plain email is always preferred, please.  That's
what everyone's automation is designed for.

> > WARNING: consider using strict_strtol in preference to simple_strtol
> 
> > Please use checkpatch.
> 
> I did use checkpatch.pl, simple_strtol was the only warning (I ignored
> it to be consistent, the fix follows).  strict_strtol is safe here as
> it only reads one integer from sysfs.  The patch didn't change,
> checkpatch.pl did, I've updated to that as well.
> 
> 
> The next set of patches has these minor updates, and checkpatch.pl
> returns no errors or warnings.
> 
> 0005-W1-feature-enable-hardware-strong-pullup.txt
> Switch to strict_strtol, code style fixups.
> 
> 0017-W1-w1_io.c-reset-comments-and-msleep.txt
> Fix changelog long lines.
> 
> 0020-W1-ds2490.c-add-support-for-strong-pullup.txt
> Whitespace code style fixups.
> 
> 0030-W1-ds2490.c-optimize-ds_set_pullup.txt
> Whitespace code style fixups.

um, OK, I'll do a full drop-and-remerge.
