Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbXJ3KEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbXJ3KEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 06:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXJ3KDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 06:03:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37835 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753236AbXJ3KDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 06:03:51 -0400
Date: Tue, 30 Oct 2007 10:05:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
Subject: Re: sata_nv and dynamically changing DMA mask?
Message-ID: <20071030100542.3efe01ee@the-village.bc.nu>
In-Reply-To: <4726B064.3000906@shaw.ca>
References: <4726B064.3000906@shaw.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 22:17:40 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> In the sata_nv driver, when running in ADMA mode, we can do 64-bit DMA. 
> However, when an ATAPI device like a DVD drive is connected, we can't 
> use ADMA mode, and so we have to abide by the restrictions of a normal 
> SFF ATA controller and can only do 32-bit DMA. We detect this and try to 
> set the blk_queue_bounce_limit, blk_queue_segment_boundary and 
> blk_queue_max_hw_segments to the values corresponding to a normal SFF 
> controller.

What about the DMA padding buffer from nv_adma_port_start and internal
buffers for commands like request sense that don't come via the request
queue directly.

Also it seems nv_adma_use_reg_mode() can decide to send other commands
via the non ADMA interface even for ATA devices. Are we 100% certain it
never decides to let through a command with DMA via the register
interface in this case - what do you see if you instrument the function ?

Alan
