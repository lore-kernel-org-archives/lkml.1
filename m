Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZHDDdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZHDDdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 23:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZHDDdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 23:33:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZHDDdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 23:33:50 -0400
Date: Mon, 3 Aug 2009 23:33:32 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, benh@kernel.crashing.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, paulus@samba.org,
       williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090804033332.GJ28572@bombadil.infradead.org>
References: <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu> <20090802201132.GE28572@bombadil.infradead.org> <20090802204701.GE25334@ghostprotocols.net> <20090803015430.GG25334@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803015430.GG25334@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 10:54:30PM -0300, Arnaldo Carvalho de Melo wrote:
> The problem is that at least on f11, libbfd.so is a... linker script,
> not an ELF shared library as the name seemed to imply.
> 

Ugh, that's weird. My fedora boxes are the same, but it's correctly a
symlink on my Debian box.
lrwxrwxrwx 1 root root     26 Aug  3 23:30 /usr/lib/libbfd.so ->
libbfd-2.19.51.20090723.so

Kind of strange it's a reference to bfd.a too. :/

> But if I cheat and do a dlopen on the full name, that includes the
> version, it works. Argh, I don't know why this has to be so contorted,
> does anybody here understands this?
> 
> Anyway, the reworked patch below works and additionally doesn't dlopens
> at each DSO, but just once and only if it finds a symbol starting with
> an underscore, an heuristic to avoid loading bfd if we don't need it.
> 

Looks better than mine. :)

cheers, Kyle
