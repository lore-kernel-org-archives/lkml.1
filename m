Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbZLGWHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbZLGWHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbZLGWHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:07:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757804AbZLGWHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:07:01 -0500
Date: Mon, 7 Dec 2009 14:06:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <Pine.LNX.4.44L0.0912071652040.15701-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912071403520.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912071652040.15701-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Alan Stern wrote:
> > 
> > Make the USB host controller do its suspend asynchronously. We don't 
> > suspend PCI bridges anyway, iirc (but I didn't actually check). And at 
> > worst, we can make the PCI _bridges_ know about async suspends, and solve 
> > it that way - without actually making any normal PCI drivers do it.
> 
> This sounds suspiciously like pushing the problem up a level and 
> hoping it will go away.  (Sometimes that even works.)

The "we don't suspend bridges anyway" is definitely a "hoping it will go 
away" issue. I think we did suspend bridges for a short while during the 
PM switch-over some time ago, and it worked most of the time, and then on 
some machines it just didn't work at all. Probably because ACPI ends up 
touching registers behind bridges that we closed down etc.

So PCI bridges are kind of special. Right now we don't touch them, and if 
we ever do, that will be another issue.

> In the end it isn't a very big issue.  Using one vs. two passes in 
> dpm_suspend() is pretty unimportant.

I also suspect that even if you do the USB host controller suspend 
synchronously, doing the actual USB devices asynchronously would still 
help - even if it's only "asynchronously per bus" thing. 

So in fact, it's probably a good first step to start off doing only the 
USB devices, not the controller.

		Linus
