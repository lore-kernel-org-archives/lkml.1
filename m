Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZLRR0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZLRR0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZLRR0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:26:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39548 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753572AbZLRR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:26:46 -0500
Date: Fri, 18 Dec 2009 12:26:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912180251.22655.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912181205290.2987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009, Rafael J. Wysocki wrote:

> I didn't manage to do that, but I was able to mark sd and i8042 as async and
> see the impact of this.

Apparently this didn't do what you wanted.  In the nx6325
sd+i8042+async+extra log, the 0:0:0:0 device (which is a SCSI disk) was
suspended by the main thread instead of an async thread.

There's an important point I neglected to mention before.  Your logs 
don't show anything for devices with no suspend callbacks at all.  
Nevertheless, these devices sit on the device list and prevent other
devices from suspending or resuming as soon as they could.

For example, the fingerprint sensor (3-1) took the most time to resume.  
But other devices were delayed until after it finished because it had
children with no callbacks, and they delayed the devices following
them in the list.

What would happen if you completed these devices immediately, as part 
of the first pass?

Alan Stern

