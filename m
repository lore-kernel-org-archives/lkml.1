Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbZJOPaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbZJOPaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762239AbZJOPaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:30:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:64324 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760264AbZJOPaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:30:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,566,1249282800"; 
   d="scan'208";a="559857652"
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
From: reinette chatre <reinette.chatre@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <200910150402.03953.elendil@planet.nl>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <20091014165051.GE5027@csn.ul.ie> <1255552911.21134.51.camel@rc-desk>
	 <200910150402.03953.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 15 Oct 2009 08:29:27 -0700
Message-Id: <1255620567.21134.162.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 19:02 -0700, Frans Pop wrote:
> On Wednesday 14 October 2009, reinette chatre wrote:
> > We do queue the GFP_KERNEL allocations when there are only a few buffers
> > remaining in the queue (8 right now) ... maybe we can make this higher?
> 
> I've tried increasing it to 50. Here's the result for a single test:
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 25 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 48 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 48 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 48 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> __ratelimit: 1 callbacks suppressed
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> __ratelimit: 97 callbacks suppressed
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 44 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
> 
> This is with current mainline (v2.6.32-rc4-149-ga3ccf63).

> The log file timestamps don't tell much as the logging gets delayed,
> so they all end up at the same time. Maybe I should enable the kernel
> timestamps so we can see how far apart these failures are.

If you can get accurate timing it will be very useful. I am interested
to see how quickly it goes from "48 free buffers" to "0 free buffers".

Thank you

Reinette



