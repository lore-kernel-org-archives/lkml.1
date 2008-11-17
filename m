Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYKQVY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYKQVY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYKQVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:24:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbYKQVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:24:19 -0500
Date: Mon, 17 Nov 2008 13:23:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <20081117130856.92e41cd3.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0811171320330.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <20081117130856.92e41cd3.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Andrew Morton wrote:
> 
> Far be it from me to apportion blame, but THIS IS ALL LINUS'S FAULT!!!!! :)
> 
> I fixed this six years ago.  See http://lkml.org/lkml/2002/6/17/68

Btw, in that thread I also said:

  "If we have 64kB pages, such architectures will have to have a bigger 
   kernel stack. Which they will have, simply by virtue of having the very 
   same bigger page. So that problem kind of solves itself."

and that may still be the "right" solution - if somebody is so insane that 
they want 64kB pages, then they might as well have a 64kB kernel stack as 
well. 

Trust me, the kernel stack isn't where you blow your memory with a 64kB 
page. You blow all your memory on the memory fragmentation of your page 
cache. I did the stats for the kernel source tree a long time ago, and I 
think you wasted something like 4GB of RAM with a 64kB page size.

			Linus
