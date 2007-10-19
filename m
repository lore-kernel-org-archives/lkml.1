Return-Path: <linux-kernel-owner+w=401wt.eu-S1764119AbXJSOJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764119AbXJSOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXJSOJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:09:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52944 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752981AbXJSOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:09:50 -0400
Date: Fri, 19 Oct 2007 10:09:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices
In-Reply-To: <1192757236.3308.3.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0710191004090.4091-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Kay Sievers wrote:

> > This accounts for everything in del_gendisk except the final
> > put_device.  Evidently it doesn't belong there.  There's no matching 
> > get_device in add_disk or register_disk.
> 
> Hmm, do you have kobject debugging enabled? Do you ever see something
> like: "kobject sdb: cleaning up" when you remove the put_device()?

I didn't enable kobject debugging, but I did put a printk statement in
drivers/scsi/sd.c:scsi_disk_release(), which is the release routine for
the scsi_disk structure.  It does the final put_disk() call -- or at 
least, this is _supposed_ to be the final call.

With my patch, just before the call to put_disk the value of 
disk->dev.kobj.kref.refcount is 1.  Without my patch, the value is 
garbage (probably a slab poison value, but I printed it in decimal 
rather than hex so I can't be sure).

Don't you have a USB storage device?  It should be easy for you to test 
this on your own system.

Alan Stern

