Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZDTUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZDTUtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZDTUtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:49:05 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:61065 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZDTUtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SveMrc0EijU0bYRoNpgy4gVEWihQocjlCcoXNVh0xycs3Q1qbsb6WyWcK2u4qUXkg2
         7HWTpfAT5nnv703kii6qtkbSym3oPqwW9RZo/Yl0449dKm/UkPEJJw4wUT1byxqS5jam
         z+3bDIzwWu1hxrGAiZltXUn3Z1igBeq5b+mAs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC][PATCH] block: enable by default support for large devices and files on 32-bit archs
Date: Mon, 20 Apr 2009 22:52:08 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
References: <200903281916.06905.bzolnier@gmail.com>
In-Reply-To: <200903281916.06905.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904202252.08619.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 March 2009 19:16:06 Bartlomiej Zolnierkiewicz wrote:
> 
> Enable by default support for large devices and files (CONFIG_LBD):
> 
> - With 1TB disks being a commodity hardware it is quite easy to hit 2TB
>   limitation while building RAIDs etc. and many distros have been using
>   CONFIG_LBD=y by default already (at least Fedora 10 and openSUSE 11.1).
> 
> - This should also prevent a subtle ext4 filesystem compatibility issue:
>   mke2fs.ext4 defaults to creating filesystems with huge_files feature
>   enabled and such filesystems cannot be later mounted read-write on
>   machines with CONFIG_LBD=n (it should be quite easy to hit this issue
>   when trying to use filesystem created using distro kernel on system
>   running the self-build kernel, think about USB disk enclosures & co.).
> 
> While at it:
> 
> - Clarify config option help text w.r.t. mounting ext4 filesystems
>   (they can be mounted with CONFIG_LBD=n but in the read-only mode).
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Unfortunately to also update the existings [def]configs the config option
> rename would be needed.  Actually, since the performance impact and kernel
> size increase seem to be minimal (at least on x86-32) maybe we should just
> go ahead and remove CONFIG_LBD (== always use 64-bit sector_t/blkcnt_t)?
> 
> I can make needed changes once there is agreement on preferred approach...

Jens, any thoughts on this?

[ Please note that the patch below should be safe for 2.6.30. ]

>  block/Kconfig |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> Index: b/block/Kconfig
> ===================================================================
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -26,6 +26,7 @@ if BLOCK
>  config LBD
>  	bool "Support for large block devices and files"
>  	depends on !64BIT
> +	default y
>  	help
>  	  Enable block devices or files of size 2TB and larger.
>  
> @@ -38,11 +39,13 @@ config LBD
>  
>  	  The ext4 filesystem requires that this feature be enabled in
>  	  order to support filesystems that have the huge_file feature
> -	  enabled.    Otherwise, it will refuse to mount any filesystems
> -	  that use the huge_file feature, which is enabled by default
> -	  by mke2fs.ext4.   The GFS2 filesystem also requires this feature.
> +	  enabled.  Otherwise, it will refuse to mount in the read-write
> +	  mode any filesystems that use the huge_file feature, which is
> +	  enabled by default by mke2fs.ext4.
>  
> -	  If unsure, say N.
> +	  The GFS2 filesystem also requires this feature.
> +
> +	  If unsure, say Y.
>  
>  config BLK_DEV_IO_TRACE
>  	bool "Support for tracing block io actions"
> 
