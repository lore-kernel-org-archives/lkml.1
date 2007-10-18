Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbXJRAsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbXJRAsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbXJRAr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:47:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39670
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756966AbXJRAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:47:57 -0400
Date: Wed, 17 Oct 2007 17:47:56 -0700 (PDT)
Message-Id: <20071017.174756.74746737.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dan.j.williams@intel.com,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 5/5] I/OAT: Add completion callback for async_tx
 interface use
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071017174438.f0d6fe2e.akpm@linux-foundation.org>
References: <20071018001416.31147.86176.stgit@localhost.localdomain>
	<20071018001439.31147.52329.stgit@localhost.localdomain>
	<20071017174438.f0d6fe2e.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 17 Oct 2007 17:44:38 -0700

> On Wed, 17 Oct 2007 17:14:39 -0700
> Shannon Nelson <shannon.nelson@intel.com> wrote:
> 
> > +	tx->callback = (void *)ioat_dma_test_callback;
> 
> and when I remove this cast I get
> 
> drivers/dma/ioat_dma.c: In function 'ioat_dma_self_test':
> drivers/dma/ioat_dma.c:718: warning: assignment from incompatible pointer type
> 
> because ioat_dma_test_callback isn't void-returning.  Something is wrong
> here.  I assume that ioat_dma_test_callback() should just be
> void-returning?

In fact this might crash on systems that conditionally pop
return values based upon whether the function is void or not.
