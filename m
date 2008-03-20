Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYCTSeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYCTSeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYCTSdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:33:55 -0400
Received: from lazybastard.de ([212.112.238.170]:51487 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbYCTSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:33:54 -0400
Date: Thu, 20 Mar 2008 18:35:16 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo van Lil <inguin@gmx.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Memory corruption in block2mtd.c
Message-ID: <20080320173516.GA3977@logfs.org>
References: <47E27680.5070306@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47E27680.5070306@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 March 2008 15:36:48 +0100, Ingo van Lil wrote:
> 
> the block2mtd driver (drivers/mtd/devices/block2mtd.c) will kfree an
> on-stack pointer when handling an invalid argument line (e.g.
> block2mtd=/dev/loop0,xxx).
> 
> The kfree was added some time ago when "name" was dynamically
> allocated.

Good catch.

> Signed-off-by: Ingo van Lil <inguin@gmx.de>
Acked-by: Joern Engel <joern@lazybastard.org>

> ---
> 
> --- linux-2.6.23.1/drivers/mtd/devices/block2mtd.c.orig	2008-03-20 
> 15:13:49.000000000 +0100
> +++ linux-2.6.23.1/drivers/mtd/devices/block2mtd.c	2008-03-20 
> 15:14:09.000000000 +0100
> @@ -408,7 +408,6 @@
>  	if (token[1]) {
>  		ret = parse_num(&erase_size, token[1]);
>  		if (ret) {
> -			kfree(name);
>  			parse_err("illegal erase size");
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Jörn

-- 
It is the mark of an educated mind to be able to entertain a thought
without accepting it.
-- Aristotle
