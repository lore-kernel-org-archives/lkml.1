Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbXENWLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbXENWLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbXENWLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:11:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54450
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755032AbXENWLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:11:42 -0400
Date: Mon, 14 May 2007 15:11:48 -0700 (PDT)
Message-Id: <20070514.151148.45744375.davem@davemloft.net>
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: slab hang on boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.SOC.4.64.0705142133190.17204@math>
References: <Pine.SOC.4.64.0705142133190.17204@math>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Mon, 14 May 2007 21:36:42 +0300 (EEST)

> Sorry, I could not test the parport patch yet - I did git upgrade as of 
> yesterday and the kernel hangs on boot. boot -p reveals the following 
> slab panic:

Please enable SLUB to work around this for now, SLAB wants
LARGE_ALLOCS enabled when it really shouldn't require that
for a 512K or 1MB SLAB when PAGE_SIZE==8192 :-(

> kmem_cache_create: Early error in slab tsb_512KB
> kernel BUG at mm/slab.c:2165!

Christoph, this is why I had to have LARGE_ALLOCS enabled on sparc64
all this time, for that MAX_OBJ_ORDER logic in mm/slab.c in order
to get 512K and 1MB slab caches usable.

This inconsistency is painful for platforms.  If I enable LARGE_ALLOCS
on sparc64 then SLAB works but it's a total waste for SLUB.

Right now if I enable LARGE_ALLOCS, SLUB will break again due to
that KMALLOC_SHIFT_HIGH bug we fixed the other week, Christophe
can you at least push that fix to Linus if you haven't already?

Thanks.
