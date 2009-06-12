Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbZFLOcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbZFLOcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbZFLOcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:32:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32885 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754921AbZFLOcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:32:00 -0400
Date: Fri, 12 Jun 2009 10:32:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906121015.19504.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0906121027300.2915-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Oliver Neukum wrote:

> Am Freitag, 12. Juni 2009 04:16:10 schrieb Alan Stern:
> > What tree constraint?  You mean that the PM core shouldn't allow
> > devices to suspend unless all their children are suspended?  Why
> > doesn't it still apply?
> 
> Because the hardware doesn't need it.

But maybe drivers need it.

> > Remember, when Rafael and I say "suspend" here, we don't mean "go to a
> > low-power state".  We mean "the PM core calls the runtime_suspend
> > method".  No matter what actions the link hardware may decide to take
> > on its own, the PM core will still want to observe the
> > all-children-suspended restriction when calling runtime_suspend
> > methods.
> 
> No. The core if it insists all children be suspended will not use
> the hardware's full capabilities.

That isn't what I said.  The core does not insist that all children be 
suspended, i.e., be in a low-power state.  It insists only that the 
children's drivers' runtime_suspend methods have been called.  Those 
methods are not obligated to put the children in a low-power state.

> If it leaves such power saving measures to the drivers, latency
> accounting will be wrong.
> 
> > > I think there are devices who can be suspended while children are active
> > > and devices which can not be. This is an attribute of the device and
> > > should be evaluated by the core.
> >
> > Clearly it should be decided by the driver.  Should there be a bit for
> > it in the dev_pm_info structure?
> 
> Yes.

That would resolve the issue.

Alan Stern

