Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164Ab0AaJGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0AaJGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 04:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739Ab0AaJGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 04:06:41 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41511 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0AaJGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 04:06:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qwP6rLFQ2FPWtM1IU8ZaFRlLAyCysHeb4wVNl5gfzabyJb1RmK/k4zAdsEhUGFwmOi
         rxLl16tKVBnIbLmFFueq+WCN1S8L95O1MApUZv5eFD1ZPeip6U65waBTxLhZGlYoRpDB
         ZM6uf/C7fxaL3ffhYzAkET6qul8Re6qbzCR0Q=
Date: Sun, 31 Jan 2010 11:03:25 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, neilb@suse.de,
       linux-raid@vger.kernel.org, dm-devel@redhat.com, maan@systemlinux.org
Subject: Re: compat_ioctl: ignore RAID_VERSION ioctl
Message-ID: <20100131090324.GA3178@redhat.com>
References: <20100130205353.GA3168@redhat.com> <201001302302.10574.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001302302.10574.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 11:02:10PM +0100, Arnd Bergmann wrote:
> md ioctls are now handled by the md driver itself, but mdadm
> may call RAID_VERSION on other devices as well. Mark the command
> as IGNORE_IOCTL so this fails silently rather than printing
> an annoying message.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
> On Saturday 30 January 2010, Michael S. Tsirkin wrote:
> > Under 2.6.33-rcX (at least rc5 and rc6, didn't check earlier versions),
> > I started seeing these messages in dmesg (I do not see these messages on 2.6.32):
> > 
> > [   16.528951] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda9
> 
> Does this help?

Yes, this fixes it.

> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1038,6 +1038,8 @@ COMPATIBLE_IOCTL(FIOQSIZE)
>  #ifdef CONFIG_BLOCK
>  /* loop */
>  IGNORE_IOCTL(LOOP_CLR_FD)
> +/* md calls this on random blockdevs */
> +IGNORE_IOCTL(RAID_VERSION)
>  /* SG stuff */
>  COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
>  COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
> 
