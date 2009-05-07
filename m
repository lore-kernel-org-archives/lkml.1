Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZEGVTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZEGVTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZEGVSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:18:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33600 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751321AbZEGVSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:18:51 -0400
Date: Thu, 7 May 2009 17:18:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usbfs, claiming entire usb devices
In-Reply-To: <ac3eb2510905071335l473e30d3jbabb62d471607b8d@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905071714220.4812-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Kay Sievers wrote:

> On Thu, May 7, 2009 at 21:55, Alan Stern <stern@rowland.harvard.edu> wrote:
> > There is a proposal afoot to give user programs the ability to claim
> > ownership of an entire USB device, rather than just individual
> > interfaces.  In fact, we'd like processes to be able to own whatever
> > device gets plugged into a particular port on a particular hub.
> >
> > The question is how the API should work.  A simple approach is to have
> > a sysfs or usbfs file correspond to each port; when a process opens the
> > file it would be granted ownership of any device plugged into that
> > port.  Since the file is automatically closed when the process ends, we
> > wouldn't have to worry about ownership never getting released.
> >
> > But there's a snag.  When a process goes to open the usbfs file for a
> > device, the kernel needs to know whether or not the process owns that
> > device.  In other words, we need to figure out whether or not the
> > process has opened the corresponding port file.
> >
> > Is there a simple way to do this?  Is it reasonable to search through
> > all the process's fd's, looking for one that matches a particular
> > inode?
> >
> > Or would a completely different API approach be better?
> 
> You have one file per device, and that file has normal unix file
> permissions. Userspace can grant access to that file by ownership or
> by adding an ACL. What else do we need?

We need the ability to prevent the kernel from automatically 
configuring a device.  We need the ability to prevent kernel drivers 
from binding to a device before userspace programs get a chance.

>  Why would the kernel care who
> opened the file, when the one was able to get through the normal file
> access check?

Access checks can't be used, because programs want to stake their claim
to the device (and its file) even before the device has been plugged
in.  So there's no file and no ACL to set.

> Or did you mean some magic for an entire tree of devices below some
> port? Like some sort of permission inheritance in the kernel?

No, just the device in that port.

Alan Stern

