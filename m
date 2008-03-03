Return-Path: <linux-kernel-owner+w=401wt.eu-S1762018AbYCCXMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762018AbYCCXMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYCCXMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:12:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59287 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750810AbYCCXMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:12:32 -0500
Date: Mon, 3 Mar 2008 18:12:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200803032356.35275.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803031808150.8280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Rafael J. Wysocki wrote:

> > > Perhaps it's better to include dpm_sysfs_add() into device_pm_add(), since we
> > > are going the make the return a result anyway?
> > 
> > Yes.
> 
> Okay, I'll prepare a patch for that, on top of the one introducing the
> 'sleeping' field into 'struct dev_pm_info' (posting in a while).

While you're at it, could you add a field to indicate whether 
begin_sleep() has been called?  It would help prevent multiple calls to 
that method when a race does occur, and it could be useful for drivers 
as well.

> The question remains what we're going to do with the drivers without pm_ops
> pointers in the long run (in the short run we will use the legacy callbacks in
> that cases, if defined).

One possibility is to unbind those drivers at the start of a sleep
transition and reprobe them at the end.  Another possibility is to
ignore the lack of PM support and hope it doesn't cause any problems.

Alan Stern

