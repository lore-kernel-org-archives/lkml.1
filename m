Return-Path: <linux-kernel-owner+w=401wt.eu-S938482AbXGSOe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938482AbXGSOe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934706AbXGSOdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:33:05 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50188 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938303AbXGSOdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:33:01 -0400
Message-ID: <469F7622.6070801@bull.net>
Date: Thu, 19 Jul 2007 16:33:06 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, nickpiggin@yahoo.com.au,
       mike@stroyan.net, dmosberger@gmail.com, y-goto@jp.fujitsu.com
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>	<20070719155632.7dbfb110.kamezawa.hiroyu@jp.fujitsu.com>	<469F5372.7010703@bull.net>	<20070719220118.73f40346.kamezawa.hiroyu@jp.fujitsu.com> <20070719223208.87383731.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070719223208.87383731.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/07/2007 16:37:32,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/07/2007 16:37:34,
	Serialize complete at 19/07/2007 16:37:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

> A bit new idea.  How about this ?
> ==
> - Set PG_arch_1 if  "icache is *not* coherent"

page-flags.h:
 * PG_arch_1 is an architecture specific page state bit.  The generic code
 * guarantees that this bit is cleared for a page when it first is entered into
 * the page cache.

I do not think you can easily change it.
I can agree, making nfs_readpage() call an architecture dependent service
is not an easy stuff either. :-)

> - make flush_dcache_page() to be empty func.
> - For Montecito, add kmap_atomic(). This function just set PG_arch1.

kmap_atomic() is used at several places. Do you want to set
PG_arch1, everywhere kmap_atomic() is called?

>   Then, "the page which is copied by the kernel" is marked as "not icache coherent page"
> - icache_flush_page() just flushes a page which has PG_arch_1.
> - Anonymous page is always has PG_arch_1. Tkae care of Copy-On-Write.

You can allocate (even in user mode) an anonymous page, hand-create or
read() in some code from a file, and mprotect(...., EXEC)-it. The page has
to become I-cache coherent.

I am not sure I can really understand your proposal.
I cannot see how the compatibility to the existing code is made sure.

Thanks,

Zoltan
