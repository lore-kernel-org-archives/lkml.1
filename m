Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYKJMmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYKJMmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYKJMm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:42:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57606 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbYKJMm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:42:29 -0500
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-ia64@vger.kernel.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
From: Andi Kleen <andi@firstfloor.org>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com>
Date: Mon, 10 Nov 2008 13:59:57 +0100
In-Reply-To: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's message of "Mon, 10 Nov 2008 13:47:51 +0900")
Message-ID: <87d4h3pwhe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto <y-goto@jp.fujitsu.com> writes:
>
> However, I think this has the possibility of a finishing blow of OOM.
> For example,
>
>   1) Page caches occupy normal zone, and DMA zone is free.
>   2) A user's application requires a few GB memory and mlock it.
>      All DMA zone is occupied by it.

The VM has special "lower zone protection" to protect against these
kinds of deadlocks. They can be circumvented, but it takes effort.

>   3) A device which allows over 4GB is hot-added.
>      But dma_alloc_coherent() try to allocate DMA zone.
>      Then OOM occurs because there is no freeable pages.
>
> I heard there are some users who require a few GB mlock.

Normally mlock is limited to half the memory exactly to avoid
such problems.

Also I believe there are some issues with non continuous memory on
some IA64 systems -- e.g. Altixes iirc have the requirement
that you use the IOMMU for higher memory. So it's probably
not easy to change.

-Andi

-- 
ak@linux.intel.com
