Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYCZOkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYCZOkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYCZOk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:40:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57000 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751925AbYCZOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:40:28 -0400
Date: Wed, 26 Mar 2008 10:40:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level
 =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
In-Reply-To: <200803261524.18300.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0803261032140.4969-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Oliver Neukum wrote:

> Am Mittwoch, 26. März 2008 15:10:01 schrieb Alan Stern:
> > > > IMO you must always keep the ordering invariant. If a parent returns an error
> > > > the PM core must not wake its children.
> > 
> > Don't think of it that way.  The PM core doesn't wake anything.  It
> > merely notifies drivers that the system sleep is ending, so that the
> > drivers can wake their devices.  It's up to the driver to detect
> > whether the parent failed to resume, in which case the driver should
> > take appropriate action.
> 
> How do you propose that every driver should check the power state
> of its parent? Without locking the parent?

It depends entirely on the driver and subsystem; generalizations are 
not possible.  When appropriate, they can copy the scheme used by USB.  
Or they can make up their own scheme.

> > The situation is no different from what happens when the user tries to 
> > access a mounted USB disk drive after the USB cable has been unplugged.  
> > The drivers take care of everything.
> 
> That completely throws away the reason to have a PM core.

Nonsense.

>  We've made
> a guarantee to drivers that they wil not be woken unless their parents are
> awake.

No we haven't.  The guarantee is only that the PM core will call the 
parent's resume method before calling the child's method.  There is no 
guarantee about whether the method succeeds or the parent is awake.

Remember, the whole purpose of this is to let drivers know when the 
system is going to sleep or waking up.  Proper handling of devices is 
up to the drivers, not up to the core.

>  In fact the semantics of the callbacks are defined in a way that
> adding devices to a parent can be enabled. You cannot add children to a
> dead parent.

Depends what you mean.  In some cases it is possible -- i.e., you can
do it and the kernel won't crash, although the new children probably
won't be usable.  In any case it doesn't matter; the PM core doesn't
care whether children are added to a dead parent, only drivers care.

> It's the very reason for this rewrite.

No it isn't.  See Rafael's changelog ocmments; the rewrite is being 
done for completely different reasons.

Alan Stern

