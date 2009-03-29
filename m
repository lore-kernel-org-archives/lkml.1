Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZC2Kkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZC2Kkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 06:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZC2KkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 06:40:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:27472 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZC2KkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 06:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gz3mU2Y5M3yvmS59rmCGHUtfisxtA4cmGOKD857NGd8STvnLVChauJbB7i3t43CBtV
         M8Vi2YxfKwr6feDFkejqgstMamRwalAJlnuC7MDnrqJZNvoMne4hvDCbwW0NeDUHCrDd
         0FdMYAHn14kZhzGSX18VWVfcnLtp8u4+xGC9k=
Message-ID: <49CF4FFA.8090904@gmail.com>
Date: Sun, 29 Mar 2009 12:39:54 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: ngupta@vflare.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ed Tomlinson <edt@aei.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xvmalloc memory allocator
References: <49CEEE5A.4080004@vflare.org> <49CEEF30.9060202@vflare.org>
In-Reply-To: <49CEEF30.9060202@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> +static void stat_inc(u64 *value)
> +{
> +    (*value)++;
> +}
> +
> +static void stat_dec(u64 *value)
> +{
> +    (*value)--;
> +}

Why not open code it?

> +
> +static u32 test_flag(struct block_header *block, enum blockflags flag)
> +{
> +    return block->prev & (1 << flag);
> +}
> +
> +static void set_flag(struct block_header *block, enum blockflags flag)
> +{
> +    block->prev |= (1 << flag);
> +}
> +
> +static void clear_flag(struct block_header *block, enum blockflags flag)
> +{
> +    block->prev &= ~(1 << flag);
> +}

Why don't you use test_bit / __set_bit / __clear_bit directly?

> +struct xv_pool *xv_create_pool(void)
> +{
> +    int i;
> +    u32 ovhd_size;
> +    struct xv_pool *pool;
> +
> +    ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
> +    pool = kmalloc(ovhd_size, GFP_KERNEL);
> +    if (!pool)
> +        return NULL;
> +
> +    memset(pool, 0, ovhd_size);

Please use kzalloc.

> +
> +    for (i = 0; i < NUM_FREE_LISTS; i++) {
> +        pool->freelist[i].pagenum = 0;
> +        pool->freelist[i].offset = 0;
> +    }

It was already zeroed by memset.

> +
> +    spin_lock_init(&pool->lock);
> +
> +    return pool;
> +}
> +EXPORT_SYMBOL_GPL(xv_create_pool);
> +
