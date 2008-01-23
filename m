Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYAWA4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYAWA4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYAWAra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:47:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:34233 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbYAWAqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:46:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=o6x4aehYgzb2/nl0wJB3BdqrXukFwmdGMegTp1wd5BGFz7XcePUVTkWlmsY657SvbiLfYfBm6JgLX/2QPJHGeZ5dm0aqDtHntciKNvJRFHtWRe1sz9r8+UmGJZbUeM8zDvrfvPDSyG2cnhv8OXB9xndV8chDkGyEix4dZ3hThxc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH] ppc: fix #ifdef-s in mediabay driver
Date: Wed, 23 Jan 2008 01:58:41 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
References: <200801230012.38516.bzolnier@gmail.com> <1201046394.6807.49.camel@pasglop>
In-Reply-To: <1201046394.6807.49.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801230158.42017.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 23 January 2008, Benjamin Herrenschmidt wrote:
> 
> On Wed, 2008-01-23 at 00:12 +0100, Bartlomiej Zolnierkiewicz wrote:
> > * Replace incorrect CONFIG_BLK_DEV_IDE #ifdef in
> >   check_media_bay() by CONFIG_MAC_FLOPPY one.
> > 
> > * Replace incorrect CONFIG_BLK_DEV_IDE #ifdef-s by
> >   CONFIG_BLK_DEV_IDE_PMAC ones.
> > 
> > * check_media_bay() is used only by drivers/block/swim3.c
> >   so make this function available only if CONFIG_MAC_FLOPPY
> >   is defined.
> > 
> > * check_media_bay_by_base() and media_bay_set_ide_infos()
> >   are used only by drivers/ide/ppc/pmac.c so so make these
> >   functions available only if CONFIG_MAC_FLOPPY is defined.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > Ben, IMO this patch is safe for 2.6.24 (assuming that it builds fine :),
> > otherwise I would like to ask for permission to merge it through IDE
> > tree since I have other pending IDE patches depending on this one.
> 
> I'd rather avoid touching 2.6.24 unless it actually fixes a bug or
> regression...

Well, it is a bugfix for PMAC_MEDIABAY=y && BLK_DEV_IDE=n && MAC_FLOPPY=y. :)

> I'm tempted to actually remove all ifdef's ... if you have a media-bay,
> then there are about 99% chances it contains an IDE device, with the
> remaining percent being split with putting a floppy or a battery in. I
> doubt anybody will care building a kernel without the support for these
> and with the mediabay support, and still want to save a handful of bytes
> in that driver.

I'm more worried about breaking automatic build checking (make randconfig)
than a few extra bytes so if you remove all #ifdefs you'll have to either
make BLK_DEV_IDE_PMAC select PMAC_MEDIABAY or make PMAC_MEDIABAY depend
on BLK_DEV_IDE_PMAC (otherwise BLK_DEV_IDE=n && PMAC_MEDIABAY=y will fail
since mediabay.c is referencing IDE code).

Thanks,
Bart
