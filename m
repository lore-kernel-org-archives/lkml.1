Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYE2Ud0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYE2Ud0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYE2UdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:33:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49772 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbYE2UdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:33:14 -0400
Date: Thu, 29 May 2008 21:18:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
Message-ID: <20080529211849.59aafbc0@core>
In-Reply-To: <alpine.LFD.1.10.0805291245330.2958@woody.linux-foundation.org>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
	<20080529190235.258d304e@core>
	<483EF536.90801@garzik.org>
	<20080529193813.4bc0a677@core>
	<alpine.LFD.1.10.0805291245330.2958@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The old function oopsed for the case that you worry about. That is WORSE 
> than anything else you can come up with. There is absolutely zero upside 
> to using that old and broken thing.

The worst case is uncaught data corruption. An oops is harmless in
comparison. Someone using altstatus to enforce DMA timing barriers and
getting nothing else will find their disk contents 'degraded'.

I'm just putting together a patch that removes ata_altstatus entirely
from public use, and that actually looks far nicer.
