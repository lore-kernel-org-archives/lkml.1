Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881Ab0ASR6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0ASR6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631Ab0ASR6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:58:51 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:60205 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab0ASR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:58:50 -0500
Date: Tue, 19 Jan 2010 11:57:15 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/37] move round_up/down to kernel.h
In-Reply-To: <1263611228-6751-23-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001191155540.22304@router.home>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-23-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Yinghai Lu wrote:

>
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>
> +/*
> + * This looks more complex than it should be. But we need to
> + * get the type for the ~ right in round_down (it needs to be
> + * as wide as the result!), and we want to evaluate the macro
> + * arguments just once each.
> + */
> +#define __round_mask(x,y) ((__typeof__(x))((y)-1))
> +#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
> +#define round_down(x,y) ((x) & ~__round_mask(x,y))
> +
>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))

Note the last two lines! We already have roundup(), DIV_ROUND_UP and
DIV_ROUND_CLOSEST. Please integrate them properly. Maybe extract
__round_mask() from all of them.

