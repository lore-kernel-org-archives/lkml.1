Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZLIUkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZLIUkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbZLIUkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:40:19 -0500
Received: from kroah.org ([198.145.64.141]:43996 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbZLIUkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:40:15 -0500
Date: Wed, 9 Dec 2009 12:30:18 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20091209203018.GC8222@kroah.com>
References: <20091209163435.244f7f1f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209163435.244f7f1f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 04:34:35PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got conflicts in
> drivers/staging/vt6655/Kconfig and drivers/staging/vt6656/Kconfig between
> commit 125b181aec7a67c71234284ecf6d9c729d05deda ("staging: Add proper
> selection of WIRELESS_EXT and WEXT_PRIV") from Linus' tree and commit
> a0d2ec259009d9378343697af84636f1e16c2421 ("Staging: vt6x depends on
> WLAN") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix for a while.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/staging/vt6655/Kconfig
> index 825bbc4,ed51d7c..0000000
> --- a/drivers/staging/vt6655/Kconfig
> +++ b/drivers/staging/vt6655/Kconfig
> @@@ -1,8 -1,6 +1,8 @@@
>   config VT6655
>      tristate "VIA Technologies VT6655 support"
> -    depends on PCI
>  -   depends on WIRELESS_EXT && PCI && WLAN
> ++   depends on PCI && WLAN
>  +   select WIRELESS_EXT
>  +   select WEXT_PRIV
>      ---help---
>      This is a vendor-written driver for VIA VT6655.
>   
> diff --cc drivers/staging/vt6656/Kconfig
> index 87bcd26,fcde661..0000000
> --- a/drivers/staging/vt6656/Kconfig
> +++ b/drivers/staging/vt6656/Kconfig
> @@@ -1,8 -1,6 +1,8 @@@
>   config VT6656
>   	tristate "VIA Technologies VT6656 support"
> - 	depends on USB
>  -	depends on WIRELESS_EXT && USB && WLAN
> ++	depends on USB && WLAN
>  +	select WIRELESS_EXT
>  +	select WEXT_PRIV
>   	---help---
>   	This is a vendor-written driver for VIA VT6656.

Thanks, I'll fix this up when I sync up with Linus later today.

greg k-h
