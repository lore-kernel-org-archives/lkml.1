Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbXF2Uqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbXF2Uqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXF2Uqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:46:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbXF2Uqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:46:39 -0400
Date: Fri, 29 Jun 2007 13:45:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com, hugh@veritas.com,
       James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
Message-Id: <20070629134529.3e12a131.akpm@linux-foundation.org>
In-Reply-To: <20070629131657.5ecc3baa@the-village.bc.nu>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
	<20070628.220606.112621271.davem@davemloft.net>
	<20070628222424.4cbae90c.akpm@linux-foundation.org>
	<20070628.223734.21928089.davem@davemloft.net>
	<20070628224519.1a3319c3.akpm@linux-foundation.org>
	<20070629131657.5ecc3baa@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 13:16:57 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > If those operations involve modifying that slab page's pageframe then what
> > stops concurrent dma'ers from stomping on each other's changes?  As in:
> > why aren't we already buggy?
> 
> Or DMA operations falling out with CPU operations in the same memory
> area. Not all platforms have hardware consistency and some will blat the
> entire page out of cache.

Is that just a performance problem, or can data be lost here?  It depends
on the meaning of "blat": writeback?  invalidate?  More details, please.


I'm dyin here and nobody will talk to me.  If the kernel is already doing
these things, why aren't we already buggy?  Is it because we don't actually
modify the pageframes of these dma-to-from-kmalloced pages?  But we were
thinking of doing so in the future?
