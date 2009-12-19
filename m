Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZLSVkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZLSVkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 16:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZLSVkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 16:40:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35828 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZLSVkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:40:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sat, 19 Dec 2009 22:41:03 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912181205290.2987-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912181205290.2987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912192241.03991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009, Alan Stern wrote:
> On Fri, 18 Dec 2009, Rafael J. Wysocki wrote:
> 
> > I didn't manage to do that, but I was able to mark sd and i8042 as async and
> > see the impact of this.
> 
> Apparently this didn't do what you wanted.  In the nx6325
> sd+i8042+async+extra log, the 0:0:0:0 device (which is a SCSI disk) was
> suspended by the main thread instead of an async thread.

Hm, that's odd, because there's a noticeable time difference between the
two cases in which the sd is sync and async.  I'll look into it further.

> There's an important point I neglected to mention before.  Your logs 
> don't show anything for devices with no suspend callbacks at all.  
> Nevertheless, these devices sit on the device list and prevent other
> devices from suspending or resuming as soon as they could.

Unless they are async, that is.

> For example, the fingerprint sensor (3-1) took the most time to resume.  
> But other devices were delayed until after it finished because it had
> children with no callbacks, and they delayed the devices following
> them in the list.
> 
> What would happen if you completed these devices immediately, as part 
> of the first pass?

OK.  How do the PM core is supposed to check if a device has null suspend
and resume?  Check all of the function pointers in the first pass?

Rafael
