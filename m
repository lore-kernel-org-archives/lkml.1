Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbXKTDal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbXKTDal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXKTDad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:30:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbXKTDad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:30:33 -0500
From: Andi Kleen <ak@suse.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data handling on x86_64
Date: Tue, 20 Nov 2007 04:25:34 +0100
User-Agent: KMail/1.9.1
Cc: clameter@sgi.com, akpm@linux-foundation.org, travis@sgi.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <20071119.175116.55102316.davem@davemloft.net>
In-Reply-To: <20071119.175116.55102316.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711200425.34849.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Although we have a per-cpu area base in a fixed global register
> for addressing, the above isn't beneficial on sparc64 because
> the atomic is much slower than doing a:
>
> 	local_irq_disable();
> 	nonatomic_percpu_memory_op();
> 	local_irq_enable();

Again might be pointing out the obvious, but you 
need of course save_flags()/restore_flags(), not disable/enable().

If it was just disable/enable x86 could do it much faster too 
and Christoph probably would never felt the need to approach
this project for his SLUB fast path.

-Andi
