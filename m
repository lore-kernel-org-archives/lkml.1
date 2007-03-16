Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbXCPUtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbXCPUtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXCPUtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:49:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39617 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753659AbXCPUtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:49:02 -0400
Date: Fri, 16 Mar 2007 13:48:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Martin Bligh <mbligh@mbligh.org>
cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <45FAFD57.90601@mbligh.org>
Message-ID: <Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
 <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
 <20070316114415.GA26403@one.firstfloor.org> <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
 <45FAFD57.90601@mbligh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, Martin Bligh wrote:

> You have to do some sort of lookup anyway, and Andy seemed to have them
> all folded into one.

What lookup would you need to do? On x86_64 even the TLB use is 
hidden by the existing 2M entries for 1-1 mappings.

> Or are you trying to avoid this by going to back to the crud we had
> in 2.4 where we pretend mem_map is one big array, indexed by pfn with
> huge sparsely mapped holes in it?

Yes that the advanced way of doing it rather than adding useless custom 
lookups.

> Would be nice to work out (and document somewhere) what the pros and
> cons of virtual memmap vs sparsemem were - ISTR one of the arguments
> was extremely sparsely layed out machines, and you needed sparsemem
> for that. But right now we have 3 solutions, which is not a good
> situation.

Please read my posts to linux-mm on that subject. We discussed it last 
year in detail and the agreement was that the sparsemem crud needs to be 
taken out. Kame-san posted patches to do that.

