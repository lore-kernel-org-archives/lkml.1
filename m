Return-Path: <linux-kernel-owner+w=401wt.eu-S1767351AbXCIQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767351AbXCIQcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767372AbXCIQcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:32:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48134 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1767351AbXCIQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:32:30 -0500
Date: Fri, 9 Mar 2007 11:32:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <200703090145.53895.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0703091124570.2611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Oliver Neukum wrote:

> Am Donnerstag, 8. März 2007 17:02 schrieb Alan Stern:
> > On Thu, 8 Mar 2007, Oliver Neukum wrote:
> > 
> > > Hi,
> > > 
> > > after a lightning bolt from high above I've been looking into refcounting
> > > the data structures drivers use to provide the data used to refill sysfs
> > > buffers. I've come to the following conclusion.
> > > 
> > > 1. struct sysfs_buffer must have a struct kref * and probably a destructor
> > > pointer
> > > 2. drivers must be able to pass these pointers through an extended
> > > device_create_file()
> > > 3. Drivers must use refcounting if they want to use attributes
> > > 4. read/write/poll must do refcounting
> > > 
> > > I am not sure where to store the pointers. struct sysfs_dirent() looks
> > > like the obvious choice. Comments?
> > 
> > Can you explain the reasoning that led to these conclusions?  And what 
> > exactly was your lightning bolt?
> 
> The old race between disconnect and IO to attribute via sysfs again.
> If I cannot disassociate the drivers from the buffers in the buffers, drivers
> must not deallocate the data necessary to answer sysfs callbacks while
> a buffer exists.

Why wouldn't you be able to dissociate a driver from a buffer?  That was 
the whole point of adding .orphan to sysfs_buffer and creating 
sysfs_buffer_collection -- it was supposed to solve exactly this race.

Alan Stern

