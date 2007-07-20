Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbXGTElz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbXGTElz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXGTElq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:41:46 -0400
Received: from [212.12.190.56] ([212.12.190.56]:32969 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750826AbXGTElp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:41:45 -0400
From: Al Boldi <a1426z@gawab.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Hibernation considerations
Date: Fri, 20 Jul 2007 07:40:38 +0300
User-Agent: KMail/1.5
Cc: david@lang.hm, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707181021300.3759-100000@iolanthe.rowland.org> <200707181647.32620.rjw@sisk.pl>
In-Reply-To: <200707181647.32620.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200740.38158.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 18 July 2007 16:29, Alan Stern wrote:
> >
> > Never mind.  It seems clear that this approach will suffer the same
> > drawback as the proposal for removing the freezer from the
> > suspend-to-RAM pathway.  Namely, device drivers will have to be changed
> > to prevent user I/O requests from proceeding while devices are supposed
> > to be quiescent or in a low-power state.
>
> I agree.
>
> > If a driver fails to handle this properly, its device could be
> > reactivated in order to service a user request before the memory
> > snapshot is made.  This could easily ruin the snapshot.
>
> That's why I've been saying for quite some time that we first need to take
> care of the drivers. :-)
>
> IMO we've reached the point at which, whatever we want to do next, the
> drivers are in the way.

Correct, but only if we want ACPI support.  Granted, we need a separation of 
the hibernate/suspend PM functions, but in the absence of ACPI, all we need 
right now are dump/restore routines for the crashkernel.

Next, we should be looking into reducing the kexec'd kernel environment size, 
which currently, at 16MB, is way too big, and even at 1MB would be 
problematic for small systems.

So, ACPI should really be the least of our worries, and the reason why people 
are fixating on ACPI is probably because they have nothing else to fixate 
on.  They probably haven't even tried the kexec patches to appreciate how 
easy the kexec approach is and how little interference APCI represents when 
suspending and resuming.


Thanks!

--
Al

