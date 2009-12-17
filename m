Return-Path: <linux-kernel-owner+w=401wt.eu-S965220AbZLQUGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbZLQUGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759703AbZLQUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:06:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38932 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757870AbZLQUGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:06:10 -0500
Date: Thu, 17 Dec 2009 15:06:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912170249.00676.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912171444040.2645-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Rafael J. Wysocki wrote:

> That actually is correct.  On the nx6325 suspend is totally dominated by disk
> spindown, almost everything else is negligible compared to it (well, except for
> the audio), so we can't go down below 1 s during suspend on this box.
> 
> On the Wind, disk spindown time is comparable with serio suspend time,
> so at least in principle we should be able to get .5 s suspend on this box - 
> if the disk spindown in async.
> 
> In turn, the resume on the Wind is dominated by disk spinup, so we can't
> go below 1.5 s on this box during resume (notice that the "async+extra"
> approach brings us close to this limit, although we could save .5 s more in
> principle by making more devices async).
> 
> Resume on the nx6325 is a different story, though, as it is dominated by USB
> and PCI devices, so marking those as async would probably bring us close to
> the limit.

The implications seem pretty clear.  If the following sorts of devices
were async:

	USB (devices and interfaces), PCI, serio, SCSI (hosts, targets,
	devices)

then we would reap close to the maximum benefit -- providing:

	async threads are started in a first pass without waiting
	for synchronous devices, and

It's not clear that making all these types of devices async will really 
work, but it's worth testing.

Alan Stern

