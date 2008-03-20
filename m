Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYCTWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYCTWgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbYCTWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:36:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:44733 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742AbYCTWgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:36:02 -0400
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <Pine.LNX.4.44L0.0803201412210.22752-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0803201412210.22752-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 09:34:37 +1100
Message-Id: <1206052477.8420.26.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-20 at 14:26 -0400, Alan Stern wrote:
> 
> One of the things we don't want to do is bind a new driver to a device
> after it has gone through the prepare() stage.  Doing so would involve
> calling the driver's probe() routine, which is likely to want to
> register new children and who knows what else.  The probe routine might 
> even end up running after the device was suspended!  Clearly this 
> should be avoided.
> 
> But the user can force a binding to occur by writing the device's path
> to the driver's "bind" attribute in sysfs.  This means that
> driver_bind() in drivers/base/bus.c will need to know whether or not
> the device has gone through the prepare() stage, which means the device
> structure will need to have a flag set before prepare() is called (more 
> precisely, the flag must be set before dev->sem is released following 
> the call to prepare).
> 
> Either that or else driver_bind() must always block whenever a system
> sleep is in progress.  That would be easier -- but it's a lot like what 
> the freezer would do.  Which would you prefer?

I don't fully understand what you are saying here.

You say "bind a new driver to a device after it has gone through the
prepare() stage"

So either there was already a driver bound to that device, which got a
prepare() callback, and in which case bind() doesn't mean much. Or there
was not, in which case there was no prepare() call involved.

I suppose if you prepare(), then unbind(), then something tries to
bind()... But wouldn't the core flag set after prepare() be plenty
enough to shield against that ?

I fail to see the race you are talking about here.

Ben.


