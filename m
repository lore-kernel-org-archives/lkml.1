Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0BDIy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:54:58 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57750 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab0BDIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:54:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 4 Feb 2010 17:51:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Oleg Kutkov <elenbert@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: Problem with set_memory_rw
Message-Id: <20100204175133.790251c8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <5e9821061002040009t27fc5a81m5075508f3a6634a6@mail.gmail.com>
References: <4B6A5A81.2030207@gmail.com>
	<20100204144511.b50d3191.kamezawa.hiroyu@jp.fujitsu.com>
	<5e9821061002040006p258c2738y87a26c769c04bcfd@mail.gmail.com>
	<5e9821061002040009t27fc5a81m5075508f3a6634a6@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 10:09:57 +0200
Oleg Kutkov <elenbert@gmail.com> wrote:
> Thank for answer!
> But this is a very strange, because 0x0509940 - it a virtual memory
> address (i got it from System.map, this is a system call table, on my
> machine). set_memory_rw return zero, anyway. Maybe, system call table
> is much write protected, so i can't change attribute of memory page?
> One more interesting thing:
> 
> 
> 
> struct page *pg;
> pg = virt_to_page(addr);
> unsigned long page_addr;
> page_addr = (unsigned long) page_address(pg);
> 
> 
> addr - this is my virtual address (provided by System.map)
> But page_addr got another value!
> What wrong?
> Sorry, if my questions is to stupid.
> 

Below is only about virt_to_page() etc... (not about set_memory_rw())
Maybe my answer for set_memory_rw() was pointless.

I think system call table is on .rodata section and set_memory_rw() doesn't
allow change attributes on .rodata sections(not .text)
..I'm sorry if I'm wrong.

==
At first, Linux maps physical memory in linear mapping. virt_to_page(), 
page_address()..etc works for this linear mapping area.

AFAIK, in some arch?, kernel's text area is on outside of linear mapping area.

For example, ia64 has
  0xa00xxxxxxxxxxxxxxxxxx  for kernel text.
  0xe000xxxxxxxxxxxxxxxxx  for linear mapping.

Another example, x86 has
  0xffffffff80000000       for kernel text.
  0xffff880000000000       for linear mapping's base address.

I know base address of linear mapping area is represented as __PAGE_OFFSET
in many archs. please check.

Anyway, "what 0x0509940 is" depends on your arch. I think.
Maybe it's good to investigate how __pa() and __va() is implemented on your arch.


Thanks,
-Kame

