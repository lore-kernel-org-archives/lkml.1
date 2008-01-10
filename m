Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbYAJRET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbYAJRET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbYAJREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:04:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49966 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755408AbYAJREH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:04:07 -0500
Date: Thu, 10 Jan 2008 12:04:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801101759.10701.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801101202470.2727-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Rafael J. Wysocki wrote:

> > > > > > Also, the kerneldoc for destroy_suspended_device() should contain an 
> > > > > > extra paragraph warning that the routine should never be called except 
> > > > > > within the scope of a system sleep transition.  In practice this means 
> > > > > > it has to be directly or indirectly invoked by a suspend or resume 
> > > > > > method.
> > > > > 
> > > > > Or by a CPU hotplug notifier (that will be the majority of cases, IMO).
> > > > 
> > > > In your patch the call is made in response to a CPU_UP_CANCELED_FROZEN
> > > > notification.  Isn't it true that this notification is issued only as
> > > > part of a system sleep transition?
> > > 
> > > Yes, it is.
> > 
> > So it counts as being indirectly invoked by a resume method.
> 
> Rather, by the resume core.  Technically, it's invoked by
> enable_nonboot_cpus(), which is not a resume method literally.

Okay, then the routine should only be called directly or indirectly 
from a suspend or resume method or from the suspend or resume core.

Alan Stern

