Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbZFLCQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbZFLCQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 22:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZFLCQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 22:16:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38132 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753864AbZFLCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 22:16:08 -0400
Date: Thu, 11 Jun 2009 22:16:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906112305.49232.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0906112210340.21931-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Oliver Neukum wrote:

> Am Donnerstag, 11. Juni 2009 20:36:30 schrieb Alan Stern:
> > > Or abstractly any power saving state that does autoresume in hardware.
> > > In these cases you know that you can enter a powersaving state that
> > > will add X latency.
> > >
> > > In terms of user space API we'll probably add a way for user space
> > > to specify how much latency may be added for power management's sake.
> > > If busses are stacked the "latency budget" has to be handled at core
> > > level. If furthermore states that allow IO but with additional latency
> > > are ignored, the budget will be calculated wrongly.
> >
> > Okay, fine.  What does this have to do with Rafael's work?  Why does
> > setting the status to RPM_SUSPENDED even when a device is not in a
> > low-power state preclude handling buses that automatically change their
> > power state?
> 
> For these cases the tree constraint does not apply.

What tree constraint?  You mean that the PM core shouldn't allow 
devices to suspend unless all their children are suspended?  Why 
doesn't it still apply?

Remember, when Rafael and I say "suspend" here, we don't mean "go to a 
low-power state".  We mean "the PM core calls the runtime_suspend 
method".  No matter what actions the link hardware may decide to take 
on its own, the PM core will still want to observe the 
all-children-suspended restriction when calling runtime_suspend 
methods.

> I think there are devices who can be suspended while children are active
> and devices which can not be. This is an attribute of the device and should
> be evaluated by the core.

Clearly it should be decided by the driver.  Should there be a bit for
it in the dev_pm_info structure?

Alan Stern

