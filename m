Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbXGPOVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbXGPOVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759782AbXGPOVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:21:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50760 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758126AbXGPOVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:21:41 -0400
Date: Mon, 16 Jul 2007 10:21:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: david@lang.hm
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.64.0707151633240.25614@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0707161015490.3410-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007 david@lang.hm wrote:

> then we need a third mode of operation.
> 
> mode 1: Suspend-to-ram
> 
>    the system is paused and put into a low-power mode but data remains in 
> memory and the system stays awake enough to keep the memory refreshed.
> 
> mode 2: new
> 
>    the system is paused, data is stored to permanent media, and the system 
> is put into a ultra-low power mode.
> 
> mode 3: hibernate
> 
>    the system is paused, data is stored to permanent media, and the system 
> is powered off
> 
> with mode 3 there are no requirements or limitations about what can be 
> done with the hardware before a resume (the resume could even take place 
> on a different piece of identical hardware)
> 
> mode 2 could be what you are talking about doing, although I don't see any 
> advantage of creating it in additon to mode 3, it doesn't use any less 
> power and it locks the system so that it can't be used for anything else 
> in the meantime. I guess if it was significantly faster to do then mode 3 
> there may be _some_ reason to consider it, but I don't see the speed 
> difference.

Part of the problem here is that ACPI already has its own terminology, 
and you're trying to invent a new one instead of using the existing 
one.

I agree, it would be good to have a non-ACPI-specific hibernation mode,
something which would look to ACPI like a normal shutdown.  But I'm not 
so sure this is possible.

You have to understand that the ACPI spec is weird and complex.  The
mere fact that you have written a system image to disk changes the way
ACPI regards the shutdown procedure.  Even though you may treat all the
devices and the rest of the hardware exactly the same, it's a different
operation as far as ACPI is concerned, with different requirements.

Yes, it's bizarre.  Why do you think so many people have complained so 
vehemently about ACPI for all these years?

Alan Stern

