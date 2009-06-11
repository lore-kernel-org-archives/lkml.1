Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbZFKSfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbZFKSfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZFKSf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:35:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbZFKSf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:35:26 -0400
Date: Thu, 11 Jun 2009 11:34:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Martin Bligh <mbligh@google.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>  <20090611161714.GA5008@infradead.org>  <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>  <20090611165226.GV8633@ZenIV.linux.org.uk>  <1244739378.6691.540.camel@laptop>  <20090611170015.GA3651@infradead.org>
  <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Martin Bligh wrote:
> 
> We actually ended up coming to the same conclusion as you for some of the
> internal tools we use that are tightly tied to the kernel. There is one hitch,
> which is that if you boot between different kernel versions, you need multiple
> userspace versions of the tools, so you may need to put them in
> /lib/modules/<kernel-version> or something equivalent, not one fixed place.

So I actually think this is broken.

No tool should ever be _that_ tightly tied to a kernel. If they are, they 
are broken, plain and simple.

A stable user-space ABI is still a requirement.

What the "keep it in the kernel sources" approach hopefully allows is

 - taking advantage of new features in a timely manner.

   NOT with some ABI breakage, but simply things like supporting a new CPU 
   architecture or new counters. The thing that oprofile failed at so 
   badly in my experience. 

 - Make it easier for developers, and _avoiding_ the horrible situation 
   where you have two different groups that don't talk well to each other 
   because one is a group of user-space weenies, and the other is a group 
   of manly kernel people, and there is no common ground.

And no, I'm not going to "guarantee" that this works well. Again, I just 
know that the separation didn't work. Let's just _try_ to do it this way, 
and see how it works.

But at no point will it be acceptable to have kernel version dependencies. 
Install the newest version of the binaries, and it should support older 
kernels too (within reason). 

The "within reason" is because (a) it's new, so early on you might see 
breakage, and (b) because we do tend to allow system tools to break 
occasionally. Not nearly often enough to make it valid to design around 
it, though.

		Linus
