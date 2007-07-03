Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbXGCTdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbXGCTdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXGCTdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:33:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55361 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755276AbXGCTdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:33:42 -0400
Date: Tue, 3 Jul 2007 15:33:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070703170233.GA25129@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707031529130.7671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Matthew Garrett wrote:

> On Tue, Jul 03, 2007 at 12:57:17PM -0400, Alan Stern wrote:
> > On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > > On Tue, Jul 03, 2007 at 12:03:33PM -0400, Alan Stern wrote:
> > > > Quite apart from the sync() matter, _any_ synchronous call to a FUSE 
> > > > filesystem during STR will cause trouble.  Even if the user task 
> > > > implementing the filesystem isn't frozen, when it tries to carry out 
> > > > some I/O to a suspended device it will either:
> > > > 
> > > > 	block until the system wakes up, or
> > > 
> > > For the suspend to RAM case, that sounds absolutely fine.
> > 
> > It's not so good when your suspend process has to wait for the call to 
> > complete!
> 
> Why would it have to? Sorry, I suspect I'm missing something obvious 
> here.

Well, the sys_sync() that caused your original problem did exactly 
that.  It's the reason you get deadlocks, right?

I agree that in general the suspend process should not have to wait for 
a userspace callback to complete.  Indeed, there's no particular 
reason that anything running during STR should have to wait for 
something in userspace to complete.  Given that fact, I don't see 
anything wrong with freezing userspace when doing STR.

Alan Stern

