Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYHSFOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYHSFOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 01:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYHSFNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 01:13:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56951 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbYHSFNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 01:13:53 -0400
Message-ID: <48AA559A.6060903@zytor.com>
Date: Mon, 18 Aug 2008 22:09:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [patch]pageattr: cache flush before tlb flush
References: <1219026451.16428.4.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1219026451.16428.4.camel@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> clflush uses a virtual address but cache line is physical indexed in
> x86. In my understanding, clflush will do some pagetable walk, so doing
> cache flush first should reduce some pagetable walk.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

I would say NAK on this.

Doing the CLFLUSH first does cut down on page table walking, but opens a 
hole in the sequencing: first set PAT to an uncachable mode, then flush.

If an unlucky prefetch comes in during this window, then you will have a 
dirty cache again.

So no, this is not a good idea.

	-hpa
