Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbYCFV6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbYCFV6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYCFV6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:58:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55899 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752595AbYCFV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:58:32 -0500
Date: Thu, 6 Mar 2008 16:58:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations
 concurrent with suspend/hibernation
In-Reply-To: <200803062228.28104.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803061656180.19564-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Rafael J. Wysocki wrote:

> > > Well, can it happen in practice?  If it can, then what way can it happen?
> > 
> > Yes, it can happen in practice when a new module is loaded.  In some 
> > ways, modules' init routines are like probe methods.
> 
> Hmm, I'm not sure if it really is possible to load a module when all devices
> have been suspended.  Never mind, though.

You can load the module before devices are suspended, and then its init 
routine can run while the suspend is starting.

> > To be safe, I think we should make system sleep mutually exclusive with 
> > module loading.
> 
> Okay, is the (yet another) version of the patch below fine by you?

Yes, it's fine.  Mutual exclusion with module loading can be added 
later.  (Ironically, it may require putting pm_sleep_rwsem back!)

Alan Stern

