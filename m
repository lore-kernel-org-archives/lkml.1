Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976Ab0ATUyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0ATUyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509Ab0ATUyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:54:37 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:56627 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab0ATUyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:54:37 -0500
Date: Wed, 20 Jan 2010 14:52:56 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/37] move round_up/down to kernel.h
In-Reply-To: <4B57675E.7070309@kernel.org>
Message-ID: <alpine.DEB.2.00.1001201451430.17915@router.home>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-23-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191155540.22304@router.home> <4B57675E.7070309@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Yinghai Lu wrote:

> like this, using DIVIDE for all ?

I liked the __round_mask better


> -#define __round_mask(x,y) ((__typeof__(x))((y)-1))
> -#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
> -#define round_down(x,y) ((x) & ~__round_mask(x,y))
> +#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> +#define rounddown(x, y) (((x) / (y)) * (y))

> +#define round_up(x,y) roundup(x,y)
> +#define round_down(x,y) rounddown(x,y)

Why two aliases? Make the use consistent throughout the source.

