Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYEQOTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYEQOTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYEQOTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 10:19:44 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53676 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbYEQOTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 10:19:43 -0400
Date: Sat, 17 May 2008 17:17:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
	reference to `request_firmware'
Message-ID: <20080517141749.GD3284@cs181133002.pp.htv.fi>
References: <200805161906.19321.toralf.foerster@gmx.de> <1211018673.3603.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1211018673.3603.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 11:04:31AM +0100, James Bottomley wrote:
> On Fri, 2008-05-16 at 19:06 +0200, Toralf Förster wrote:
> > Hello,
> > 
> > the build (.config attached) failed, make ends with :
> > ...
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      vmlinux
> > drivers/built-in.o: In function `sas_request_addr':
> > (.text+0x33bab): undefined reference to `request_firmware'
> > drivers/built-in.o: In function `sas_request_addr':
> > (.text+0x33c3f): undefined reference to `release_firmware'
> > make: *** [vmlinux] Error 1
> 
> There's a slight fault in the stub logic.  It fails for FW_LOADER=m and
> the user =y.
> 
> This should fix it.

An interesting question is whether we actually want to have the stub at 
all - the compile errors catched cases where someone forgot to select 
FW_LOADER at compile time instead of turning them into possible runtime 
problems as will happen after your patch.

Are there any serious use cases where SCSI_SAS_LIBSAS is used in very 
space limited environments and without any other drivers that select 
FW_LOADER in the kernel?

> James
> 
> ---
> 
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 4d10c73..6c7eff2 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -13,7 +13,7 @@ struct firmware {
>  
>  struct device;
>  
> -#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
> +#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
>  int request_firmware(const struct firmware **fw, const char *name,
>  		     struct device *device);
>  int request_firmware_nowait(

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

