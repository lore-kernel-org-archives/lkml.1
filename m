Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbXFXXUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbXFXXUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXFXXUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:20:30 -0400
Received: from barikada.upol.cz ([158.194.242.200]:33070 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXFXXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:20:30 -0400
Date: Mon, 25 Jun 2007 01:33:14 +0200
To: Arjan van de Ven <arjan@infradead.org>
Cc: rae l <crquan@gmail.com>, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: memset() with zeroes (Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization)
Message-ID: <20070624233314.GB10398@flower.upol.cz>
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> <20070624222518.GA10398@flower.upol.cz> <1182723318.6819.5.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182723318.6819.5.camel@laptopd505.fenrus.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 03:15:17PM -0700, Arjan van de Ven wrote:
> 
> > > I think all these benefits are the gcc's __builtin_memset optimization
> > > than the explicit call to memset.
> > 
> > ... or from complex memset() implementation (some chips even didn't do
> > `rep' fast enough somehow). Maybe code like below will be acceptable for
> > both optimizers and maintainers?
> 
> 
> we should just alias our memset to the __builtin one, and then provide a
> generic one from lib/ for the cases gcc needs to do a fallback.

In x86_64 there's infrastructure to check and select right memset().
Therefor it's need, i think.

But if one will took a look at usage, zero memset() optimization becomes
obvious, one argument off -- one reg is free from clobbering.

|-*-
flower-:22-rc4-mm2/arch/x86_64$ grep memset -R . | grep "[ 0,]0," | wc -l
42
flower-:22-rc4-mm2/arch/x86_64$
flower-:22-rc4-mm2/arch/x86_64$ cd ..
flower-:22-rc4-mm2/arch$ grep memset -R . | grep "[ 0,]0," | wc -l
735
flower-:22-rc4-mm2/arch$
flower-:22-rc4-mm2$ grep memset -R . | grep "[ 0,]0," | wc -l
6679
flower-:22-rc4-mm2$  
|-*-
____
