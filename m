Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZFVP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZFVP1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZFVP1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:27:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58687 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbZFVP1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:27:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework for run-time PM of I/O devices
Date: Mon, 22 Jun 2009 17:27:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0906221007140.3081-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906221007140.3081-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906221727.29295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Alan Stern wrote:
> On Sun, 21 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > Seriously, there _are_ places where drivers get bound to device before
> > > those devices are registered.  This happens for example in USB when a
> > > bunch of related interfaces are present in the same physical device.  
> > > When the first interface is registered, its driver binds itself to all
> > > the others even though they haven't been registered yet.
> > 
> > Well, the suspend functions could be protected against that under the
> > assumption that no suspend is possible for resume_counter = 0 (then, the "good
> > to go" value would be -1).
> > 
> > Still, the resume functions start from acquring a spinlock, which is not going
> > to work if that spinlock is uninitialized.
> 
> The initialization needs to be improved.  Most of the code in
> pm_runtime_init() should be called from device_pm_init(), and the rest
> should be moved into a separate pm_runtime_add() routine to be called
> from device_pm_add().

OK

In that case, I think, the initialization of the spinlock and resume_counter
can be put into the thing called by device_pm_init().

> One of the things pm_runtime_add() could do is change the status from 
> RPM_UNREGISTERED to RPM_ACTIVE.

If the status is initially (ie. at the device_pm_init() point) RPM_ACTIVE and
resume_couter is initially 1, what are we going to need RPM_UNREGISTERED for?

Rafael
