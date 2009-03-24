Return-Path: <linux-kernel-owner+w=401wt.eu-S1761849AbZCXOVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761849AbZCXOVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760868AbZCXOMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:12:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34635 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759507AbZCXOL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:11:59 -0400
Date: Tue, 24 Mar 2009 10:11:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Frans Pop <elendil@planet.nl>
cc: linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: avoid PM error messages during resume if a device
 was disconnected
In-Reply-To: <200903232325.04181.elendil@planet.nl>
Message-ID: <Pine.LNX.4.44L0.0903241004160.3162-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Frans Pop wrote:

> > Or do you think maybe it would be better to move this test up into the
> > PM core?  After all, other subsystems will face the same issue.  I
> > think that would be the best approach.  Yes?
> 
> I did look at that option, but implementing it in the USB subsystem seemed
> more logical to me, for example as other subsystems possibly would want to
> display an info message.

They still can...

> And is -ENODEV safe to ignore in all cases? Would there be other errors that
> should be ignored too?

In general, the PM core ignores _all_ errors during resume -- in the
sense that it doesn't try to recover from them or do anything to handle
them.  All it does is put a message in the log.

So your question becomes: For which errors should a message be added to 
the system log?  The most logical answer seems to be that we want an 
error message whenever something bad or unexpected occurs.

Removal of a hot-unpluggable device isn't really bad or unexpected.  
Removal of a non-hot-unpluggable device might be bad, but on the other
hand the system isn't really "hot" while it is suspended.  Besides, the
appropriate subsystem can print an error message.  Furthermore the
kernel can't easily tell which devices are hot-unpluggable and which
aren't.

Anything else amounts to failure resuming a device that still exists.  
As such, it probably deserves an error message.

> if Rafael would be happy with a generic test for -ENODEV, it could be done.
> If not, maybe some other special error code would need to be used but then
> you'd still need to test in the subsystem to set that error.
> Disadvantage is also that it would make resume_device() and related PM
> driver core functions quite a bit less clean than they currently are.
> 
> Implementing the test in USB was quite a bit simpler (for me at least ;-)

We should get Rafael's opinion.

Alan Stern

