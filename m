Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYLVXYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYLVXYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYLVXYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:24:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbYLVXYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:24:22 -0500
Date: Mon, 22 Dec 2008 15:23:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: schmitz@opal.biophys.uni-duesseldorf.de,
       linux-fbdev-devel@lists.sourceforge.net, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] fbdev: c2p - Rename c2p to c2p_planar and correct
 indentation
Message-Id: <20081222152359.1e9b2143.akpm@linux-foundation.org>
In-Reply-To: <20081221150123.327017854@mail.of.borg>
References: <20081221150059.844577615@mail.of.borg>
	<20081221150123.327017854@mail.of.borg>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008 16:01:05 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> +    /*
> +     *  Store a full block of planar data after c2p conversion
> +     */
> +
> +static inline void store_planar(void *dst, u32 dst_inc, u32 bpp, u32 d[8])
> +{
> +	int i;
> +
> +	for (i = 0; i < bpp; i++, dst += dst_inc)
> +		*(u32 *)dst = d[perm_c2p_32x8[i]];
> +}
> +
> +
> +    /*
> +     *  Store a partial block of planar data after c2p conversion
> +     */
> +
> +static inline void store_planar_masked(void *dst, u32 dst_inc, u32 bpp,
> +				       u32 d[8], u32 mask)
> +{
> +	int i;
> +
> +	for (i = 0; i < bpp; i++, dst += dst_inc)
> +		*(u32 *)dst = comp(d[perm_c2p_32x8[i]], *(u32 *)dst, mask);
> +}

Why not just make the first arg of these (too large to be inlined)
functions have type u32*, then do away with the casts?

