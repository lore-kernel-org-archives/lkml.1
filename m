Return-Path: <linux-kernel-owner+w=401wt.eu-S1764084AbZD3Q0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764084AbZD3Q0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763004AbZD3QZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:25:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761570AbZD3QZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:25:57 -0400
Date: Thu, 30 Apr 2009 09:16:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Christoph Lameter <cl@linux.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430160606.GA5913@elte.hu>
Message-ID: <alpine.LFD.2.00.0904300914110.3395@localhost.localdomain>
References: <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com> <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com> <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com>
 <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com> <20090430160606.GA5913@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> c0436275:   64 83 05 20 5f 6a c0    addl   $0x1,%fs:0xc06a5f20
> 
> There's no atomic instructions at all - the counters here are only 
> accessed locally. They are local-irq-atomic, but not 
> cacheline-atomic.

On other architectures, you need the whole "disable preemption, 
load-locked, store-conditional, test-and-loop, enable preemption" thing. 

Or "disable interrupts, load, store, restore interrupts".

There really aren't very many architectures that can do almost 
unrestricted ALU ops in a single instruction (and thus automatically safe 
from preemption and interrupts).

			Linus
