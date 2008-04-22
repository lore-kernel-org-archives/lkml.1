Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbYDVCDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbYDVCDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbYDVCDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:03:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756245AbYDVCD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:03:29 -0400
Date: Mon, 21 Apr 2008 19:03:31 -0700 (PDT)
Message-Id: <20080421.190331.58435430.davem@davemloft.net>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       tsbogend@alpha.franken.de, akpm@linux-foundation.org
Subject: Re: cdrom: use kmalloced buffers instead of buffers on stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <480D46F6.3080305@garzik.org>
References: <200804220100.m3M10sva024025@hera.kernel.org>
	<480D46F6.3080305@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 21 Apr 2008 22:01:26 -0400

> Eh... AFAICS this is only really useful in two of the cases converted.
> 
> For all the other cases (<= 32 bytes), it is _far_ less complex, far 
> less code to simply communicate the additional alignment requirements to 
> the compiler.
> 
> What about __attribute__ __aligned__?  Was that tried?

On some platforms the stack is virtually mapped instead of
from kmalloc or get_free_pages memory.

DMA on stack buffers is really not feasible.
