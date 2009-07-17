Return-Path: <linux-kernel-owner+w=401wt.eu-S934061AbZGQCjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbZGQCjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934040AbZGQCjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:39:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60146
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934016AbZGQCjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:39:01 -0400
Date: Thu, 16 Jul 2009 19:39:06 -0700 (PDT)
Message-Id: <20090716.193906.33652838.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 8/8] sparc: add CONFIG_DMA_API_DEBUG support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247466360-13330-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1247466360-13330-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 13 Jul 2009 15:26:00 +0900

> All we need to do for CONFIG_DMA_API_DEBUG support is call
> dma_debug_init() in DMA code common for SPARC32 and SPARC64.
> 
> Now SPARC32 uses two dma_map_ops structures for pci and sbus so there
> is not much dma stuff for SPARC32 in kernel/dma.c. kernel/ioport.c
> also includes dma stuff for SPARC32. So let's put all the dma stuff
> for SPARC32 in kernel/ioport.c and make kernel/dma.c common for
> SPARC32 and SPARC64.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

ACK, we just need to tweak that illegal DMA address check so
that it doesn't erroneously trigger on sparc32.
