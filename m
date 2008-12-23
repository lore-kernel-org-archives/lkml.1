Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbYLWICj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbYLWICj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 03:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYLWICa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 03:02:30 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:60642 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYLWICa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 03:02:30 -0500
Date: Tue, 23 Dec 2008 09:02:24 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: schmitz@opal.biophys.uni-duesseldorf.de,
       linux-fbdev-devel@lists.sourceforge.net, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] fbdev: c2p - Rename c2p to c2p_planar and correct
 indentation
In-Reply-To: <20081222152359.1e9b2143.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812230857390.17497@anakin>
References: <20081221150059.844577615@mail.of.borg> <20081221150123.327017854@mail.of.borg>
 <20081222152359.1e9b2143.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Andrew Morton wrote:
> On Sun, 21 Dec 2008 16:01:05 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > +    /*
> > +     *  Store a full block of planar data after c2p conversion
> > +     */
> > +
> > +static inline void store_planar(void *dst, u32 dst_inc, u32 bpp, u32 d[8])
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < bpp; i++, dst += dst_inc)
> > +		*(u32 *)dst = d[perm_c2p_32x8[i]];
> > +}
> > +
> > +
> > +    /*
> > +     *  Store a partial block of planar data after c2p conversion
> > +     */
> > +
> > +static inline void store_planar_masked(void *dst, u32 dst_inc, u32 bpp,
> > +				       u32 d[8], u32 mask)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < bpp; i++, dst += dst_inc)
> > +		*(u32 *)dst = comp(d[perm_c2p_32x8[i]], *(u32 *)dst, mask);
> > +}
> 
> Why not just make the first arg of these (too large to be inlined)
> functions have type u32*, then do away with the casts?

If I make dst u32 *, then "dst += dst_inc" needs even more ugly casting
(dst_inc is not always a multiple of 4).

Anyway, as it may be an unaligned access, I'll switch to {get,put}_unaligned(),
which has the side effect of hiding the casts.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
