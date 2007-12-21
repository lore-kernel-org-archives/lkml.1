Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbXLUQ6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbXLUQ6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXLUQ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:57:53 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:44893 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbXLUQ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:57:52 -0500
X-IronPort-AV: E=Sophos;i="4.24,194,1196668800"; 
   d="scan'208";a="2099635"
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, <linux-scsi@vger.kernel.org>,
       <rmk@arm.linux.org.uk>, <davem@davemloft.net>,
       <james.bottomley@steeleye.com>, <ralf@linux-mips.org>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer in scsi_cmnd
X-Message-Flag: Warning: May contain useful information
References: <20071221023011.4C4BADDDFA@ozlabs.org>
	<20071221103326.7ce1bc4f@the-village.bc.nu>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Dec 2007 08:57:47 -0800
In-Reply-To: <20071221103326.7ce1bc4f@the-village.bc.nu> (Alan Cox's message of "Fri, 21 Dec 2007 10:33:26 +0000")
Message-ID: <adak5n8x9x0.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Dec 2007 16:57:47.0983 (UTC) FILETIME=[9D4635F0:01C843F2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > It's also incomplete as a fix because I don't see what guarantees the
 > buffer size will always exceed cache line size

There's a macro trick that adds a pad member after the buffer too, so
that it gets rounded up to the cacheline size:

 > +#define __dma_aligned	  	__attribute__((aligned(ARCH_MIN_DMA_ALIGNMENT)))
 > +#define __dma_buffer		__dma_buffer_line(__LINE__)
 > +#define __dma_buffer_line(line)	__dma_aligned;\
 > +				char __dma_pad_##line[0] __dma_aligned

So that part is OK at least.

 - R.
