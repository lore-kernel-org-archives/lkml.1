Return-Path: <linux-kernel-owner+w=401wt.eu-S935100AbXLQCLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935100AbXLQCLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbXLQCLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:11:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760001AbXLQCLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:11:30 -0500
Subject: Re: [PATCH 007 of 7] md: Get name for block device in sysfs
From: Kay Sievers <kay.sievers@vrfy.org>
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <greg@kroah.com>
In-Reply-To: <18277.43533.991986.323212@notabene.brown>
References: <20071214171950.1308.patches@notabene>
	 <1071214062647.1928@suse.de>
	 <3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>
	 <18277.43533.991986.323212@notabene.brown>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 03:10:14 +0100
Message-Id: <1197857414.2585.16.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+tLZHyNp5HQun1w3/AlTGxP1BDFjN5SiazdTg
 wan6bjVIj5rQAbXp2xYXlTzyIWgiOsxdRCr7B8UcYEX2tJ5MyZ
 diwTkx7PGs3RCYkpGhmrE4FmAyqEmqu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 09:43 +1100, Neil Brown wrote:
> On Saturday December 15, kay.sievers@vrfy.org wrote:
> > On Dec 14, 2007 7:26 AM, NeilBrown <neilb@suse.de> wrote:
> > >
> > > Given an fd on a block device, returns a string like
> > >
> > >         /block/sda/sda1
> > >
> > > which can be used to find related information in /sys.
> ....
> > 
> > As pointed out to when you came up with the idea, we can't do this. A devpath
> > is a path to the device and will not necessarily start with "/block" for block
> > devices. It may start with "/devices" and can be much longer than
> > BDEVNAME_SIZE*2  + 10.
> 
> When you say "will not necessarily" can I take that to mean that it
> currently does, but it might (will) change??

It's in -mm. The devpath for all block devices, like for all other
devices, will start with /devices/* if !SYSFS_DEPRECATED.

> In that case can we have the patch as it stands and when the path to
> block devices in /sys changes, the ioctl can be changed at the same
> time to match?

No, you have to use kobject_get_path() to get the path to the object.
This will also handle devices where the name contains '/' which needs to
be translated to '!', which is broken in this patch.

> Or are you saying that as the kernel is today, some block devices
> appear under /devices/..., in which case could you please give an
> example?

We expect the next kernel to have it.

Btw: BLKGETNAME should probably be renamed to something which contains
DEVPATH, to make clear that it's a path to, and not the name of the
device.

Kay

