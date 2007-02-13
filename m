Return-Path: <linux-kernel-owner+w=401wt.eu-S1751606AbXBMSwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbXBMSwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXBMSwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:52:01 -0500
Received: from mailhub.hp.com ([192.151.27.10]:49878 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbXBMSwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:52:00 -0500
From: "Bob Picco" <bob.picco@hp.com>
Date: Tue, 13 Feb 2007 13:51:57 -0500
To: Andi Kleen <ak@suse.de>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
Message-ID: <20070213185157.GO17678@localhost>
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com> <200702131845.05913.ak@suse.de> <45D1FF43.9050800@mbligh.org> <200702131918.45885.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702131918.45885.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:	[Tue Feb 13 2007, 01:18:45PM EST]
> 
> > I wasn't suggesting having NULL pointers for pgdats, if that's what you
> > mean. 
> 
> That is what started the original thread at least. Can happen on some
> ia64 platforms.
I don't believe there is a NULL pgdat. The code for memory less nodes in
ia64 discontig.c allocates the memory less nodes pgdat from the best
memory node candidate. If there is a NULL pgdat, then it's a bug. Instead
for memory less nodes you don't have any present pages. 

I thought the bug was because the process wanted to bind on just one
memoryless node and MPOL_BIND didn't handle that correctly and return
an error to the process.

bob
> 
> > Just nodes with no memory in them, the pgdat would still be there. 
> > pgdat = struct node, except everything's badly named.
> 
> Ok those can happen even on x86-64, mostly because it's possible
> to fill up a node early during boot up with bootmem and then
> it's effectively empty.
> 
> [there is even still a open bug when this happens on node 0]
>  
> Handling out of memory here of course has to be always done.
> 
> Just NULL pointers in core data structures are evil. But I'm glad we 
> agree here.
> 
> Now if it's better to set up a empty node or use a nearby node
> for a memory less cpu can be further discussed. I still think
> I lean towards the later.
> 
> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
