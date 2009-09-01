Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZIABeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZIABeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 21:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZIABen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 21:34:43 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:54688 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbZIABem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 21:34:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19100.31254.666066.755541@pilspetsen.it.uu.se>
Date: Tue, 1 Sep 2009 03:34:14 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
In-Reply-To: <19099.52899.620345.326521@pilspetsen.it.uu.se>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19096.15539.205951.931871@pilspetsen.it.uu.se>
	<19097.14413.89047.384281@pilspetsen.it.uu.se>
	<200908292101.38800.rjw@sisk.pl>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > Rafael J. Wysocki writes:
 >  > On Saturday 29 August 2009, Mikael Pettersson wrote:
 >  > > Mikael Pettersson writes:
 >  > >  > Rafael J. Wysocki writes:
 >  > >  >  > On Thursday 27 August 2009, Mikael Pettersson wrote:
 >  > >  >  > > On Tue, 25 Aug 2009 22:34:53 +0200 (CEST), Rafael J. Wysocki wrote:
 >  > >  >  > > > The following bug entry is on the current list of known regressions
 >  > >  >  > > > from 2.6.30.  Please verify if it still should be listed and let me know
 >  > >  >  > > > (either way).
 >  > >  >  > > > 
 >  > >  >  > > > 
 >  > >  >  > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14015
 >  > >  >  > > > Subject		: pty regressed again, breaking expect and gcc's testsuite
 >  > >  >  > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 >  > >  >  > > > Date		: 2009-08-14 23:41 (12 days old)
 >  > >  >  > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125029329805643&w=3D4
 >  > >  >  > > 
 >  > >  >  > > Not fixed. With 2.6.31-rc7 I'm still seeing repeatable testsuite
 >  > >  >  > > failures on powerpc64. Reverting to 2.6.30 makes the failures go away.
 >  > >  >  > 
 >  > >  >  > Thanks for the update.
 >  > >  >  > 
 >  > >  >  > I guess 2.6.31-rc8 doesn't make any difference, does it?
 >  > >  > 
 >  > >  > I've scheduled a number of gcc bootstraps and testsuite runs
 >  > >  > with -rc8 on x86, powerpc64, and arm. I'll post an update in
 >  > >  > a day or so.
 >  > > 
 >  > > 2.6.31-rc8 results in bogus testsuite failures on all three platforms.
 >  > 
 >  > That may be a result of the known inotify borkage in -rc8 that has been fixed
 >  > in the current Linus' tree.
 > 
 > No, it's the same old semi-random pty breakage. My kernels are built
 > without inotify.
 > 
 > A bisection has identified Alan's
 > 
 > pty: Rework the pty layer to use the normal buffering logic
 > d945cb9cce20ac7143c2de8d88b187f62db99bdc 
 > 
 > as the culprit. This patch introduces a massive number of bogus
 > failures in the gcc testsuite. Subsequent pty/tty patches do fix
 > most of those failures, but clearly not all.

Starting with 2.6.31-rc8 and reverting

85dfd81dc57e8183a277ddd7a56aa65c96f3f487 pty: fix data loss when stopped (^S/^Q)
d945cb9cce20ac7143c2de8d88b187f62db99bdc pty: Rework the pty layer to use the normal buffering logic

in that order gives me a kernel that works on both x86 and powerpc64.

So the bug is definitely limited to the pty buffering logic change.
