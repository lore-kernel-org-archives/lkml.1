Return-Path: <linux-kernel-owner+w=401wt.eu-S933171AbXHWWIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbXHWWIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764752AbXHWWIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:08:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763078AbXHWWIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:08:41 -0400
Subject: Re: [patch 09/14] Convert from class_device to device for SPI
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Brownell <david-b@pacbell.net>
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200708231403.52846.david-b@pacbell.net>
References: <20070820224806.154198000@suse.de>
	 <200708211128.28552.david-b@pacbell.net> <20070822030515.GA32136@suse.de>
	 <200708231403.52846.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 00:12:52 +0200
Message-Id: <1187907172.3632.43.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+nRUoTqqB2UVhsTRiHH2L4AIP6gQ7ziUaTHeT
 BfvEAE/ExFY5wM9fbdw4616TjppNu9SIa/675tlf4+SXsiKlKc
 U3PBWcIcfvEiy5J9ekKhIX67ZLaYoat
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 14:03 -0700, David Brownell wrote:
> On Tuesday 21 August 2007, Tony Jones wrote:
> > I believe this is the necessary documentation changes.
> 
> Thanks.  I have an update, plus updates for the mmc_spi
> driver (now in MM) which you didn't update.
> 
> By the way, it's worth noting an incompatibility introduced
> through these conversions and CONFIG_SYSFS_DEPRECATED=n:
> 
>  - previously .../controller/spi_master:spi2 would be a
>    symlink to /sys/class/spi_master/spi2

These "find the class device which has me as the parent"-symlinks are
removed with CONFIG_SYSFS_DEPRECATED=n, because these devices are direct
child directories now below the bus device and there is no need for such
links.

>  - now, /sys/class/spi_master/spi2 is a symlink to
>    .../controller/spi_master (with DEPRECATED=n).

Ugh! Are you sure, that is doesn't point to:
  .../controller/spi_master/spi2/ ?

> The symlink direction is just noise ... the issue is that with
> this approach it's no longer possible to have one controller
> handle multiple SPI busses!  A fix would involve maintaining
> the original "spi_master:spi2" name.

Sounds like a bug if that's what happened. Can you paste the output of
"tree" for the relevant parts here?

Thanks,
Kay


