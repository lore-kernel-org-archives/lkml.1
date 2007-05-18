Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbXERFWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbXERFWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 01:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbXERFWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 01:22:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45447
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbXERFWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 01:22:14 -0400
Date: Thu, 17 May 2007 22:22:17 -0700 (PDT)
Message-Id: <20070517.222217.112287075.davem@davemloft.net>
To: npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070518051238.GA7696@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de>
	<20070517.214740.51856086.davem@davemloft.net>
	<20070518051238.GA7696@wotan.suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Fri, 18 May 2007 07:12:38 +0200

> The page->virtual thing is just a bonus (although have you seen what
> sort of hoops SPARSEMEM has to go through to find page_address?! It
> will definitely be a win on those architectures).

If you set the bit ranges in asm/sparsemem.h properly, as I
have currently on sparc64, it isn't bad at all.  It's a
single extra dereference from a table that sits in the main
kernel image and thus is in a locked TLB entry.

SPARSEMEM_EXTREME is pretty much unnecessary and with the
virtual mem-map stuff the sparsemem overhead goes away entirely
and we're back to "page - mem_map" type simple calculations
obviating any dereferencing advantage from page->virtual.

> 0.2% of memory, or 2MB per GB. But considering we already use 14MB per
> GB for the page structures, it isn't like I'm introducing an order of
> magnitude problem.

All these little things add up, let's not suck like some other
OSs by having that kind of mentality.

Show me instead a change that makes page struct 8 bytes smaller
:-))))
