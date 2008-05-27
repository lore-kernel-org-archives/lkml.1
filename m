Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYE0WIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYE0WIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbYE0WIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:08:07 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48297 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943AbYE0WIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:08:06 -0400
Date: Wed, 28 May 2008 01:05:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 3 29/29] UBIFS: include FS to compilation
Message-ID: <20080527220516.GD11310@cs181133002.pp.htv.fi>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com> <1211810743-18936-30-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1211810743-18936-30-git-send-email-Artem.Bityutskiy@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 05:05:43PM +0300, Artem Bityutskiy wrote:
>...
> --- /dev/null
> +++ b/fs/ubifs/Kconfig
> @@ -0,0 +1,71 @@
> +config UBIFS_FS
> +	tristate "UBIFS file system support"
> +	select CRC16
> +	select CRC32
> +	depends on MTD_UBI
> +	help
> +	  UBIFS is a file system for flash devices which works on top of UBI.
>...
> +config UBIFS_FS_LZO
> +	bool "LZO compression support" if UBIFS_FS_ADVANCED_COMPR
> +	select CRYPTO
> +	select CRYPTO_LZO
> +	depends on UBIFS_FS
> +	default y
> +	help
> +	   LZO compressor is generally faster then zlib but compresses worse.
> +	   Say 'Y' if unsure.
>...

Please change this and similar other options to:

config UBIFS_FS
	tristate "UBIFS file system support"
	select CRC16
	select CRC32
	select CRYPTO if UBIFS_FS_LZO
	select CRYPTO_LZO if UBIFS_FS_LZO
	depends on MTD_UBI
...

config UBIFS_FS_LZO
	bool "LZO compression support" if UBIFS_FS_ADVANCED_COMPR
	depends on UBIFS_FS
...


This way UBIFS_FS=m, UBIFS_FS_LZO=y will only force CRYPTO_LZO=m and not 
CRYPTO_LZO=y.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

