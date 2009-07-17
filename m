Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbZGQGAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbZGQGAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZGQGAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:00:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:52902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbZGQGAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:00:20 -0400
Message-ID: <4A6013F3.1030101@kernel.org>
Date: Fri, 17 Jul 2009 15:02:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Mark virtio_blk with __refdata in virtio_blk.c
References: <b9df5fa10907120413l21761e1cxfc26436481954c2a@mail.gmail.com>
In-Reply-To: <b9df5fa10907120413l21761e1cxfc26436481954c2a@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Jul 2009 06:00:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rakib Mullick wrote:
>  Impact: Fix false positive warning.
> 
> The variable virtio_blk references the function virtblk_probe() (which
> is in .devinit section) and also references the function
> virtblk_remove() ( which is in .devexit section). So, virtio_blk
> simultaneously refers .devinit and .devexit section. To avoid this
> messup, we mark virtio_blk as __refdata.
> 
> We were warned by the following warning:
> 
>   LD      drivers/block/built-in.o
> WARNING: drivers/block/built-in.o(.data+0xc8dc): Section mismatch in
> reference from the variable virtio_blk to the function
> .devinit.text:virtblk_probe()
> The variable virtio_blk references
> the function __devinit virtblk_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/block/built-in.o(.data+0xc8e0): Section mismatch in
> reference from the variable virtio_blk to the function
> .devexit.text:virtblk_remove()
> The variable virtio_blk references
> the function __devexit virtblk_remove()
> If the reference is valid then annotate the
> variable with __exit* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Generally looks good to me.

> +/* We were warned by false positive warning, so __refdata comes into rescue. */
> +static struct virtio_driver __refdata virtio_blk = {

But it would be nicer if the comment contains a bit more of detail.
Can you please beef it up a bit?  After that I'll queue it in my temp
tree and send to Linus' way.

Thanks.

-- 
tejun
