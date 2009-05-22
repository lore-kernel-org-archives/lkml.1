Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZEVWH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZEVWH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbZEVWHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:07:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41783 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757542AbZEVWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:07:14 -0400
Date: Fri, 22 May 2009 18:07:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
In-Reply-To: <ac3eb2510905221454u2fd7fe88tb3d6c13c6ae550a@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905221801470.22960-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Kay Sievers wrote:

> On Fri, May 22, 2009 at 21:31, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Come to think of it, putting the lock files in sysfs isn't such a good
> > idea.  The core will need to know whether the files are open, so we'll
> > have to have our own file_operations structure for them.
> >
> > Which means the best place to put the lock files is probably somewhere
> > in /dev.  Can this be made to work by generating appropriate uevents,
> > with the default udev rules?
> 
> Nodes in /dev would  need a corresponding device in /sys and belong to
> a subsystem to send an event. That sounds like a lot of stuff for a
> simple interface like this. Can't we just add ioctls to the hub device
> nodes to implement the locking?

Yes, that would work.  Closing the hub device file would release all 
the locked ports.

It wouldn't leave any lock files for user programs.  They would have to 
arrange the locking among themselves somehow.  Would that be okay?

Alan Stern

