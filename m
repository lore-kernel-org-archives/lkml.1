Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXGTUMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXGTUMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbXGTUMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:12:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54429 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754340AbXGTUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:12:32 -0400
Date: Fri, 20 Jul 2007 16:12:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Milton Miller <miltonm@bga.com>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <200707202203.27849.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0707201608120.2546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Oliver Neukum wrote:

> Am Freitag 20 Juli 2007 schrieb Alan Stern:
> > Some drivers need the ability to schedule.  Some will need the ability 
> > to allocate memory (although GFP_ATOMIC is probably sufficient).  Some 
> > will need timers to run.
> 
> Some will have to request firmware. It can add up to some megabytes.
> In addition, if we don't freeze, some drivers, eg. video drivers, can
> do allocations in the megabyte range.
> 
> It seems to me that without the freezer we will end up with many drivers
> needing a two step notification process. Furthermore there are requirements
> on the order of shutting down system facilities, eg. device addition must
> be stopped before drivers allocate firmware.

These are really separate issues, since they refer to things that have 
to happen well before the memory snapshot is captured.

We already have a pre-suspend notification available for drivers that 
need to allocate large amounts of memory.

You are correct about the need to delay/stop device addition.  I don't
know how this can be done in general; each code path calling
device_add() may have to be treated individually.

Alan Stern

