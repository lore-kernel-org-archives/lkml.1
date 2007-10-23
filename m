Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbXJVX7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbXJVX7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXJVX7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:59:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbXJVX7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:59:45 -0400
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0710212014130.25357-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0710212014130.25357-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 02:01:21 +0200
Message-Id: <1193097681.2107.9.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18KMBCzoqaDqNR7JtS47fZ4neyFlxhbhSJpxpv
 N1wNpfFXxaqexVuuy/R76LP2cHMHf3yQvaISlf5cRk8gaIyKEm
 BcAKBY4Z1RZcC1VNjmkuGbjrYX9c36+
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-10-21 at 20:26 -0400, Alan Stern wrote:
> On Sun, 21 Oct 2007, Kay Sievers wrote:
> 
> > > [  458.013133] scsi_disk_release: disk sda, kobj ce8be990, refcount before put_disk 2
> > > [  458.032420] scsi_device_dev_release: rq cd9b2000
> > 
> > Hmm, I still don't see this without the final put.
> 
> Yes, I see your point.  Suppose you try doing the exact same thing
> again, but this time un-comment the put_device() call so that the
> scsi_device does get released.  I predict that the log will show your
> request_queue drops its reference to the gendisk structure _after_ the
> gendisk has been released.  (If necessary I could send a patch with a
> printk at the crucial spot.)  That would prove something is going wrong
> on your system.

There is definitely something wrong, I tried all sorts of options now,
and a second machine, and I can never get the behavior you see. I even
booted with init=/bin/sh.
But true, looking at the kobject debugging for loop devices, and usb
storage driven by the ub driver, all looks fine without the additional
put.

There must be something going wrong with the block patch in conjunction
with the crazy SCSI release logic. Can you send me your .config? Just
for a check, maybe you have some option, enabled/disabled that changes
the behavior, and possibly brings us closer to find the bug.

Thanks,
Kay

