Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbZLTMys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbZLTMys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZLTMyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:54:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36882 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbZLTMyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:54:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sun, 20 Dec 2009 13:55:45 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912192232360.6618-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912192232360.6618-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912201355.45760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Alan Stern wrote:
> On Sat, 19 Dec 2009, Rafael J. Wysocki wrote:
> 
> > On Friday 18 December 2009, Alan Stern wrote:
> > > On Fri, 18 Dec 2009, Rafael J. Wysocki wrote:
> > > 
> > > > I didn't manage to do that, but I was able to mark sd and i8042 as async and
> > > > see the impact of this.
> > > 
> > > Apparently this didn't do what you wanted.  In the nx6325
> > > sd+i8042+async+extra log, the 0:0:0:0 device (which is a SCSI disk) was
> 
> To be precise, the device is an ATA or SATA disk but it is managed by 
> the sd driver.
> 
> > > suspended by the main thread instead of an async thread.
> > 
> > Hm, that's odd, because there's a noticeable time difference between the
> > two cases in which the sd is sync and async.  I'll look into it further.
> 
> I don't know what the whole story is, but the PID number tells the 
> tale.
> 
> > > There's an important point I neglected to mention before.  Your logs 
> > > don't show anything for devices with no suspend callbacks at all.  
> > > Nevertheless, these devices sit on the device list and prevent other
> > > devices from suspending or resuming as soon as they could.
> > 
> > Unless they are async, that is.
> 
> Yes.  It would be simpler to make them async.  But first we ought to
> know what they are.  Can you add an extra line to the log for such
> devices?

Sure, I'll do that.

> What I'm afraid of is that there might be a "normal" device with a
> "normal" ancestor but with "abnormal" devices in between (where
> "normal" means there is a suspend or resume routine and "abnormal"  
> means all the method pointers are NULL).  I know that this happens when
> there's a USB mass-storage device, for example.  If we complete the
> intermediate devices immediately, then there won't be anything to
> prevent the ancestor from suspending before the device or the device
> from resuming before the ancestor.

I'm afraid of that too.

Rafael
