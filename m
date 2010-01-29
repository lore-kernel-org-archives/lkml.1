Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354Ab0A2TnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0A2TnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 14:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792Ab0A2TnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 14:43:03 -0500
Received: from netrider.rowland.org ([192.131.102.5]:58257 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752339Ab0A2TnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 14:43:01 -0500
Date: Fri, 29 Jan 2010 14:43:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PM / Runtime: Clean up pm_runtime_disable()
In-Reply-To: <201001291601.37812.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001291435290.23361-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010, Rafael J. Wysocki wrote:

> On Friday 29 January 2010, Alan Stern wrote:
> > On Thu, 28 Jan 2010, Rafael J. Wysocki wrote:
> > 
> > > > > - * If @check_resume is set and there's a resume request pending when
> > > > > - * __pm_runtime_disable() is called and power.disable_depth is zero, the
> > > > > - * function will wake up the device before disabling its run-time PM.
> > > > >   */
> > > > > -void __pm_runtime_disable(struct device *dev, bool check_resume)
> > > > > +void pm_runtime_disable(struct device *dev)
> > > > >  {
> > > > 
> > > > Why did you decide to remove the check_resume argument?  That decision 
> > > > should be explained in the patch description.
> > > 
> > > Well, I thought the "which is not necessary any more" would be a sufficient
> > > explanation ...
> > 
> > But why is it not necessary now,
> 
> Well, all of the existing callers use only one value of it, which is 'false'
> (perhaps I should write that in the changelog).

I don't understand.  Isn't the existing version of pm_runtime_disable()
a caller which sets check_resume to 'true'?  There certainly are places 
that call pm_runtime_disable().

> > given that apparently it was necessary before?  What has changed to make
> > it unnecessary?
> 
> It was used in the system suspend code path in main.c (in dpm_prepare()) IIRC,
> but it was replaced by the current code.
> 
> I don't really think it's useful to try to recall why it was used at one point.
> It's not used now and I don't have a usage case for it.  If no one else knows
> it will be necessary, removing it is the right thing to do.

A particularly important usage case for pm_runtime_disable() is when a
bus subsystem or driver does when resuming from system sleep and the
device was already runtime-suspended when the sleep began.  However in 
this case (and all the other cases I'm aware of) there's no need to 
check whether a resume request is pending before doing the 
runtime_disable.

I wasn't saying that the patch is wrong, just asking the reason for it.

Alan Stern

