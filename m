Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYE0BlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYE0BlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 21:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYE0Bkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 21:40:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39358
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbYE0Bkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 21:40:51 -0400
Date: Mon, 26 May 2008 18:40:47 -0700 (PDT)
Message-Id: <20080526.184047.88207142.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-arch@vger.kernel.org, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211852026.3286.36.camel@pasglop>
References: <1211516683.8297.271.camel@pasglop>
	<Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
	<1211852026.3286.36.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 27 May 2008 11:33:46 +1000

> Quick summary: gcc is happily re-ordering readl/writel vs. surrounding
> memory accesses (and thus accesses to DMA coherent memory) which is
> obviously a _BAD_THING_.
> 
> This is on all archs. Quick fix is to stick a "memory" clobber in all arch
> implementations of readl/writel/... (ie, making them a barrier()).
> 
> However, I'm using that as an excuse to bring back my pet subject, which
> is basically, should we instead just finally mandate the use of explicit
> rmb/wmb/mb's (which boils down to barrier() on x86) to drivers who want
> to order memory consistent accesses vs. MMIO ?

This is basically what drivers are effectively doing.
