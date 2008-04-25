Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbYDYQOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbYDYQOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762720AbYDYQOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:14:14 -0400
Received: from waste.org ([66.93.16.53]:41303 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762133AbYDYQON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:14:13 -0400
Subject: Re: [PATCH 1/1] [mm/slob] fix bug - when slob allocates "struct
	kmem_cache", it does not force alignment.
From: Matt Mackall <mpm@selenic.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       Yi Li <yi.li@analog.com>, Christoph Lameter <christoph@lameter.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1209121041-30524-1-git-send-email-cooloney@kernel.org>
References: <1209121041-30524-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 11:10:22 -0500
Message-Id: <1209139823.5323.5.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 18:57 +0800, Bryan Wu wrote:
> From: Yi Li <yi.li@analog.com>
> 
> This may trigger misaligned memory access exception.
> 
> Signed-off-by: Yi Li <yi.li@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Looks good, thanks. Christoph, do you want to take this or should it go
through Andrew?

Acked-by: Matt Mackall <mpm@selenic.com>

> ---
>  mm/slob.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slob.c b/mm/slob.c
> index e2c3c0e..6038cba 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -533,7 +533,8 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>  {
>  	struct kmem_cache *c;
>  
> -	c = slob_alloc(sizeof(struct kmem_cache), flags, 0, -1);
> +	c = slob_alloc(sizeof(struct kmem_cache),
> +		flags, ARCH_KMALLOC_MINALIGN, -1);
>  
>  	if (c) {
>  		c->name = name;
-- 
Mathematics is the supreme nostalgia of our time.

