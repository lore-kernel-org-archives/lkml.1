Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYIHL07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYIHL07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 07:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYIHL0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 07:26:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51506 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYIHL0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 07:26:51 -0400
Date: Mon, 8 Sep 2008 13:30:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Message-ID: <20080908113025.GF26079@one.firstfloor.org>
References: <20080905215452.GF11692@us.ibm.com> <200809081946.31521.nickpiggin@yahoo.com.au> <20080908103015.GE26079@one.firstfloor.org> <200809082119.32725.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809082119.32725.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, by "block", I really mean spin I guess. I mean that the CPU will
> be forced to stop executing due to the page fault during this sequence:

It's hard for NMIs at least. They cannot execute faults.

In the end you would need to define a core kernel which 
cannot be remapped and the rest which can and you end up
with even more micro kernel like mess.

> ptep_clear_flush(ptep)         <--- from here
> set_pte(ptep, newpte)          <--- until here
> 
> for prot RW, the window also would include the memcpy, however if that
> adds too much latency for execute/reads, then it can be mapped RO first,
> then memcpy, then flushed and switched.
>  
> 
> > Then that would be essentially a hypervisor or micro kernel approach.
> 
> What would be? Blocking in interrupts? Or non-linear kernel mapping in

Well in general someone remapping all the memory beyond you.
That's essentially a hypervisor in my book.

-Andi
