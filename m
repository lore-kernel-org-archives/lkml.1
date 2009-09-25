Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbZIYW3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbZIYW3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZIYW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:29:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:38681 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZIYW3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xCAwLui5+XmAV7JJVu6FpYITsjk8qO6SPGCnBEzs7CatEZyK4Qft+KvnE/aZriUszk
         6S3F6tTKWUgcNE76/Uw9swFubJCMa0Izxrjp9AXCHC0FR5IWA0GATA0eEXl2lU1TvrEj
         BiXyytwPA6UTlkD4eHF+N2BWH/51uEnSAk+aw=
Date: Fri, 25 Sep 2009 15:29:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] input: serio_libps2 depends on serio_i8042
Message-ID: <20090925222901.GC8618@core.coreip.homeip.net>
References: <20090925133830.1ba29584.sfr@canb.auug.org.au> <4ABD4219.5000608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABD4219.5000608@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 03:20:09PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> SERIO_LIBPS2 code uses SERIO_I8042 code, so the former
> needs to depend on the latter.
>

Umm, it should be useable without i8042... But I guess you have
SERIO_LIBPS2=y but SERIO_I8042=m?

> (.text+0x1f33ca): undefined reference to `i8042_check_port_owner'
> (.text+0x1f33de): undefined reference to `i8042_unlock_chip'
> (.text+0x1f3435): undefined reference to `i8042_check_port_owner'
> (.text+0x1f3449): undefined reference to `i8042_lock_chip
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/input/serio/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090925.orig/drivers/input/serio/Kconfig
> +++ linux-next-20090925/drivers/input/serio/Kconfig
> @@ -168,6 +168,7 @@ config SERIO_MACEPS2
>  
>  config SERIO_LIBPS2
>  	tristate "PS/2 driver library" if EMBEDDED
> +	depends on SERIO_I8042
>  	help
>  	  Say Y here if you are using a driver for device connected
>  	  to a PS/2 port, such as PS/2 mouse or standard AT keyboard.

-- 
Dmitry
