Return-Path: <linux-kernel-owner+w=401wt.eu-S933957AbXHVVbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbXHVVbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762655AbXHVVa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:30:59 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:64301 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbXHVVa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:30:58 -0400
Message-ID: <46CCAB0D.80507@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2007 03:00:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 oom-killer gets invoked
References: <46CCA14A.6060103@linux.vnet.ibm.com>
In-Reply-To: <46CCA14A.6060103@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Andrew,
> 
> I see the oom-killer getting invoked many times on the
> 2.6.23-rc3-mm1 kernel and have attached the complete console
> log and config file.
> 
> ========================================================
> cc1 invoked oom-killer: gfp_mask=0x280d2, order=0, oomkilladj=0
> 
> [<c0147386>] out_of_memory+0x70/0xf6
> 
> [<c01484c4>] <4>cc1 invoked oom-killer: gfp_mask=0x201d2, order=0,
> oomkilladj=0
> 
> [<c0147386>] out_of_memory+0x70/0xf6
> 
> [<c01484c4>] __alloc_pages+0x21b/0x2a8
> 
> [<c0173168>] mntput_no_expire+0x11/0x6e
> 
> [<c0149f29>] __do_page_cache_readahead+0xc8/0x13a
> 
> [<c014535b>] filemap_nopage+0x164/0x30d
> 
> [<c0150c7d>] do_no_page+0x91/0x2fb
> 
> [<c0151201>] __handle_mm_fault+0x151/0x2bc
> 
> [<c016000f>] do_filp_open+0x25/0x39
> 
> [<c0115990>] do_page_fault+0x2a3/0x5f7
> 
> [<c01156ed>] do_page_fault+0x0/0x5f7
> 
> [<c03336c4>] error_code+0x7c/0x84
> 
> [<c0330000>] packet_rcv+0xfd/0x2d7
> 
> =======================
> 
> DMA per-cpu:
> 
> CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
> usd:   0
> 
> CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
> usd:   0
> 
> CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
> usd:   0
> 
> CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
> usd:   0
> 
> Normal per-cpu:
> 
> CPU    0: Hot: hi:  186, btch:  31 usd:  67   Cold: hi:   62, btch:  15
> usd:  57
> 
> CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15
> usd:  57
> 
> CPU    2: Hot: hi:  186, btch:  31 usd: 126   Cold: hi:   62, btch:  15
> usd:  50
> 
> CPU    3: Hot: hi:  186, btch:  31 usd:  50   Cold: hi:   62, btch:  15
> usd:  19
> 
> HighMem per-cpu:
> 
> CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15
> usd:  10
> 
> CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15
> usd:  19
> 
> CPU    2: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15
> usd:  27
> 
> CPU    3: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15
> usd:  56
> 
> Active:228916 inactive:238880 dirty:0 writeback:0 unstable:0
> 

Hmm... looks very interesting looks like you have ~1.8 GB (assuming page size
is equal to 4k). The log shows that OOM occurred several times.

Kamalesh, how much memory do you have the on the system and what test were
you running when you hit this problem? Is the problem reproducible? What is
the configured swap size?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
