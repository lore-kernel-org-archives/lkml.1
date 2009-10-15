Return-Path: <linux-kernel-owner+w=401wt.eu-S1761740AbZJOCCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740AbZJOCCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 22:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760790AbZJOCCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 22:02:42 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:56093 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757370AbZJOCCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 22:02:41 -0400
From: Frans Pop <elendil@planet.nl>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Thu, 15 Oct 2009 04:02:00 +0200
User-Agent: KMail/1.9.9
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
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <20091014165051.GE5027@csn.ul.ie> <1255552911.21134.51.camel@rc-desk>
In-Reply-To: <1255552911.21134.51.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910150402.03953.elendil@planet.nl>
X-OriginalArrivalTime: 15 Oct 2009 02:02:04.0447 (UTC) FILETIME=[7DEB6AF0:01CA4D3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009, reinette chatre wrote:
> We do queue the GFP_KERNEL allocations when there are only a few buffers
> remaining in the queue (8 right now) ... maybe we can make this higher?

I've tried increasing it to 50. Here's the result for a single test:
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 25 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 48 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 48 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 48 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
__ratelimit: 1 callbacks suppressed
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
__ratelimit: 97 callbacks suppressed
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 44 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.
iwlagn 0000:10:00.0: Failed to allocate SKB buffer with GFP_ATOMIC. Only 0 free buffers remaining.

This is with current mainline (v2.6.32-rc4-149-ga3ccf63).

The log file timestamps don't tell much as the logging gets delayed,
so they all end up at the same time. Maybe I should enable the kernel
timestamps so we can see how far apart these failures are.
