Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbXGFJth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbXGFJth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbXGFJt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:49:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57366 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758609AbXGFJt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:49:28 -0400
Date: Fri, 6 Jul 2007 18:50:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Cc: linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "tony.luck@intel.com" <tony.luck@intel.com>,
       nickpiggin@yahoo.com.au, mike@stroyan.net, dmosberger@gmail.com,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
Message-Id: <20070706185006.0014bea5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <468E0E52.2060705@bull.net>
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>
	<468E0E52.2060705@bull.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jul 2007 11:41:38 +0200
Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:

> KAMEZAWA Hiroyuki wrote:
> 
> >  Note1: icache flush is called only when VM_EXEC flag is on and 
> >         PG_arch_1 is not set.
> 
> If you have not got the page in the cache, then the new page will
> be allocated with PG_arch_1 bit off.
> You are going to flush pages which are read by HW DMA, i.e. the L2I
> of Montecito does not keep old lines for those pages anyway.
> 
yes, it's my concern. 

> ...->a_ops->readpage() of "L2I safe" file systems should set PG_arch_1
> if the CPU is ia64 and it has got separate L2I.
> 
> On the other hand, arch. independent file systems should not play with
> PG_arch_1.
> The base kernel should export a macro for the file systems...
> 
Hm, but it should be discussed in another thread... I think.
>From memory management view, flush_icache before set_pte() is sane thing.
 
-Kame

