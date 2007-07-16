Return-Path: <linux-kernel-owner+w=401wt.eu-S1764787AbXGPMRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764787AbXGPMRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbXGPMRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:17:33 -0400
Received: from brick.kernel.dk ([80.160.20.94]:16947 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbXGPMRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:17:32 -0400
Date: Mon, 16 Jul 2007 14:16:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Message-ID: <20070716121649.GI5195@kernel.dk>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be> <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de> <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be> <1184340528.3402.32.camel@localhost.localdomain> <Pine.LNX.4.62.0707132212520.23000@chinchilla.sonytel.be> <Pine.LNX.4.62.0707161338230.1072@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0707161338230.1072@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16 2007, Geert Uytterhoeven wrote:
> On Fri, 13 Jul 2007, Geert Uytterhoeven wrote:
> > Ah, that explains it. flush_dcache_page() is used in some drivers.
> > I'll update my patches. Thanks for the comments!
> 
> Does this look OK?
>   - Replaced KM_USER0 by KM_IRQ0 (all routines are either called from an
>     interrupt handler, from .request_fn (ps3disk), or from .queuecommand
>     (ps3rom))

That looks good.

>   - Add a call to flush_kernel_dcache_page() in routines that write to buffers

Hmm, I would have thought a flush_dcache_page() would be more
appropriate, the backing could be page cache pages.

-- 
Jens Axboe

