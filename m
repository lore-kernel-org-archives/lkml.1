Return-Path: <linux-kernel-owner+w=401wt.eu-S1765602AbXF2MMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765602AbXF2MMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762255AbXF2MMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:12:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43038 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761423AbXF2MMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:12:08 -0400
Date: Fri, 29 Jun 2007 13:16:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com, hugh@veritas.com,
       James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
Message-ID: <20070629131657.5ecc3baa@the-village.bc.nu>
In-Reply-To: <20070628224519.1a3319c3.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
	<20070628.220606.112621271.davem@davemloft.net>
	<20070628222424.4cbae90c.akpm@linux-foundation.org>
	<20070628.223734.21928089.davem@davemloft.net>
	<20070628224519.1a3319c3.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If those operations involve modifying that slab page's pageframe then what
> stops concurrent dma'ers from stomping on each other's changes?  As in:
> why aren't we already buggy?

Or DMA operations falling out with CPU operations in the same memory
area. Not all platforms have hardware consistency and some will blat the
entire page out of cache.

