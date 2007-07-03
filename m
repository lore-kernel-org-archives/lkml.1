Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXGCQ51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXGCQ51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbXGCQ5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:57:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33820 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753304AbXGCQ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:57:19 -0400
Date: Tue, 3 Jul 2007 12:57:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070703160526.GA24334@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707031255420.3936-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Matthew Garrett wrote:

> On Tue, Jul 03, 2007 at 12:03:33PM -0400, Alan Stern wrote:
> > On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > 
> > > Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> > > a screaming nightmare - either the suspend fails because syslog (for 
> > > instance) can't be frozen, or the machine deadlocks for some other 
> > > reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> > > could do what we do for suspend to RAM on other platforms (PPC and APM) 
> > > and just not use the freezer.
> > 
> > Quite apart from the sync() matter, _any_ synchronous call to a FUSE 
> > filesystem during STR will cause trouble.  Even if the user task 
> > implementing the filesystem isn't frozen, when it tries to carry out 
> > some I/O to a suspended device it will either:
> > 
> > 	block until the system wakes up, or
> 
> For the suspend to RAM case, that sounds absolutely fine.

It's not so good when your suspend process has to wait for the call to 
complete!

Alan Stern

