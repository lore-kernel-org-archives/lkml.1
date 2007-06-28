Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbXF1WUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbXF1WUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759668AbXF1WUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:20:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52036 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753035AbXF1WUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:20:12 -0400
Date: Thu, 28 Jun 2007 23:25:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
Message-ID: <20070628232537.02ced21c@the-village.bc.nu>
In-Reply-To: <20070628132947.e3378811.akpm@linux-foundation.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
	<20070628110644.a530cfef.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282017450.30789@anakin>
	<20070628113819.c24e592d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282044360.30789@anakin>
	<20070628132947.e3378811.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> check_signature() needs readb() but with some setups (s390, m68k allmodconfig)
> there is no implementation of readb.  This causes build errors with
> -Werror-implicit-function-declaration.

This completely bogus. readb() should be present on M68K, fix the
platform to implement readb() for MMIO, even if your MMIO readb is a
moveb instruction.

check_signature is relevant for anything with MMIO space (for example you
can legitimately want to check_signature a MAC68K Nubus ROM).

S/390 is a bit of a special case as no S/390 usage of check_signature
appears sane but equally it isn't used so you can stub it out.

Alan
