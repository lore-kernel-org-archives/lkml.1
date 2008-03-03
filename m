Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbYCCXTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbYCCXTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYCCXTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:19:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYCCXTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:19:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Tue, 4 Mar 2008 00:18:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <Pine.LNX.4.44L0.0803031808150.8280-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803031808150.8280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803040018.36668.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of March 2008, Alan Stern wrote:
> On Mon, 3 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > > Perhaps it's better to include dpm_sysfs_add() into device_pm_add(), since we
> > > > are going the make the return a result anyway?
> > > 
> > > Yes.
> > 
> > Okay, I'll prepare a patch for that, on top of the one introducing the
> > 'sleeping' field into 'struct dev_pm_info' (posting in a while).
> 
> While you're at it, could you add a field to indicate whether 
> begin_sleep() has been called?  It would help prevent multiple calls to 
> that method when a race does occur, and it could be useful for drivers 
> as well.

That will be added along with the new callbacks.

I'd prefer to do all that in separate patches, so that it's clear what issue is
addressed and how, by each of them.

> > The question remains what we're going to do with the drivers without pm_ops
> > pointers in the long run (in the short run we will use the legacy callbacks in
> > that cases, if defined).
> 
> One possibility is to unbind those drivers at the start of a sleep
> transition and reprobe them at the end.

That sounds promising.

> Another possibility is to ignore the lack of PM support and hope it doesn't
> cause any problems. 

That would be easy, but that's what we do now and there are problems with it.

Thanks,
Rafael
