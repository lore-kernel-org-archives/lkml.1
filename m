Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab0BDJM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:12:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:36534 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757780Ab0BDJMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:12:54 -0500
Date: Thu, 4 Feb 2010 20:12:50 +1100
From: Nick Piggin <npiggin@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Kutkov <elenbert@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Problem with set_memory_rw
Message-ID: <20100204091250.GD13318@laptop>
References: <4B6A5A81.2030207@gmail.com>
 <20100204144511.b50d3191.kamezawa.hiroyu@jp.fujitsu.com>
 <5e9821061002040006p258c2738y87a26c769c04bcfd@mail.gmail.com>
 <5e9821061002040009t27fc5a81m5075508f3a6634a6@mail.gmail.com>
 <20100204175133.790251c8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204175133.790251c8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 05:51:33PM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 4 Feb 2010 10:09:57 +0200
> Oleg Kutkov <elenbert@gmail.com> wrote:
> > Thank for answer!
> > But this is a very strange, because 0x0509940 - it a virtual memory
> > address (i got it from System.map, this is a system call table, on my
> > machine). set_memory_rw return zero, anyway. Maybe, system call table
> > is much write protected, so i can't change attribute of memory page?
> > One more interesting thing:
> > 
> > 
> > 
> > struct page *pg;
> > pg = virt_to_page(addr);
> > unsigned long page_addr;
> > page_addr = (unsigned long) page_address(pg);
> > 
> > 
> > addr - this is my virtual address (provided by System.map)
> > But page_addr got another value!
> > What wrong?
> > Sorry, if my questions is to stupid.
> > 
> 
> Below is only about virt_to_page() etc... (not about set_memory_rw())
> Maybe my answer for set_memory_rw() was pointless.
> 
> I think system call table is on .rodata section and set_memory_rw() doesn't
> allow change attributes on .rodata sections(not .text)
> ..I'm sorry if I'm wrong.

You are right. static_protections() forbids rodata from being marked RW.

