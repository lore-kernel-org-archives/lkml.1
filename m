Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbXLUQ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbXLUQ7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbXLUQ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:58:58 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28768 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbXLUQ65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:58:57 -0500
X-IronPort-AV: E=Sophos;i="4.24,194,1196668800"; 
   d="scan'208";a="23930045"
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi@vger.kernel.org, davem@davemloft.net,
       james.bottomley@steeleye.com, ralf@linux-mips.org
Subject: Re: [PATCH 1/2] DMA buffer alignment annotations
X-Message-Flag: Warning: May contain useful information
References: <20071221023010.C56B7DDDF3@ozlabs.org>
	<20071221093905.GB31115@flint.arm.linux.org.uk>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Dec 2007 08:58:50 -0800
In-Reply-To: <20071221093905.GB31115@flint.arm.linux.org.uk> (Russell King's message of "Fri, 21 Dec 2007 09:39:05 +0000")
Message-ID: <adafxxwx9v9.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Dec 2007 16:58:50.0821 (UTC) FILETIME=[C2BA8750:01C843F2]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > +#define __dma_aligned	  	__attribute__((aligned(ARCH_MIN_DMA_ALIGNMENT)))
 > > +#define __dma_buffer		__dma_buffer_line(__LINE__)
 > > +#define __dma_buffer_line(line)	__dma_aligned;\
 > > +				char __dma_pad_##line[0] __dma_aligned

 > You introduce __dma_buffer_line() if ARCH_MIN_DMA_ALIGNMENT is set but
 > not if it isn't...

__dma_buffer_line() is just an internal implementation detail to take
care of string pasting properly.  Perhaps there should be a comment
warning people not to use it directly.

 - R.
