Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab0BGJ1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 04:27:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35685 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0BGJ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 04:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hzPHgdGuQkClksoiiPTegc6Xto60gDTG3vD+oaJbCuUyIy6iXlb8ZVMlAAPjxOnQum
         5lUFb87rd9bMrfMPMVB/bxOk77eJr5Eom8lJKWoSNxK7iKo4CnA+/QPO76fbNzFwaq/x
         /Ts7G8M4GwRaMxqLYI+yeMDU73YIDmbVuI28A=
Date: Sun, 7 Feb 2010 11:24:09 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, neilb@suse.de,
       linux-raid@vger.kernel.org, dm-devel@redhat.com, maan@systemlinux.org
Subject: Re: compat_ioctl: ignore RAID_VERSION ioctl
Message-ID: <20100207092407.GA19684@redhat.com>
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

The patch does not seem to be there in -rc7.
Since this is fixes a regression, should this go into 2.6.33?
Thanks!

> ---
> 
> On Saturday 30 January 2010, Michael S. Tsirkin wrote:
> > Under 2.6.33-rcX (at least rc5 and rc6, didn't check earlier versions),
> > I started seeing these messages in dmesg (I do not see these messages on 2.6.32):
> > 
> > [   16.528951] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda9
> 
> Does this help?
> 
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
