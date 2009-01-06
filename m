Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZAFHa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZAFHa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZAFHaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:30:12 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:60909 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZAFHaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:30:11 -0500
Date: Tue, 6 Jan 2009 08:31:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Milton Miller <miltonm@bga.com>, linux-ppc <linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.28-git4 - powerpc - drivers build fails with !CONFIG_VIOPATH
Message-ID: <20090106073149.GA12371@uranus.ravnborg.org>
References: <5414eaef99b7392a95f6e3488b81dbf7@bga.com> <20090104182441.GA5086@linux.vnet.ibm.com> <98d6aef17cba9d835d7866745f811dc7@bga.com> <20090106072549.GA5066@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106072549.GA5066@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 	Sorry for resending the patch before taking care of the response. Resending 
> the patch with changes made to other three drivers also.
> 
> Impact: Fix the VIOPATH dependency in the iSeries dependent drivers.
> 
> iSeries depend drivers build fails, when CONFIG_VIOPATH is disabled.
> Removing the dependency of VIOPATH by selecting it, when the drivers
> dependent on iSeries code.
> 
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/iseries/Kconfig |    5 ++++-
>  drivers/char/Kconfig                   |    1 +
>  drivers/scsi/Kconfig                   |    1 +
>  3 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/iseries/Kconfig b/arch/powerpc/platforms/iseries/Kconfig
> index ed3753d..5cb2320 100644
> --- a/arch/powerpc/platforms/iseries/Kconfig
> +++ b/arch/powerpc/platforms/iseries/Kconfig
> @@ -10,18 +10,21 @@ menu "iSeries device drivers"
>  config VIODASD
>  	tristate "iSeries Virtual I/O disk support"
>  	depends on BLOCK
> +	select VIOPATH
>  	help
>  	  If you are running on an iSeries system and you want to use
>  	  virtual disks created and managed by OS/400, say Y.
>  
>  config VIOCD
>  	tristate "iSeries Virtual I/O CD support"
> +	select VIOPATH
>  	help
>  	  If you are running Linux on an IBM iSeries system and you want to
>  	  read a CD drive owned by OS/400, say Y here.
>  
>  config VIOTAPE
>  	tristate "iSeries Virtual Tape Support"
> +	select VIOPATH
>  	help
>  	  If you are running Linux on an iSeries system and you want Linux
>  	  to read and/or write a tape drive owned by OS/400, say Y here.
> @@ -30,5 +33,5 @@ endmenu
>  
>  config VIOPATH
>  	bool
> -	depends on VIODASD || VIOCD || VIOTAPE || ISERIES_VETH
> +	depends on PPC_ISERIES
>  	default y

VIOPATH is set using select so the "depends on" is effectively ignored.
If you think you need the "depends on" then you need to revisit the
symbol that will select VIOPATH and make sure _they_ have this dependency.

	Sam
