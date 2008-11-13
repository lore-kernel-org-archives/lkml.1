Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYKMNny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYKMNny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYKMNnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:43:46 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:53918 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYKMNnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:43:45 -0500
Date: Thu, 13 Nov 2008 22:43:50 +0900 (JST)
Message-Id: <20081113.224350.18312549.anemo@mba.ocn.ne.jp>
To: vapier@gentoo.org
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 18:38:53 -0500, Mike Frysinger <vapier@gentoo.org> wrote:
> Rather than having every map/mtd driver doing the same sequence of
> registering partitions and/or devices, implement common parse_mtd().
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/mtd/mtdcore.c   |   37 +++++++++++++++++++++++++++++++++++++
>  include/linux/mtd/mtd.h |    3 +++
>  2 files changed, 40 insertions(+), 0 deletions(-)

I like this idea.

> +int parse_mtd(struct mtd_info *mtd, const char **probe_types,
> +              struct mtd_partition *parts, int nr_parts)
> +{
> +#ifdef CONFIG_MTD_PARTITIONS
> +	const char *default_part_probe_types[] = {
> +		"cmdlinepart",
> +		"RedBoot",
> +		NULL
> +	};

But I'm not sure this default_part_probe_types is appropriate.

How about enclose each parser with #ifdefs?

	const char *default_part_probe_types[] = {
#ifdef CONFIG_MTD_CMDLINE_PARTS
		"cmdlinepart",
#endif
#ifdef CONFIG_MTD_REDBOOT_PARTS
		"RedBoot",
#endif
		NULL
	};

This get rid of "RedBoot partition parsing not available" noise in
boot message when you use default_part_probe_types without
MTD_REDBOOT_PARTS.

---
Atsushi Nemoto
