Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbXKTO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbXKTO6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXKTO6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:58:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51725 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753852AbXKTO6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:58:14 -0500
Date: Tue, 20 Nov 2007 09:58:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Huang, Ying" <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: [PATCH 3/3 -mm] kexec based hibernation -v6:
 kexec hibernate/resume
In-Reply-To: <1195527033.11955.50.camel@caritas-dev.intel.com>
Message-ID: <Pine.LNX.4.44L0.0711200949590.3931-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Huang, Ying wrote:

> - What is the difference between PMSG_SUSPEND and PMSG_FREEZE?

SUSPEND means that the system is about to go into a low-power state, so 
the driver should take the appropriate action to reduce the device's 
power consumption.  It should also stop all I/O and DMA to the device.  
Interrupts can remain enabled if the device is supposed to be a wakeup 
source; otherwise they should be disabled.

FREEZE means that the system is going to hibernate, and devices need to
be quiescent (no I/O, no DMA, and no interrupts) so that an atomic
memory snapshot can be captured.  The driver should take the
appropriate action to quiesce the device but the power level doesn't
need to change.

PRETHAW means that the system is going to resume from hibernation by
loading a previously-saved memory snapshot.  The driver should take the
appropriate action to quiesce the device (no I/O, no DMA, and no
interrupts) so that the snapshot can be safely restored, but the power
level doesn't need to change.  The driver may also want to put the
device into a special state so that the saved kernel's resume method
will recognize the device has undergone a hibernation cycle and needs
to be reinitialized.

Alan Stern

