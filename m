Return-Path: <linux-kernel-owner+w=401wt.eu-S1030521AbXCLQVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521AbXCLQVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030580AbXCLQVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:21:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58806 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030521AbXCLQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:21:51 -0400
Date: Mon, 12 Mar 2007 12:21:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <200703121659.27348.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0703121216210.2489-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Oliver Neukum wrote:

> > > Yes, I was missing the point. In consequence, drivers must not use
> > > dev_get_drvdata() to get their references to their private data. It's

You do realize how foolish that sounds?  Why do you think 
dev_get_drvdata() was written in the first place?

> > > probably necessary to store it in struct sysfs_buffer and include that
> > > in the store/show callbacks.
> > > (The same does apply to interfaces of course)
> > >
> > 
> > Or drivers coudl verify that they still bound to the device they are
> > about to operate on (psmouse does this by taking a lock on device and
> > then checking if driver bound is the same address as psmouse). But I'd
> > rather get rid of all this clutter if we could sever sysfs access
> > after removing corresponding attributes.
> 
> No, the call has to fail if the driver is rebound to the device.

I'm with Dmitry; the whole thing becomes much, much simpler if we put back
your patch and prevent sysfs access after unregistering an attribute 
file.  No API changes are needed, no driver changes are needed, no radical 
core changes are needed,...  All we would have to do is fix the one SCSI 
method to make it use a workqueue.

Alan Stern

