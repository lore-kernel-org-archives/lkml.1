Return-Path: <linux-kernel-owner+w=401wt.eu-S933655AbXG0GmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbXG0GmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 02:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761584AbXG0Gl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 02:41:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:60720 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760840AbXG0Gl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 02:41:59 -0400
Subject: Re: [PATCH/RFC] Add MM_DEAD flag to struct mm_struct
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm <linux-mm@kvack.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1185501659.5495.174.camel@localhost.localdomain>
References: <1185501659.5495.174.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 16:41:53 +1000
Message-Id: <1185518513.5495.184.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 12:01 +1000, Benjamin Herrenschmidt wrote:
> Some architectures like sparc can do useful optimizations when knowing
> that an entire MM is being destroyed. At the moment, they rely on
> fullmm in the mmu_gather structure. However, that doesn't always work
> out very well with some of the changes we are doing. Among other things,
> the TLB flushing on sparc64 is done using per-CPU tracking data, making
> the batch not per-CPU will break that link.
> 
> So instead, we add a new flag to struct mm_struct that indicates that
> the mm is going away, for those archs to use. It also allows to use it
> in situations (such as PTE ops) where the batch isn't accessible (or
> there is no batch)

And the patch forgets to clear it in mm_init ... will send a new one
later.

Cheers,
Ben.


