Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827Ab0ATWuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0ATWuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033Ab0ATWuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:50:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35892
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028Ab0ATWuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:50:00 -0500
Date: Wed, 20 Jan 2010 14:50:10 -0800 (PST)
Message-Id: <20100120.145010.80864889.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: shemminger@linux-foundation.org, mchan@broadcom.com, mbreuer@majjas.com,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pcnet32@verizon.net, romieu@fr.zoreil.com, mcarlson@broadcom.com
Subject: Re: [PATCH] sky2: Fix WARNING: at lib/dma-debug.c:902 check_sync
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100120205842.GA3072@del.dom.local>
References: <1264018312.9030.76.camel@nseg_linux_HP1.broadcom.com>
	<20100120123033.0746b11e@nehalam>
	<20100120205842.GA3072@del.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 20 Jan 2010 21:58:42 +0100

> Yes, and it's mainly for lib/dma-debug (until it's not verified dmar
> errors reported by Michael Breuer could be connected). So, I'm not
> sure for now how serious this warning could be. On the other hand,
> Documentation/(PCI-?)DMA-mapping, mentioned by Stephen, doesn't seem
> to allow or use in examples the "size" different than mapped.

Someone find me even one actual implemenetation of the DMA APIs, not
the debugging code, which can't handle a partial sync correctly, then
we can talk.

As the person who originally created the PCI DMA APIs I can tell
you the intention was definitely to allow arbitrary SYNC lengths
and there was no requirement that the length needed to be the
same as that used in the mapping call.

Nothing else makes sense.  People sync when they have a partially used
buffer and want to copy the data out then recycle the big original
buffer back to the chip.  I knew this when creating the PCI DMA APIs
because I first tried to use them in network drivers and that's what
so many of them do.

Currently all we have is an overly anal DMA debugging layer check, and
some speculation that it might or might not fix some real bug.
