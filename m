Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbZDQQPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbZDQQPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbZDQQOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:14:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760201AbZDQQOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:14:49 -0400
Date: Fri, 17 Apr 2009 18:14:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fixup numa_node information for AMD CPU
	northbridge functions
Message-ID: <20090417161445.GE8253@elte.hu>
References: <20090417100746.GG16198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417100746.GG16198@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Currently the numa_node attribute for these PCI devices is 0 (it
> corresponds to the numa_node for PCI bus 0). This is not a big issue
> but incorrect.
> 
> This inconsistency can be fixed by reading the node number from CPU
> NB function 0.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/quirks.c |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)

applied, thanks. Note, i added this impact line to the commit:

 [ Impact: fill in dev->numa_node information, to optimize DMA allocations ]

as numa_node does matter to certain DMA allocations such as 
dma_generic_alloc_coherent() - we (try to) allocate node-local 
memory in that case.

pci_dev::numa_node might be used for more such optimizations in the 
future - so it's generally good to have this filled in correctly.

So it's more than just a fix for an inconsistency.

	Ingo
