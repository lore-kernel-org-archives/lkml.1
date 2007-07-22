Return-Path: <linux-kernel-owner+w=401wt.eu-S932550AbXGVWzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbXGVWzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761733AbXGVWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:55:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:46760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760747AbXGVWzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sXTdD8KGze/H6Gaji7QVLB8MlKwinjBm32LUR7pked8vO1yQbBSoZ5HRGTm1Tkgf5tlIrIv+NKjL7DDdlQxfyiHcdb/mViiF55TIlOtlNg8k9+o5eTOP7ZRe7LBuVkfI57GqxDAnxt3qTbUC7gA20nyocnh6EUKmTQYGemtIfZA=
Subject: Re: [PATCH 2/7] console: fix section mismatch warning in vgacon.c
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707221218130.18493@anakin>
References: <20070720212743.GB25064@uranus.ravnborg.org>
	 <1184974649.4538.4.camel@daplas> <Pine.LNX.4.64.0707221218130.18493@anakin>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 06:55:11 +0800
Message-Id: <1185144911.6370.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 12:20 +0200, Geert Uytterhoeven wrote:
> On Sat, 21 Jul 2007, Antonino A. Daplas wrote:
> > On Fri, 2007-07-20 at 23:27 +0200, Sam Ravnborg wrote:
> > > Fix following section mismatch warning:
> > > WARNING: vmlinux.o(.text+0x121e62): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')
> > > 
> > > Browsing the code it seems that vgacon_scrollback_startup() is only
> > > called during the init phase so the reference to the .init.text
> > > section is OK.
> > > Teach modpost not to warn using ___init_refok.
> > > 
> > > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > Acked-by: Antonino Daplas <adaplas@gmail.com>
> 
> I assume the check for `vga_init_done' in vgacon_startup() is sufficient to
> prevent vgacon_scrollback_startup() from being called later due to
> (un)bind_con_driver()?
> 

Yes.

Tony


