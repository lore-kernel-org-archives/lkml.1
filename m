Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbXGARAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbXGARAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 13:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXGARAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 13:00:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbXGARAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 13:00:33 -0400
Message-ID: <4687DB3F.8060609@zytor.com>
Date: Sun, 01 Jul 2007 12:50:07 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jacques Gelinas <jacques@solucorp.qc.ca>,
       Matija Nalis <mnalis@voyager.hr>,
       Michael Elizabeth Chastain <mec@shout.net>,
       Volker Lendecke <vl@kki.org>, Mikael Starvik <starvik@axis.com>,
       Ian Molton <spyro@f2s.com>, Jeff Dike <jdike@karaya.com>,
       Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org
Subject: Re: [PATCH][resend] Remove the last few UMSDOS leftovers.
References: <200707010117.39778.jesper.juhl@gmail.com>
In-Reply-To: <200707010117.39778.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> (originally from 28 May 2007, resending due to no response to this 
>  final version and not seeing the patch picked up anywhere)
> 
> 
> The UMSDOS filesystem was removed back in 2.6.11, but some tiny bits
> stuck around. This patch removes the few remaining leftovers.
> The only things left behind after this are the entries in the CREDITS file
> and the ioctl number in Documentation/ioctl-number.txt as documentation.
> 
> This third (hopefully final) version of the patch doesn't edit the 
> arch/um/config.release file, since Jeff Dike pointed out to me that it 
> should die completely, and asked me to remove it from my patch as
> he'll send in a seperate patch removing the file completely.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>


> ---
> 
>  Documentation/ioctl-number.txt |    2 +-
>  arch/arm26/defconfig           |    1 -
>  arch/cris/arch-v10/defconfig   |    1 -
>  include/linux/ncp_fs.h         |    2 --
>  4 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
> index 3de7d37..5c7fbf9 100644
> --- a/Documentation/ioctl-number.txt
> +++ b/Documentation/ioctl-number.txt
> @@ -67,7 +67,7 @@ Code	Seq#	Include File		Comments
>  0x00	00-1F	linux/wavefront.h	conflict!
>  0x02	all	linux/fd.h
>  0x03	all	linux/hdreg.h
> -0x04	all	linux/umsdos_fs.h
> +0x04	D2-DC	linux/umsdos_fs.h	Dead since 2.6.11, but don't reuse these.
>  0x06	all	linux/lp.h
>  0x09	all	linux/md.h
>  0x12	all	linux/fs.h
> diff --git a/arch/arm26/defconfig b/arch/arm26/defconfig
> index c4a8970..2b7d44b 100644
> --- a/arch/arm26/defconfig
> +++ b/arch/arm26/defconfig
> @@ -248,7 +248,6 @@ CONFIG_I2C_CHARDEV=y
>  # CONFIG_JBD_DEBUG is not set
>  # CONFIG_FAT_FS is not set
>  # CONFIG_MSDOS_FS is not set
> -# CONFIG_UMSDOS_FS is not set
>  # CONFIG_VFAT_FS is not set
>  # CONFIG_EFS_FS is not set
>  # CONFIG_JFFS_FS is not set
> diff --git a/arch/cris/arch-v10/defconfig b/arch/cris/arch-v10/defconfig
> index 2a3411e..710c20b 100644
> --- a/arch/cris/arch-v10/defconfig
> +++ b/arch/cris/arch-v10/defconfig
> @@ -429,7 +429,6 @@ CONFIG_NET_ETHERNET=y
>  # CONFIG_BFS_FS is not set
>  # CONFIG_FAT_FS is not set
>  # CONFIG_MSDOS_FS is not set
> -# CONFIG_UMSDOS_FS is not set
>  # CONFIG_VFAT_FS is not set
>  # CONFIG_EFS_FS is not set
>  # CONFIG_JFFS_FS is not set
> diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
> index 83e39eb..88766e4 100644
> --- a/include/linux/ncp_fs.h
> +++ b/include/linux/ncp_fs.h
> @@ -148,8 +148,6 @@ struct ncp_nls_ioctl
>  #include <linux/ncp_fs_i.h>
>  #include <linux/ncp_fs_sb.h>
>  
> -/* undef because public define in umsdos_fs.h (ncp_fs.h isn't public) */
> -#undef PRINTK
>  /* define because it is easy to change PRINTK to {*}PRINTK */
>  #define PRINTK(format, args...) printk(KERN_DEBUG format , ## args)
>  
> 
