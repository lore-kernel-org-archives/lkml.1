Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYAXM4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYAXM4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYAXM4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:56:01 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:53950 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYAXM4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:56:00 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Date: Thu, 24 Jan 2008 13:58:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <200801241324.26868.oliver@neukum.org> <84144f020801240434s3ce63e58m8ffb74d70c0aef32@mail.gmail.com>
In-Reply-To: <84144f020801240434s3ce63e58m8ffb74d70c0aef32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801241358.51496.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Januar 2008 13:34:00 schrieb Pekka Enberg:
> Hi Oliver,
> 
> On Jan 24, 2008 2:24 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > > Sure but the filesystems in fs/ are general purpose and they can be
> > > mounted on top of any block device (except for the in-memory ones like
> >
> > nfs, cifs, jffs, ...
> 
> But none of them mess around with *hardware*. Sure, you can split it
> in two: driver and filesystem but yet again, the latter is not general
> purpose at all. I think this is somewhat similar to spufs which is
> really hardware specific and thus not eligible for fs/.

So we put it into drivers/usb/misc
Does that change the code?

> On Jan 24, 2008 2:24 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > > sysfs). Furthermore, the problem with iriverfs is that it assumes that
> > > there can be only one device plugged to the host. What we want is
> > > something like
> > >
> > >   $ mount -t iriverfs /dev/iriver0 /mnt/media
> > >
> > > Which can be accomplished with an USB driver in driver/usb/ that
> > > registers the special iriverfs.
> >
> > And what happens if you do
> > mount -t vfat /dev/iriver0 /mnt/media ?
> 
> If /dev/iriver0 is registered as a block device, we read the
> superblock but don't find a vfat filesystem and the mount fails as
> expected. As for
> 
>    mount -t iriverfs /dev/sd1 /mnt/media
> 
> we need to make sure file_system_type->get_sb() does something like
> what drivers/mtd/mtdsuper.c::get_sb_mtd() does to make sure we only
> let it mount if the block device is indeed an iriver player.

How do you make a block device on top of this device? It has no notion
of reading/writing arbitrary blocks. It operates on files.

	Regards
		Oliver

