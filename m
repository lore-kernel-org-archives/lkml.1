Return-Path: <linux-kernel-owner+w=401wt.eu-S1763815AbXGPVjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763815AbXGPVjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbXGPVjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:39:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:50358 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbXGPVjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:39:35 -0400
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.62.0707161515460.1072@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
	 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
	 <1184335333.3402.20.camel@localhost.localdomain>
	 <200707131619.54898.arnd@arndb.de>
	 <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
	 <1184340528.3402.32.camel@localhost.localdomain>
	 <Pine.LNX.4.62.0707132212520.23000@chinchilla.sonytel.be>
	 <Pine.LNX.4.62.0707161338230.1072@pademelon.sonytel.be>
	 <20070716121649.GI5195@kernel.dk>
	 <Pine.LNX.4.62.0707161459010.1072@pademelon.sonytel.be>
	 <Pine.LNX.4.62.0707161515460.1072@pademelon.sonytel.be>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 07:38:48 +1000
Message-Id: <1184621929.25235.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Upon closer look, while flush_kernel_dcache_page() is a no-op on ppc64,
> flush_dcache_page() isn't. So I'd prefer to not call it if not really needed.
> 
> And according to James, flush_kernel_dcache_page() should be sufficient...
> 
> So I'm getting puzzled again...

flush_dcache_page() handles icache vs. dcache coherency by clearing the
PG_arch_1 bit in the struct page that indicates that the page is cache
clean.

You -must- call it if you're going to use any form of CPU access to
write to the page (basically dirtying the data cache) and that page can
be ever mapped into user space and executed from.

I don't know what flush_kernel_dcache_page() does and if it needs a
similar treatement, it's a new interface, so maybe Jens and or James can
tell me more about it..

Cheers,
Ben.

