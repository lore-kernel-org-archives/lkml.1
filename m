Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYDSF4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYDSF4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 01:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYDSF4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 01:56:43 -0400
Received: from www.tglx.de ([62.245.132.106]:51187 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYDSF4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 01:56:43 -0400
Date: Sat, 19 Apr 2008 07:56:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Dubov <oakad@yahoo.com>
cc: linux-kernel@vger.kernel.org, joern@logfs.org, ben@fluff.org
Subject: Re: Smartmedia/xd card support - request for comments
In-Reply-To: <51700.66276.qm@web36708.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.10.0804190724220.3261@apollo.tec.linutronix.de>
References: <51700.66276.qm@web36708.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Alex Dubov wrote:

> mtd_blkdevs breaks the block layer request into separate pages,
> effectively disabling lower layer from making decision based on a
> real data block size, and using dma to any useful extent. What is
> the proposed way to deal with this?

Wrong in two aspects. 

1) it does not break the request into separate pages. It breaks it
into mtd_blktrans_ops->blksize chunks, which is set by the blkdev
user.

2) Using DMA on raw NAND Flash is on per page basis except you have an
"intellegent" controller chip which does the low level handling of the
nand flash itself. Such controllers do not necessarily fit into MTD.

> (By the way, first question already puts us into a "quirk" area of
> the statement "smartmedia are flash chips with quirks". Both
> memorystick and smartmedia are always operated in tandem with their
> controllers, as you could notice.)

I have no idea what you want to tell me. there is no quirk in a
smartmedia card.

Thanks,
	tglx


