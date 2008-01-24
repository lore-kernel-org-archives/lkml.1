Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYAXMeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYAXMeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYAXMeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:34:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:63258 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYAXMeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fAQ5JekQSPdo6zuUsU9j09/90BcjIV7NvKs5cTvhiItJN0tx8tc2RyB/jAkti5PrD+OuHd+nJLuK5SHCAbuz8FIYlbiNiTn8bMEzTfwNWdY9tgfqtE7T7o3scHGAk65tIH4iMaUhTmFUg7MB+jHlJlDON50NAgA5eMZ6KW0cvks=
Message-ID: <84144f020801240434s3ce63e58m8ffb74d70c0aef32@mail.gmail.com>
Date: Thu, 24 Jan 2008 14:34:00 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801241324.26868.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <200801241249.06577.oliver@neukum.org>
	 <84144f020801240352r688fbbccu52ce9aa8ea3f199@mail.gmail.com>
	 <200801241324.26868.oliver@neukum.org>
X-Google-Sender-Auth: 7c34979ba5427298
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Jan 24, 2008 2:24 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Sure but the filesystems in fs/ are general purpose and they can be
> > mounted on top of any block device (except for the in-memory ones like
>
> nfs, cifs, jffs, ...

But none of them mess around with *hardware*. Sure, you can split it
in two: driver and filesystem but yet again, the latter is not general
purpose at all. I think this is somewhat similar to spufs which is
really hardware specific and thus not eligible for fs/.

On Jan 24, 2008 2:24 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > sysfs). Furthermore, the problem with iriverfs is that it assumes that
> > there can be only one device plugged to the host. What we want is
> > something like
> >
> >   $ mount -t iriverfs /dev/iriver0 /mnt/media
> >
> > Which can be accomplished with an USB driver in driver/usb/ that
> > registers the special iriverfs.
>
> And what happens if you do
> mount -t vfat /dev/iriver0 /mnt/media ?

If /dev/iriver0 is registered as a block device, we read the
superblock but don't find a vfat filesystem and the mount fails as
expected. As for

   mount -t iriverfs /dev/sd1 /mnt/media

we need to make sure file_system_type->get_sb() does something like
what drivers/mtd/mtdsuper.c::get_sb_mtd() does to make sure we only
let it mount if the block device is indeed an iriver player.

                        Pekka
