Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXJRTV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXJRTV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933529AbXJRTUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:20:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34934 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933499AbXJRTUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:20:54 -0400
Message-ID: <4717B1FC.6040907@garzik.org>
Date: Thu, 18 Oct 2007 15:20:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, David Miller <davem@davemloft.net>,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <20071018082145.GK5063@kernel.dk> <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Very few drivers should care so much about the *page* itself (or the 
> offset). That's something that the generic allocation code etc cares 
> about, but the driver is almost bound to care mostly about the actual DMA 
> address, so adding that helper function that abstracts the sg access would 
> be helpful in hiding some of the cruft?


FWIW libata cares about both.  When doing DMA, it cares about the DMA 
address.  When doing PIO, it cares about the actual page, because it 
does a kmap before sending the data through a 16-bit/32-bit data FIFO.

	Jeff


