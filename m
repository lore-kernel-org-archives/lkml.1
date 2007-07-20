Return-Path: <linux-kernel-owner+w=401wt.eu-S933512AbXGTVYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512AbXGTVYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXGTVYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:24:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50115 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757250AbXGTVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:24:32 -0400
Date: Fri, 20 Jul 2007 17:24:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: david@lang.hm
cc: Milton Miller <miltonm@bga.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ying Huang <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.64.0707201314261.5166@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0707201722060.5241-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 david@lang.hm wrote:

> > Userspace can submit I/O requests.  Someone will have to audit every
> > driver to make sure that such I/O requests don't cause a quiesced
> > device to become active.  If the device is active, it will make the
> > memory snapshot inconsistent with the on-device data.
> 
> assuming this is the suspend-from-ram after a kexec back from the 
> write-to-disk kernel I don't think you are correct.
> 
> when doing a suspend-to-ram you get to a point where you just don't use 
> any userspace.

What do you mean?  How can you prevent user tasks from running?  That's 
basically what the freezer does, and the whole point of this approach 
is to eliminate the freezer.  Right?

> from that point on you are just walking the device tree 
> putting things into low-power mode. This is the point where we are talking 
> about jumping to.

Yes.  And putting things into low-power mode requires the ability to 
run the scheduler, which means that user tasks can be scheduled, which 
means that they can run.

Alan Stern

