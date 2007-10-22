Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbXJVSu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbXJVSu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXJVSuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:50:21 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:33285 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXJVSuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:50:19 -0400
Date: Mon, 22 Oct 2007 20:50:14 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
In-Reply-To: <20071022112110.105b8e11.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710222044400.7105@anakin>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru>
 <20071021005418.GU8181@ftp.linux.org.uk> <20071021093042.GA2144@martell.zuzino.mipt.ru>
 <20071022152912.GA841@linux-mips.org> <20071022112110.105b8e11.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Andrew Morton wrote:
> On Mon, 22 Oct 2007 16:29:12 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:
> > On Sun, Oct 21, 2007 at 01:30:42PM +0400, Alexey Dobriyan wrote:
> > 
> > > 			irq_flags_t
> > > 	
> > > New type for use with spin_lock_irqsave() and friends.
> > 
> > Talking about it, why did we ever require this to be a long anyway?  I could
> > get away with a single bit for MIPS; the rest of this variable is pure
> > bloat.  An abstract datatype could help finally fix this.
> > 
> 
> Yes, it's always been ugly that we use unsigned long for this rather than
> abstracting it properly.
> 
> However I'd prefer that we have some really good reason for introducing
> irq_flags_t now.  Simply so that I don't needlessly spend the next two
> years wrestling with literally thousands of convert-to-irq_flags_t patches
> and having to type "please use irq_flags_t here" in hundreds of patch
> reviews. (snivel, wimper)

The second part can be fixed easily using
`typedef struct { long x; } irq_flags_t' ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
