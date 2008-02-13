Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYBMFzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYBMFzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYBMFza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:55:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:23503 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYBMFz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:55:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d4CD/+IzKBc4hPdK/O+e/ZCgg5LYiFtHds+VBpKpovmUHZMIghaImLrH7pFkhyPLOSCphUk901eXKQmHfSE8G7KssG+nVqmWjtBO53dphuEVBqzx4Ys8DbP2eDJqOXPoKiw/yGXiBGNjsvcm8633VsjXTkzaMTaUTkXrbrdRkqE=
Message-ID: <86802c440802122155o96af814h7cb5b9bee96e9674@mail.gmail.com>
Date: Tue, 12 Feb 2008 21:55:25 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: /initrd.img
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47B1DD36.6090401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440802120328i2e60ba3brbe7fdec87d4cce4a@mail.gmail.com>
	 <47B1DD36.6090401@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 9:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yinghai Lu wrote:
> > any limitation about size of
> > /initrd.img that saved by populate_rootfs ?
> >
> > i got
> >
> > RAMDISK: Compressed image found at block 0
> > RAMDISK: incomplete write (-28 != 2048) 134217728
> > crc error
> > VFS: Mounted root (ext2 filesystem).
> > Freeing unused kernel memory: 388k freed
> > init_special_inode: bogus i_mode (177777)
> > Warning: unable to open an initial console.
> > init_special_inode: bogus i_mode (177777)
> > init_special_inode: bogus i_mode (177777)
> > Kernel panic - not syncing: No init found.  Try passing init= option to kernel.
> >
> > before that
> > checking if image is initramfs... it isn't (no cpio magic); looks like an initrd
> > Freeing initrd memory: 25735k freed.
> >
> > that only happen one system (64G RAM) and SLUB.
> >
> > if using SLAB, it works well.
> >
> > somewhere the ramdisk or /initrd.img get corrupted..
> >
>
> Assuming a 64-bit system, that's *supposed* to work.  Doesn't mean
> anything that weird has been tested.
>
> It could be a SLUB bug, or it could be memory not being properly defended.

found the root case. something wrong ses.c
will send one patch to James.

YH
