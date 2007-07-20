Return-Path: <linux-kernel-owner+w=401wt.eu-S965296AbXGTQe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296AbXGTQe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939658AbXGTQeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:34:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45660 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753599AbXGTQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:34:49 -0400
Date: Fri, 20 Jul 2007 12:20:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Milton Miller <miltonm@bga.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <44037b3d409370919bddd8710e6064fc@bga.com>
Message-ID: <Pine.LNX.4.44L0.0707201216460.3811-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Milton Miller wrote:

> > We can't do this unless we have frozen tasks (this way, or another) 
> > before
> > carrying out the entire operation.
> 
> What can't we do?   We've already worked with the drivers to quesce the 
> hardware and put any information to resume the device in ram.  Now we 
> ask them to put their device in low power mode so we can go to sleep.  
> Even if we schedule, the only thing userspace could touch is memory.   

Userspace can submit I/O requests.  Someone will have to audit every 
driver to make sure that such I/O requests don't cause a quiesced 
device to become active.  If the device is active, it will make the 
memory snapshot inconsistent with the on-device data.

Alan Stern

