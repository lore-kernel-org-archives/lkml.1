Return-Path: <linux-kernel-owner+w=401wt.eu-S1764116AbZDHKQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764116AbZDHKQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZDHKQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:16:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:65387 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684AbZDHKQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QPllHy7Zxlj7hchLG8rvROQk6ZMk9D7LZfO9ezhb1RQPA5VCs0ab+B49Ae5oQ1vabc
         6kUVg+hIzuyzdGVSvF1n9F8TtBZLN4YCdGRsB0GzVUFqzw3YfETmDMFs/UffJ8Cpvw72
         H2oL96YYpIWsKFNXfn2Dw2SOB7LPHLU1Vp0sI=
MIME-Version: 1.0
In-Reply-To: <1237823287-12734-4-git-send-email-philipp.reisner@linbit.com>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-3-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-4-git-send-email-philipp.reisner@linbit.com>
Date: Wed, 8 Apr 2009 15:46:11 +0530
Message-ID: <807b3a220904080316s587ce988qdb47f231c8e90fbc@mail.gmail.com>
Subject: Re: [PATCH 03/12] DRBD: bitmap
From: Nikanth K <nikanth@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Nikanth Karthikesan <knikanth@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 9:17 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> +/* definition of bits in bm_flags */
> +#define BM_LOCKED 0
> +#define BM_MD_IO_ERROR (BITS_PER_LONG-1) /* 31? 63? */

Wonder whether this should be made same for 32-bit as well as 64-bit?
Especially for x86_64 as the machine can become 32-bit to 64-bit or
vice-versa after reboot.


<snip>

> +#if 0
> +#define catch_oob_access_start() do {  \
> +       do {                            \
> +               if ((bm-p_addr) >= PAGE_SIZE/sizeof(long)) { \
> +                       printk(KERN_ALERT "drbd_bitmap.c:%u %s: p_addr:%p bm:%p %d\n", \
> +                                       __LINE__ , __func__ , p_addr, bm, (bm-p_addr)); \
> +                       break;          \
> +               }
> +#define catch_oob_access_end() \
> +       } while (0); } while (0)
> +#else
> +#define catch_oob_access_start() do {
> +#define catch_oob_access_end() } while (0)
> +#endif
> +


Probably should be changed to be based on a config debug option?

<snip>

> +/*
> + * since (b->bm_bits % BITS_PER_LONG) != 0,
> + * this masks out the remaining bits.
> + * Rerturns the number of bits cleared.
> + */
> +STATIC int bm_clear_surplus(struct drbd_bitmap *b)
> +{
> +       const unsigned long mask = (1UL << (b->bm_bits & (BITS_PER_LONG-1))) - 1;

Should BM_MD_IO_ERROR be used instead of  (BITS_PER_LONG-1)?
Or at least this deserves a macro as it is used in many places.


Thanks
Nikanth
