Return-Path: <linux-kernel-owner+w=401wt.eu-S932698AbZACWAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbZACWAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbZACWAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:00:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbZACWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:00:40 -0500
Date: Sat, 3 Jan 2009 14:00:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] cpus4096 tree, part 3
In-Reply-To: <20090103213856.GA24138@elte.hu>
Message-ID: <alpine.LFD.2.00.0901031347570.3179@localhost.localdomain>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu>
 <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain> <20090103203621.GA2491@elte.hu> <20090103213856.GA24138@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Jan 2009, Ingo Molnar wrote:
> 
> This one looks a bit high:
> 
>   1)     5264     496   __change_page_attr_set_clr+0xa7/0xa15
> 
> (Venki, Suresh and Arjan Cc:-ed)
> 
> This one isnt too nice either:
> 
>  27)     1984     800   do_page_fault+0x86d/0xcec
> 
> not sure why it happens - will investigate tomorrow, it's getting late 
> here.

The most common case tends to be insane gcc inlining (vmalloc_fault and 
spurious_fault), and then gcc not re-using stack slots even if they have 
no overlap in usage. Some people continue to claim that gcc reuses them, 
but it's definitely not the case in any complex situation, so I suspect 
the re-use is probably purely for some simple spilling case, not for 
variables allocated on the stack.

do_page_fault() in particular has a lot of gunk in it for the special 
cases.

What happened to Nick's cleanup patch to do_page_fault (a month or two 
ago? I complained about some of the issues in his first version and asked 
for some further cleanups, but I think that whole discussion ended with 
him saying "I am going to add those changes that you suggested (in fact, I 
already have)".

And then I didn't see anything further. Maybe I just missed the end 
result. Or maybe we have it in some -mm branch or something?

		Linus
