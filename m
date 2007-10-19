Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbXJSOOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbXJSOOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbXJSOOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:14:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547AbXJSOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:14:29 -0400
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0710191004090.4091-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0710191004090.4091-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 16:15:53 +0200
Message-Id: <1192803353.3308.14.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19GUyUoxIywO/vUHymAWK+eXfZ7HnxLME9JTq5
 Ln9CAaiJX6W9nlbdbWr3cW7X3ZU22BnHIMjfCg87RwZWbZHoeK
 +tLbGoRmdVmwh1eveqBXjPmqfdiK9AY
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 10:09 -0400, Alan Stern wrote:
> On Fri, 19 Oct 2007, Kay Sievers wrote:
> 
> > > This accounts for everything in del_gendisk except the final
> > > put_device.  Evidently it doesn't belong there.  There's no matching 
> > > get_device in add_disk or register_disk.
> > 
> > Hmm, do you have kobject debugging enabled? Do you ever see something
> > like: "kobject sdb: cleaning up" when you remove the put_device()?
> 
> I didn't enable kobject debugging, but I did put a printk statement in
> drivers/scsi/sd.c:scsi_disk_release(), which is the release routine for
> the scsi_disk structure.  It does the final put_disk() call -- or at 
> least, this is _supposed_ to be the final call.
> 
> With my patch, just before the call to put_disk the value of 
> disk->dev.kobj.kref.refcount is 1.  Without my patch, the value is 
> garbage (probably a slab poison value, but I printed it in decimal 
> rather than hex so I can't be sure).
> 
> Don't you have a USB storage device?  It should be easy for you to test 
> this on your own system.

Sure, I have, and tried a lot of times, and all seemed correct here with
the final put. I don't say that it's the right fix, but without it, the
disk device object is never released here, it only gets removed from
sysfs.

Kay

