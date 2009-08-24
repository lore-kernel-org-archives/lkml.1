Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbZHXGk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbZHXGk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZHXGkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:40:24 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:41326 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZHXGkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <200908241007.58273.ngupta@vflare.org>
References: <200908241007.58273.ngupta@vflare.org>
Date: Mon, 24 Aug 2009 12:10:20 +0530
Message-ID: <d760cf2d0908232340pd8bef7byc76c4d07f09e7d63@mail.gmail.com>
Subject: Re: [PATCH 3/4] compcache: send callback when swap slot is freed
From: Nitin Gupta <ngupta@vflare.org>
To: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:07 AM, Nitin Gupta<ngupta@vflare.org> wrote:

<snip>

> +/*
> + * Sets callback for event when swap_map[offset] == 0
> + * i.e. page at this swap offset is no longer used.
> + */
> +void set_swap_free_notify(struct block_device *bdev,
> +                       swap_free_notify_fn *notify_fn)
> +{
> +       unsigned int i;
> +       struct swap_info_struct *sis;
> +
> +       spin_lock(&swap_lock);
> +       for (i = 0; i <= nr_swapfiles; i++) {
> +               sis = &swap_info[i];
> +               if (!(sis->flags & SWP_USED))
> +                       continue;
> +               if (sis->bdev == bdev)
> +                       break;
> +       }
> +

> +       /* swap device not found */
> +       if (i > nr_swapfiles)
> +               return;

How could I miss this! We need to unlock before this return. I will
send revised diffs once I get additional reviews.


> +
> +       BUG_ON(!sis || sis->swap_free_notify_fn);
> +       sis->swap_free_notify_fn = notify_fn;
> +       spin_unlock(&swap_lock);
> +
> +       return;
> +}
> +EXPORT_SYMBOL_GPL(set_swap_free_notify);
> +


Nitin
