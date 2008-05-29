Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYE2VeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYE2VeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbYE2VeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:34:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49614 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754611AbYE2VeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:34:04 -0400
Date: Thu, 29 May 2008 22:19:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
Message-ID: <20080529221922.48c9fcb8@core>
In-Reply-To: <alpine.LFD.1.10.0805291403030.3873@woody.linux-foundation.org>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
	<483EEBE5.5030708@garzik.org>
	<20080529191920.12609c32@core>
	<alpine.LFD.1.10.0805291403030.3873@woody.linux-foundation.org>
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

> 	void ata_sff_pause(struct ata_port *ap)
> 	{
> 		ata_sff_altstatus();
> 		ndelay(400);
> 	}
> 
> and again, if there is no altstatus register, that's a low-level driver 
> issue.

This takes away the ability to shoot yourself directly in the foot and
replaces it with the ability to shoot yourself in the foot in a more
abstract way. The dma_pause case still needs to check as that is the one
where you can make an actual mess but yes it certainly cleans up the
others.

(Next rev brewing ;))
