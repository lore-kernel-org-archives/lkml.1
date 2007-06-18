Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbXFRUQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbXFRUQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbXFRUQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:16:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:58266 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763AbXFRUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SkK215kP4DE2tQC5MsgfCR4WUD6keOJy4ITtfXKpLatkBRTOuv33bm7K9p7ktcO/yRjdhqtQyRbeG5vUxFGe1VMPu6AD6+1ppjC8kml0auuLY/brdtIsNF/+b2i88KgrJnChuZ+4awxdTW4Y5ff39i2526y2DorB73at1UFcolE=
Message-ID: <84144f020706181316u70145db2i786641d265e5bc42@mail.gmail.com>
Date: Mon, 18 Jun 2007 23:16:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 05/26] Slab allocators: Cleanup zeroing allocations
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
In-Reply-To: <20070618095914.622685354@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <20070618095914.622685354@sgi.com>
X-Google-Sender-Auth: 7510020b22cd2ef3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> +static inline void *kmem_cache_zalloc(struct kmem_cache *k, gfp_t flags)
> +{
> +       return kmem_cache_alloc(k, flags | __GFP_ZERO);
> +}
> +
> +static inline void *__kzalloc(int size, gfp_t flags)
> +{
> +       return kmalloc(size, flags | __GFP_ZERO);
> +}

Hmm, did you check kernel text size before and after this change?
Setting the __GFP_ZERO flag at every kzalloc call-site seems like a
bad idea.
