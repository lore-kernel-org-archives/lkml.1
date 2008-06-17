Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYFQMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYFQMXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbYFQMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:23:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55466 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbYFQMXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:23:06 -0400
Date: Tue, 17 Jun 2008 14:23:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
Message-ID: <20080617122346.GA10598@uranus.ravnborg.org>
References: <1213565555.26255.522.camel@pmac.infradead.org> <1213604973-7073-1-git-send-email-jacmet@sunsite.dk> <1213617663.26255.708.camel@pmac.infradead.org> <20080616121727.GB10854@cs181133002.pp.htv.fi> <1213619214.26255.721.camel@pmac.infradead.org> <20080617084235.GA20169@cs181133002.pp.htv.fi> <1213696004.26255.960.camel@pmac.infradead.org> <20080617101112.GE20169@cs181133002.pp.htv.fi> <1213702113.26255.996.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213702113.26255.996.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 12:28:33PM +0100, David Woodhouse wrote:
> On Tue, 2008-06-17 at 13:11 +0300, Adrian Bunk wrote:
> > The pattern for this stuff is to provide a HAVE_AOUT kconfig variable 
> > that gets select'ed by these architectures.
> 
> http://git.infradead.org/users/dwmw2/aout-2.6.git?a=commitdiff;h=a5db5179
> 
> Subject: [PATCH] Introduce HAVE_AOUT symbol to remove hard-coded arch list for BINFMT_AOUT
> 
> HAVE_AOUT doesn't quite do the same thing as the recently removed
> ARCH_SUPPORTS_AOUT config option. That was set even on platforms where
> binfmt_aout isn't supported, although it's not entirely clear why.
> 
> So it's best just to introduce a new symbol, handled consistently with
> other similar HAVE_xxx symbols; with a simple 'select' the arch Kconfig.

Looks good.
One minor issue...


> @@ -7,6 +7,7 @@ config ALPHA
>  	default y
>  	select HAVE_IDE
>  	select HAVE_OPROFILE
> +	select HAVE_AOUT
Sorting these alphabetically will result in less merge conflicts when the list grows.

	Sam
