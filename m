Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXKLGQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXKLGQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 01:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXKLGP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 01:15:57 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35333 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbXKLGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 01:15:57 -0500
Message-ID: <4737EF9C.4010207@lwfinger.net>
Date: Mon, 12 Nov 2007 00:15:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: DMA descriptor alignment
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For those variants of BCM43xx cards that use 64-bit DMA, there is a requirement that all descriptor
rings must be aligned on an 8K boundary and must fit within an 8K page. On the x86_64 architecture
where the page size is 4K, I was getting addresses like 0x67AF000 when using dma_alloc_coherent
calls. From the description of the dma_pool_create and dma_pool_allocate routines, I thought they
would fix my problems; however, even with a dma_pool_create(name, dev, 8192, 8192, 8192) call, I'm
still getting 4K rather than 8K alignment, which results in DMA errors.

Is there a bug in these routines, am I using them incorrectly, or do I have a misunderstanding of
what it takes to get this kind of alignment?

Thanks,

Larry
