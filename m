Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZIOKEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZIOKEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZIOKEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:04:25 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58875 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZIOKEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OcwKJuvSObr7hs/8UHoLuQtjuxNqVv52L52mslly0B3AqA8JtOASI7HyEP7cuzmevk
         lPmJpV3eVANTqXzKe9L1as64PjuxSe1DNQFcPw3bEpjt/fadXSUyz9WU+6X9XpJQWORD
         tqdNS7rEYIaIEG7SQXH2MOvtgIIznysGI+vqY=
MIME-Version: 1.0
In-Reply-To: <20090915090319.GA25990@elte.hu>
References: <alpine.DEB.2.00.0909142025290.5303@melkki.cs.helsinki.fi>
	 <20090915090319.GA25990@elte.hu>
Date: Tue, 15 Sep 2009 13:04:26 +0300
X-Google-Sender-Auth: 249d2dcf30b42d48
Message-ID: <84144f020909150304x64bfa6e7m44090c50ddc59212@mail.gmail.com>
Subject: Re: [origin tree build failure] [PATCH] slub: Fix build error in 
	kmem_cache_open() with !CONFIG_SLUB_DEBUG
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       aaro.koskinen@nokia.com, amwang@redhat.com, dfeng@redhat.com,
       eric.dumazet@gmail.com, fengguang.wu@intel.com,
       Larry.Finger@lwfinger.net, rientjes@google.com,
       yanmin_zhang@linux.intel.com, zdenek.kabelac@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Sep 15, 2009 at 12:03 PM, Ingo Molnar <mingo@elte.hu> wrote:
> From 817eb1b8da641984334db46a486ad2f867daa803 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 15 Sep 2009 11:00:26 +0200
> Subject: [PATCH] slub: Fix build error in kmem_cache_open() with !CONFIG_SLUB_DEBUG
>
> This build bug:
>
>  mm/slub.c: In function 'kmem_cache_open':
>  mm/slub.c:2476: error: 'disable_higher_order_debug' undeclared (first use in this function)
>  mm/slub.c:2476: error: (Each undeclared identifier is reported only once
>  mm/slub.c:2476: error: for each function it appears in.)
>
> Triggers because there's no !CONFIG_SLUB_DEBUG definition for
> disable_higher_order_debug.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  mm/slub.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 417ed84..be6e1e0 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1071,6 +1071,8 @@ static inline unsigned long kmem_cache_flags(unsigned long objsize,
>  }
>  #define slub_debug 0
>
> +#define disable_higher_order_debug 0
> +
>  static inline unsigned long slabs_node(struct kmem_cache *s, int node)
>                                                        { return 0; }
>  static inline unsigned long node_nr_slabs(struct kmem_cache_node *n)

Oh, sorry about that. I'll merge the patch and send it to Linus later
this evening. Thanks!

                        Pekka
