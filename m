Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYLKQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYLKQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYLKQZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:25:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756429AbYLKQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:25:12 -0500
Date: Thu, 11 Dec 2008 08:25:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Brueckl <ib@wupperonline.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] console ASCII glyph 1:1 mapping
In-Reply-To: <4940441e@wupperonline.de>
Message-ID: <alpine.LFD.2.00.0812110823320.3340@localhost.localdomain>
References: <4940441e@wupperonline.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm. I bounced both your patches to Peter, since they look valid but I 
want somebody who knows this code better to ack them. 

Peter - is there somebody else who should double-check these things, or 
can you ack them?

		Linus

On Wed, 10 Dec 2008, Ingo Brueckl wrote:
>
> For the console, there is a 1:1 mapping of glyphs which cannot be found 
> in the current font. This seems to be meant as a kind of 'emergency 
> fallback' for fonts without unicode mapping which otherwise would 
> display nothing readable on the screen.
> 
> At the moment it affects all chars for which no substitution character 
> is defined. In particular this means that for all chars (>= 128) where 
> there is no iso88591-1/unicode character (e.g. control character area) 
> you'll get the very strange 1:1 mapping of the (cp437) graphics card 
> glyphs.
> 
> I'm pretty sure that the 1:1 mapping should only affect strict ASCII 
> code characters, i.e. chars < 128.
> 
> The patch limits the mapping as it probably was meant anyway.
> 
> Signed-off-by: Ingo Brueckl <ib@wupperonline.de>
> 
> --- linux-2.6.27.8.orig/drivers/char/vt.c	2008-12-05 21:03:02.000000000 +0100
> +++ linux-2.6.27.8/drivers/char/vt.c	2008-12-10 20:51:30.000000000 +0100
> @@ -2287,7 +2287,7 @@ rescan_last_byte:
>  				    continue; /* nothing to display */
>  				}
>  				/* Glyph not found */
> -				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) || c < 128) && !(c & ~charmask)) {
> +				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) && c < 128) && !(c & ~charmask)) {
>  				    /* In legacy mode use the glyph we get by a 1:1 mapping.
>  				       This would make absolutely no sense with Unicode in mind,
>  				       but do this for ASCII characters since a font may lack
> 
