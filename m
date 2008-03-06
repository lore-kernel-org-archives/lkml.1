Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbYCFWb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbYCFWb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbYCFWbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:31:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbYCFWbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:31:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations concurrent with suspend/hibernation
Date: Thu, 6 Mar 2008 23:30:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803061656180.19564-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803061656180.19564-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803062330.28639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 of March 2008, Alan Stern wrote:
> On Thu, 6 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > > Well, can it happen in practice?  If it can, then what way can it happen?
> > > 
> > > Yes, it can happen in practice when a new module is loaded.  In some 
> > > ways, modules' init routines are like probe methods.
> > 
> > Hmm, I'm not sure if it really is possible to load a module when all devices
> > have been suspended.  Never mind, though.
> 
> You can load the module before devices are suspended, and then its init 
> routine can run while the suspend is starting.

Yeah.

> > > To be safe, I think we should make system sleep mutually exclusive with 
> > > module loading.
> > 
> > Okay, is the (yet another) version of the patch below fine by you?
> 
> Yes, it's fine.  Mutual exclusion with module loading can be added 
> later.  (Ironically, it may require putting pm_sleep_rwsem back!)

I'm going to send this patch and the "include dpm_sysfs_add() into
device_pm_add()" patch for -mm/linux-next testing, if you don't mind.

I'm working on a new version of the "PM: Separate suspend and hibernation
callbacks" patch, on top of the two.

Thanks,
Rafael
