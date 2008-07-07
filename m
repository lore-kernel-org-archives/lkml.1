Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYGGMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYGGMlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYGGMlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:41:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60690 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYGGMlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:41:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/2] swsusp: simplify memory_bm_find_bit()
Date: Mon, 7 Jul 2008 14:43:07 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org
References: <20080705110946.GA17071@localhost.localdomain>
In-Reply-To: <20080705110946.GA17071@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071443.08156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of July 2008, Akinobu Mita wrote:
> The bit obtained by the function memory_bm_find_bit() is represented
> by addr and bit_nr. The callers of memory_bm_find_bit() just use addr
> and bit_nr as the arguments of set_bit/clear_bit/test_bit.
> 
> This patch simplifies the representation of the obtained bit without
> using BM_BITS_PER_CHUNK.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Pavel Machek <pavel@suse.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-pm@lists.linux-foundation.org
> ---
>  kernel/power/snapshot.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: 2.6-git/kernel/power/snapshot.c
> ===================================================================
> --- 2.6-git.orig/kernel/power/snapshot.c
> +++ 2.6-git/kernel/power/snapshot.c
> @@ -478,8 +478,8 @@ static int memory_bm_find_bit(struct mem
>  	}
>  	zone_bm->cur_block = bb;
>  	pfn -= bb->start_pfn;
> -	*bit_nr = pfn % BM_BITS_PER_CHUNK;
> -	*addr = bb->data + pfn / BM_BITS_PER_CHUNK;
> +	*bit_nr = pfn;
> +	*addr = bb->data;
>  	return 0;
>  }

Hm, I think it's better to fold that into patch 2/2.

Thanks,
Rafael
