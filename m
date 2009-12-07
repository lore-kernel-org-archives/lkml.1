Return-Path: <linux-kernel-owner+w=401wt.eu-S965146AbZLGXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146AbZLGXQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935672AbZLGXQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:16:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56594 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935650AbZLGXQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:16:38 -0500
Date: Mon, 7 Dec 2009 18:16:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912071426100.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912071811300.15701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Linus Torvalds wrote:

> 
> 
> On Mon, 7 Dec 2009, Alan Stern wrote:
> > 
> > There's no need to suspend the individual devices when the whole system 
> > is going down.  They will automatically suspend when the controller 
> > stops sending out SOF packets, which occurs when the root hub is 
> > suspended.  The USB spec describes this, grandiosely, as a "global 
> > suspend".
> 
> Ahh, but the sync vs async would then still matter on resume. No?

That's complicated.  If we assume the devices weren't runtime-suspended 
before the sleep began, then they would automatically resume themselves 
when the controller started transmitting EOF packets.  So in that case 
resume would be fast and async wouldn't matter.

But if the devices were runtime-suspended, then what?  The safest
course is to resume them during the system-wide resume.  In that case
yes, the sync vs async would matter.

And if (as happens on many machines) the firmware messes up the
controller settings during resume, then all the USB devices would have
to be reset -- another slow procedure.

Alan Stern

