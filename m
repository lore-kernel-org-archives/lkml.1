Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024Ab0AUUtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab0AUUtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423Ab0AUUtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:49:33 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:36277 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0AUUtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:49:32 -0500
Date: Thu, 21 Jan 2010 14:48:24 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/36] move round_up/down to kernel.h
In-Reply-To: <1264055303-15123-23-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001211446430.13130@router.home>
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org> <1264055303-15123-23-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Yinghai Lu wrote:

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

So we are back to the earlier version.

Two functions doing the same thing. round_up and roundup.

If they are different(are they really used that way?) then they should
have names that emphasize the difference.

