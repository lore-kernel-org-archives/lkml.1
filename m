Return-Path: <linux-kernel-owner+w=401wt.eu-S932610AbXF1Wvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbXF1Wvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765495AbXF1WvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:51:18 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1823 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765395AbXF1WvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:51:17 -0400
Date: Fri, 29 Jun 2007 00:51:31 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
In-Reply-To: <20070628232537.02ced21c@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706290048290.1817@scrub.home>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
 <20070628110644.a530cfef.akpm@linux-foundation.org> <Pine.LNX.4.64.0706282017450.30789@anakin>
 <20070628113819.c24e592d.akpm@linux-foundation.org> <Pine.LNX.4.64.0706282044360.30789@anakin>
 <20070628132947.e3378811.akpm@linux-foundation.org> <20070628232537.02ced21c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 28 Jun 2007, Alan Cox wrote:

> > check_signature() needs readb() but with some setups (s390, m68k allmodconfig)
> > there is no implementation of readb.  This causes build errors with
> > -Werror-implicit-function-declaration.
> 
> This completely bogus. readb() should be present on M68K, fix the
> platform to implement readb() for MMIO, even if your MMIO readb is a
> moveb instruction.
> 
> check_signature is relevant for anything with MMIO space (for example you
> can legitimately want to check_signature a MAC68K Nubus ROM).

A generic check_signature() is a little difficult if we have separate io 
functions for every bus.

bye, Roman
