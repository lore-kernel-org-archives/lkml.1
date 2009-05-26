Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZEZLbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZEZLbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZEZLbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:31:36 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33499 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbZEZLbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:31:35 -0400
Date: Tue, 26 May 2009 20:31:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2/2] mtd/maps: uclinux: support Blackfin systems
Message-ID: <20090526113122.GB16835@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
	linux-mtd@lists.infradead.org
References: <1243331191-11445-1-git-send-email-vapier@gentoo.org> <1243331191-11445-2-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243331191-11445-2-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 05:46:31AM -0400, Mike Frysinger wrote:
> diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
> index 57699c2..dcb552f 100644
> --- a/drivers/mtd/maps/uclinux.c
> +++ b/drivers/mtd/maps/uclinux.c
> @@ -55,8 +55,13 @@ static int __init uclinux_mtd_init(void)
>  {
>  	struct mtd_info *mtd;
>  	struct map_info *mapp;
> +#ifdef CONFIG_BLACKFIN
> +	extern unsigned long memory_mtd_start;
> +	unsigned long addr = (unsigned long) memory_mtd_start;
> +#else
>  	extern char _ebss;
>  	unsigned long addr = (unsigned long) &_ebss;
> +#endif
>  
>  	mapp = &uclinux_ram_map;
>  	mapp->phys = addr;

NAK.

I know there's no accounting for taste, but it would be nice to at least
see some minimal amount of effort going in to fixing these things
sanely rather than just lazily shoving ifdefs in wherever possible.

In this case you should just kill all of that crap off, and have the
platforms that use this set uclinux_ram_map up themselves, it's already
a global. Of course you can use _ebss as a default value for
uclinux_ram_map.phys and just override it in your platform.
