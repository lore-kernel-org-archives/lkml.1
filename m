Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbXJVA0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbXJVA0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 20:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXJVA0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 20:26:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1190 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751067AbXJVA0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 20:26:39 -0400
Date: Sun, 21 Oct 2007 20:26:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices
In-Reply-To: <1192993396.3661.1.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0710212014130.25357-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007, Kay Sievers wrote:

> > [  458.013133] scsi_disk_release: disk sda, kobj ce8be990, refcount before put_disk 2
> > [  458.032420] scsi_device_dev_release: rq cd9b2000
> 
> Hmm, I still don't see this without the final put.

Yes, I see your point.  Suppose you try doing the exact same thing
again, but this time un-comment the put_device() call so that the
scsi_device does get released.  I predict that the log will show your
request_queue drops its reference to the gendisk structure _after_ the
gendisk has been released.  (If necessary I could send a patch with a
printk at the crucial spot.)  That would prove something is going wrong
on your system.

(BTW you don't need to include the log for when you plug in the USB
drive; all that matters is what happens when you unplug it.)

Alan Stern

