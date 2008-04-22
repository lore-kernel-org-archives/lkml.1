Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbYDVPtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbYDVPtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYDVPs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:48:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59971 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751007AbYDVPs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:48:57 -0400
Date: Tue, 22 Apr 2008 11:48:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jan Kara <jack@suse.cz>, <linux-usb@vger.kernel.org>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: ./fs/partitions/check.c: off-by-one error ?
In-Reply-To: <20080422083214.cbfa3786.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.44L0.0804221145050.8058-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Randy Dunlap wrote:

> On Tue, 22 Apr 2008 12:38:29 +0200 Jan Kara wrote:
> 
> > > I already re-formatted the card under Linux as well as under Windows XP and got
> > > always the same behaviour.
> >   This looks more like a strange interaction of your device size (it
> > claims to have 3902463 sectors) and your partitioning programs which
> > create partition ending at sector 3902464. Can you send the partition
> > table you have on the device? E.g:
> >   fdisk /dev/sda
> >   x
> >   p
> > 
> >   will print detailed information about the partition table.
> 
> Is this something that using US_FL_FIX_CAPACITY will fix?
> 
> US_FL_FIX_CAPACITY -> sets ->fix_capacity, then:
> 
> 	/* Some devices return the total number of sectors, not the
> 	 * highest sector number.  Make the necessary adjustment. */
> 	if (sdp->fix_capacity) {
> 		--sdkp->capacity;

FIX_CAPACITY will make it worse.  The device would appear to have only
3902462 sectors and the partition table will still refer sector
3902464.

The card should be repartitioned as well as reformatted, both under 
Linux.

Alan Stern

