Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZDOPrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZDOPrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZDOPrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:47:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52220 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751685AbZDOPrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:47:39 -0400
Date: Wed, 15 Apr 2009 11:47:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
In-Reply-To: <20090415160153.485c2095@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0904151146210.3072-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009, Alan Cox wrote:

> Why should every user suffer a slower boot and a poorer resume time ?
> 
> Instead make the root fs mounting look like this
> 
> 
> 	while(my_rootfs_hasnt_appeared_and_i_am_sad()) {
> 		wait_on(&new_disk_discovery);
> 	}
> 
> and poke the queue whenever we add a relevant device.
> 
> That way if you are booting off an initrd you can finish the SATA probe
> in parallel to getting userspace ticking over.
> 
> On what is nowdays essentially a hot plug system it all needs turning
> this way up - eg RAID volumes should assemble and come online as the
> drives are discovered not at some fixed point later in userspace.

Indeed, something like this should also be used for 
resume-from-hibernation, to wait for the swap device.

Alan Stern

