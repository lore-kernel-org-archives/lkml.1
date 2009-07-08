Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZGHV3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZGHV3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZGHV3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:29:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42605 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZGHV3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:29:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 8)
Date: Wed, 8 Jul 2009 23:29:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907081707090.22618-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907081707090.22618-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907082329.51795.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, Alan Stern wrote:
> On Wed, 8 Jul 2009, Rafael J. Wysocki wrote:
> 
> > > I thought you wanted to avoid this sort of complication.
> > 
> > I did, but there might be some benefits.  For example, the timer and the work
> > structure provided by dev.power can be used for scheduling such operations
> > if they are defined at the core level.
> > 
> > Suppose your device has 3 low power states D1 - D3 (like PCI) and you want it
> > to go into D1 first, then, after a delay, to D2 and finally, again after a
> > delay, to D3.  Of course, if there's a resume in the meantime, it should cancel
> > whichever transition is in progress.
> > 
> > pm_runtime_suspend() can be used for the first transition, but the bus type or
> > driver will have to provide its own mechanics for going down to D2 and D3,
> > which must be synchronized with its ->runtime_resume().  That might be tricky
> > and the core already has what's necessary (well, almost).
> 
> Maybe we can provide a way for drivers to set up their own timer 
> callback or work routine for use while the status is RPM_SUSPENDED.

Agreed.

Anyway, I don't think it's really necessary in the Magnus' usage case, as
you pointed out earlier in this thread, so I think we can consider it as
something to add in future.

The current patch is already more that 1200 lines and there's some
documentation to add, so I wouldn't like to make it any bigger. :-)

Best,
Rafael
