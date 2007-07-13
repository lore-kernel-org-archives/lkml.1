Return-Path: <linux-kernel-owner+w=401wt.eu-S935936AbXGMPuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935936AbXGMPuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbXGMPuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:50:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39819 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760745AbXGMPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:50:13 -0400
Date: Fri, 13 Jul 2007 11:50:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, <david@lang.hm>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       <nigel@nigel.suspend2.net>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <200707131745.43055.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0707131146340.2555-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:

> Okay, I have thought it through and I think that, as an initial step, we can do
> something like this:
> 
> - preload the image-saving kernel before hibernation
> - in the hibernation code path replace device_suspend() with the shutting down of
>   all devices without unregistering them (not very nice, but should be sufficient
>   for a while)
> - when we've called device_power_down() and save_processor_state(), jump to
>   the image-saving kernel and let it run
> - make the image-saving kernel set up everything, save the image without
>   starting any user space (we may use the existing image-saving code for this
>   purpose, with some modifications) and power off the system (or make it enter
>   S4)
> - use the existing restoration code to load the image and jump to the
>   hibernated kernel
> - in the restore code patch replace device_resume() with the reprobing of all
>   devices.
> 
> Comments?

I doubt that re-probing devices will work.  The probe routine won't 
expect there to be any registered children, so it will try to 
re-register them.

On the other hand, post_restore methods could be written to expect 
something like this.

Alan Stern

