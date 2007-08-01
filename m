Return-Path: <linux-kernel-owner+w=401wt.eu-S1763306AbXHAJ1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763306AbXHAJ1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbXHAJ1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:27:39 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43958 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbXHAJ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:27:37 -0400
Message-ID: <46B05209.4050103@bull.net>
Date: Wed, 01 Aug 2007 11:27:37 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: Jim Hull <jim.hull@hp.com>
Cc: "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
       "'David Mosberger-Tang'" <dmosberger@gmail.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       tony.luck@intel.com, "'Christoph Lameter'" <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte take6. [4/4] optimization
 for cpus other than montecito
References: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com><20070731114155.5785123c.kamezawa.hiroyu@jp.fujitsu.com><ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com> <20070731132932.8e21d48c.kamezawa.hiroyu@jp.fujitsu.com> <019b01c7d395$27d692b0$3e3af40f@americas.hpqcorp.net>
In-Reply-To: <019b01c7d395$27d692b0$3e3af40f@americas.hpqcorp.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/08/2007 11:32:18,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/08/2007 11:32:25,
	Serialize complete at 01/08/2007 11:32:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Hull wrote:
> Not just crazy, but wrong - this *can* happen on pre-Montecito.  Even though
> L1D is write-through and L2 was mixed I/D, the L1 I-cache could contain
> stale instrutions if there are missing flushes.

I cannot agree with you.

In order to consider an L1 I-cache entry as valid, a corresponding
virtual -> physic address translation should be valid in one of the L1 ITLBs.

"See 6.1.1. Instruction TLBS" of the I2 Proc. Ref. Man. for SW Dev. & Opt.

You cannot have a valid L1 ITLB entry unless you have a corresponding valid
L2 ITLB entry.

When you remove a PTE (or switch off the exec bit) and you flush the L2 ITLB
matching the old translation (and you kill the corresponding L1 ITLBs),
you do invalidate the corresponding L1 I-cache entries.

Therefore CPU models without split L2 caches are safe.

Thanks,

Zoltan
