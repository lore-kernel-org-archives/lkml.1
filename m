Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZEXTJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZEXTJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZEXTJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:09:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZEXTJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:09:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: INFO: possible circular locking dependency at cleanup_workqueue_thread
Date: Sun, 24 May 2009 21:09:30 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <200905241309.14253.rjw@sisk.pl> <20090524204810.0b70a205@linux-lm>
In-Reply-To: <20090524204810.0b70a205@linux-lm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905242109.31265.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 May 2009, Ming Lei wrote:
> On Sun, 24 May 2009 13:09:13 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday 24 May 2009, Ming Lei wrote:
> > > 于 Sun, 24 May 2009 01:20:29 +0200
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > [lm@linux-lm linux-2.6]$ patch -p1
> > > <  ../patch_rx/INFO_possible_circular_locking_dependency_at_cleanup_workqueue_thread.patch
> > > patching file kernel/power/disk.c Hunk #1 succeeded at 215 with
> > > fuzz 2. Hunk #3 succeeded at 278 with fuzz 1.
> > > Hunk #4 FAILED at 343.
> > > Hunk #5 succeeded at 396 with fuzz 2 (offset -4 lines).
> > > Hunk #6 FAILED at 454.
> > > Hunk #7 succeeded at 485 with fuzz 2.
> > > 2 out of 7 hunks FAILED -- saving rejects to file
> > > kernel/power/disk.c.rej patching file kernel/power/main.c
> > > Hunk #1 succeeded at 289 with fuzz 1 (offset 18 lines).
> > > patching file drivers/base/power/main.c
> > > Hunk #3 succeeded at 616 with fuzz 2.
> > > Hunk #4 succeeded at 625 with fuzz 2.
> > > patching file kernel/kexec.c
> > > Hunk #1 succeeded at 1451 with fuzz 2.
> > > Hunk #2 succeeded at 1488 with fuzz 2.
> > 
> > The patch applies to the mainline, since it'll be a 2.6.30 candidate
> > if it's confirmed to fix the problem.
> 
> After applying the patch against 2.6.30-rc7, my dell d630 box can resume
> from suspend(s2ram) or hibernation successfully, and lockdep does not 
> complain with the kind of message in
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=13245.

OK, great.  I'm going to push the patch to Linus.

> Another thing, during resume from hibernation, I can find the following
> messages:
> 
> 	[    1.849584] device: 'network_throughput': device_add
> 	[    1.849630] PM: Adding info for No Bus:network_throughput
> 	[    1.849788] PM: Resume from disk failed.
>  
> I do not known if there is really something wrong in PM,

No, this only means that there was no hibernation image present on the resume
partition while the kernel was starting.

Thanks,
Rafael
