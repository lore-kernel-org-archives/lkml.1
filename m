Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbXGDOYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbXGDOYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760505AbXGDOYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:24:38 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56275 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497AbXGDOYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:24:37 -0400
Message-ID: <468BADA6.9050609@bull.net>
Date: Wed, 04 Jul 2007 16:24:38 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 04/07/2007 16:28:48,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 04/07/2007 16:28:49,
	Serialize complete at 04/07/2007 16:28:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please confirm that I understand correctly what is in the:

Dual-Core Update to the Intel Itanium 2 Processor Reference Manual...

"2.3.3.2 L2 Caches
...
Any coherence request to identify whether a cache line is in the processor
will invalidate that line from the L2I cache."

This makes sure that the DMAs invalidate the L2L cache.

"2.7.4 Instruction Cache Coherence Optimization
Coherence requests of the L1I and L2I caches will invalidate the line if
it is in the cache. Montecito allows instruction requests on the system
interface to be filtered such that they will not initiate coherence
requests of the L1I and L2I caches. This will allow instructions to be
cached at the L1I and L2I levels across multiple processors in a coherent
domain. This optimization is enabled by default, but may be disabled by
PAL_SET_PROC_FEATURES bit 5 of the Montecito feature_set (18)."

Machines star up whit bit 5 = 0, reading instruction pages via
NFS has to flush them from L2I.


I was wondering if instead of modifying do_no_page() and Co., should
not we make nfs_readpage() be DMA-like?
(No possible regression for most of the page I/O-s.)
I.e. it should be the responsibility of a file system to make sure it
supports instruction pages correctly. The base kernel should provide
such file systems with an architecture dependent macro...

Thanks,

Zoltan Menyhart
