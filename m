Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbXFSOO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbXFSOO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXFSOOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:14:18 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39534 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752462AbXFSOOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:14:16 -0400
Date: Tue, 19 Jun 2007 15:19:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Linas Vepstas <linas@austin.ibm.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070619151919.79c79af1@the-village.bc.nu>
In-Reply-To: <4677E3BC.3040307@ru.mvista.com>
References: <20070618175713.GD5836@austin.ibm.com>
	<20070618212704.394912b8@the-village.bc.nu>
	<20070618204601.GF5836@austin.ibm.com>
	<20070618220441.3a3af8ca@the-village.bc.nu>
	<4677E3BC.3040307@ru.mvista.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 18:10:04 +0400
Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Hello.
> 
> Alan Cox wrote:
> >>I can prepare a patch, but only with a lot of guidance. I can test 
> >>& debug, I'm highly motivated just right now ... 
> 
> > If you've got a nice repeatable problem please try using the libata
> > driver. That handles the error paths differently and doesn't try a FIFO
> > drain which might matter in this case I guess.
> 
>     FIFO drain for DMA commands?

Welcome to the old IDE layer which I am so glad I left behind 8)

ide_ata_error will try and do a PIO flush regardless of the command type
if DRQ_STAT is asserted. See ide_dma_intr -> ide_error -> ...

Alan
