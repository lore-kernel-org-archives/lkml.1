Return-Path: <linux-kernel-owner+w=401wt.eu-S935243AbXEWUgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243AbXEWUgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759236AbXEWUg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:36:26 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20362 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758225AbXEWUgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:36:25 -0400
Message-ID: <4654A581.6010201@msgid.tls.msk.ru>
Date: Thu, 24 May 2007 00:35:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] /sys/block -> /sys/class/block  (Fedora 3 & 4	testers
 wanted)
References: <20070521235353.GA6242@kroah.com> <20070522102501.72f40828@gondolin.boeblingen.de.ibm.com> <20070522182812.79b53880@gondolin.boeblingen.de.ibm.com> <20070523003255.GA3675@kroah.com> <20070523073959.0f5cb104@gondolin.boeblingen.de.ibm.com> <20070523180842.GA11999@kroah.com>
In-Reply-To: <20070523180842.GA11999@kroah.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
[]
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver core: convert block from raw kobjects to core devices
> 
> This moves the block devices to /sys/class/block. It will create a
> flat list of all block devices, with the disks and partitions in one
> directory. For compatibility /sys/block is created and contains symlinks
> to the disks.

What's the proper way now to figure out which device type it is --
block or char?

Before, I had a function (in my udev-alike userspace app), something akin
sysfs_scan_devices(char *topdir, mode_t type), and called it twice --

  sysfs_scan_devices("/block", S_IFBLK);
  sysfs_scan_devices("/devices", S_IFCHR);

How it's supposed to work now?  (Note that it skips symlinks for obvious
reason, hence it can't find anything in /sys/block, even with the compat
"layer" in place)

(Not complaining, but asking instead)

Thanks.

/mjt
