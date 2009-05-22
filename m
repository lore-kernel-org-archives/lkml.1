Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZEVTb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZEVTb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbZEVTbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:31:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48266 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754899AbZEVTbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:31:18 -0400
Date: Fri, 22 May 2009 15:31:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
In-Reply-To: <ac3eb2510905221124y412dc3bdp65ad1b74373175a9@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905221522560.3006-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Kay Sievers wrote:

> On Fri, May 22, 2009 at 17:54, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> >> Would releasing the "lock" trigger a kernel-driver-binding call?
> >
> > No.  If the lock owner wants to bind kernel drivers, it can use the
> > existing API in libusb after releasing the lock.  This might cause
> > problems if the owning process terminates abnormally, but I think we
> > can live with that.
> >
> >> The lock will always lock all devices of a specific hub?
> >
> > The idea is that there will be one lock file per port.  So for example,
> > a hub device with four ports might contain inside its sysfs device
> > directory: ports/1, ..., ports/4.
> 
> Sounds both good to me.

Come to think of it, putting the lock files in sysfs isn't such a good 
idea.  The core will need to know whether the files are open, so we'll 
have to have our own file_operations structure for them.

Which means the best place to put the lock files is probably somewhere 
in /dev.  Can this be made to work by generating appropriate uevents, 
with the default udev rules?

Alan Stern

