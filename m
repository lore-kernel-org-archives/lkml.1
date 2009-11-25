Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbZKYS1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbZKYS1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759058AbZKYS1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:27:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1172 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759016AbZKYS1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:27:11 -0500
Subject: Re: [PATCH] SLUB: Fix __GFP_ZERO unlikely() annotation
From: Joe Perches <joe@perches.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1259173279-21220-1-git-send-email-penberg@cs.helsinki.fi>
References: <1259173279-21220-1-git-send-email-penberg@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 10:27:16 -0800
Message-ID: <1259173636.29779.41.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 20:21 +0200, Pekka Enberg wrote:
> The unlikely() annotation in slab_alloc() covers too much of the expression.
> It's actually very likely that the object is not NULL so use unlikely() only
> for the __GFP_ZERO expression like SLAB does.
[]
> +++ b/mm/slub.c
> @@ -1735,7 +1735,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
> -	if (unlikely((gfpflags & __GFP_ZERO) && object))
> +	if (unlikely(gfpflags & __GFP_ZERO) && object)
>  		memset(object, 0, objsize);

so why not use

	if (unlikely(gfpflags & __GFP_ZERO) && likely(object))


