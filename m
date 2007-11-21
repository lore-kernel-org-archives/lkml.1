Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbXKTXnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbXKTXnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763081AbXKTXmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:42:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46360 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408AbXKTXmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:42:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
       "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [linux-pm] Re: [PATCH 3/3 -mm] kexec based hibernation -v6: kexec hibernate/resume
Date: Wed, 21 Nov 2007 01:00:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: nigel@nigel.suspend2.net, Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0711200949590.3931-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711200949590.3931-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210100.36884.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 of November 2007, Alan Stern wrote:
> On Tue, 20 Nov 2007, Huang, Ying wrote:
> 
> > - What is the difference between PMSG_SUSPEND and PMSG_FREEZE?
> 
> SUSPEND means that the system is about to go into a low-power state, so 
> the driver should take the appropriate action to reduce the device's 
> power consumption.  It should also stop all I/O and DMA to the device.  
> Interrupts can remain enabled if the device is supposed to be a wakeup 
> source; otherwise they should be disabled.
> 
> FREEZE means that the system is going to hibernate, and devices need to
> be quiescent (no I/O, no DMA, and no interrupts) so that an atomic
> memory snapshot can be captured.  The driver should take the
> appropriate action to quiesce the device but the power level doesn't
> need to change.
> 
> PRETHAW means that the system is going to resume from hibernation by
> loading a previously-saved memory snapshot.  The driver should take the
> appropriate action to quiesce the device (no I/O, no DMA, and no
> interrupts) so that the snapshot can be safely restored, but the power
> level doesn't need to change.  The driver may also want to put the
> device into a special state so that the saved kernel's resume method
> will recognize the device has undergone a hibernation cycle and needs
> to be reinitialized.

Exactly.

For this reason, PMSG_SUSPEND should be used right before calling
hibernation_ops->enter() .

Greetings,
Rafael
