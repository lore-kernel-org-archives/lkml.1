Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYCNCdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYCNCdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYCNCc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:32:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60606 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYCNCcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:32:52 -0400
Date: Fri, 14 Mar 2008 11:36:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
Message-Id: <20080314113646.d73066f7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <86802c440803131900j30ef490bk1923fdd219433535@mail.gmail.com>
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
	<20080314103431.ff07070c.kamezawa.hiroyu@jp.fujitsu.com>
	<86802c440803131835u4e506d69l4f116eb49d9ee9b2@mail.gmail.com>
	<20080314105529.79921546.kamezawa.hiroyu@jp.fujitsu.com>
	<86802c440803131900j30ef490bk1923fdd219433535@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 19:00:33 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >  Hmm, can a call to reserve_bootmem() return a memory region which spread across
> >  prural nodes ?
> 
> Yes. there is one reserve_bootmem in reserve_crashkernel. and position
> is passed via commandline...
> there is some chance for ramdisk too. it is called via reserve_bootmem_generic.
> 
Hmm, ok. I finally see your point. 

please allow me to make clarification

Background:
- reserve_bootmem is called for *reserve* memory before bootmem allocator.
- It specifies <address, size>.
- Because <addrees, size> are argments, memory hole in <address, size> is not
  problem here.

Before change,
- reseve_bootmem() only works for Node(0)

After change
- reserve_bootmem() works on sutiable nodes for <address, size>
- It can spread accross among prural nodes.

thank you for your work.

Regards,
-Kame

