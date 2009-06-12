Return-Path: <linux-kernel-owner+w=401wt.eu-S934089AbZFLTJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089AbZFLTJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZFLTI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:08:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZFLTI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:08:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Fri, 12 Jun 2009 21:09:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906121027300.2915-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906121027300.2915-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122109.35589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Alan Stern wrote:
> On Fri, 12 Jun 2009, Oliver Neukum wrote:
> 
> > Am Freitag, 12. Juni 2009 04:16:10 schrieb Alan Stern:
> > > What tree constraint?  You mean that the PM core shouldn't allow
> > > devices to suspend unless all their children are suspended?  Why
> > > doesn't it still apply?
> > 
> > Because the hardware doesn't need it.
> 
> But maybe drivers need it.
> 
> > > Remember, when Rafael and I say "suspend" here, we don't mean "go to a
> > > low-power state".  We mean "the PM core calls the runtime_suspend
> > > method".  No matter what actions the link hardware may decide to take
> > > on its own, the PM core will still want to observe the
> > > all-children-suspended restriction when calling runtime_suspend
> > > methods.
> > 
> > No. The core if it insists all children be suspended will not use
> > the hardware's full capabilities.
> 
> That isn't what I said.  The core does not insist that all children be 
> suspended, i.e., be in a low-power state.  It insists only that the 
> children's drivers' runtime_suspend methods have been called.  Those 
> methods are not obligated to put the children in a low-power state.
> 
> > If it leaves such power saving measures to the drivers, latency
> > accounting will be wrong.
> > 
> > > > I think there are devices who can be suspended while children are active
> > > > and devices which can not be. This is an attribute of the device and
> > > > should be evaluated by the core.
> > >
> > > Clearly it should be decided by the driver.  Should there be a bit for
> > > it in the dev_pm_info structure?
> > 
> > Yes.
> 
> That would resolve the issue.

So, are you suggesting that the core should only check the "all children
suspended" condition if special flag is set in dev_pm_info?

Best,
Rafael
