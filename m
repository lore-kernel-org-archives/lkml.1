Return-Path: <linux-kernel-owner+w=401wt.eu-S965719AbXCPUPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965719AbXCPUPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965737AbXCPUPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:15:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36782 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965719AbXCPUPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:15:43 -0400
Date: Fri, 16 Mar 2007 13:15:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070316114415.GA26403@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
 <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
 <20070316114415.GA26403@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, Andi Kleen wrote:

> 
> > x86_64 is going to acquire more functionality that will not be available 
> > for i386. We plan f.e. to add virtual memmap support for x86_64. Virtual 
> 
> What advantage would that have over the current setup?
> We already should handle holes between nodes reasonably efficiently
> and with nonlinear memory even holes inside nodes shouldn't be a problem.

It is primarily a performance improvement since the sparsemem table 
lookups would no longer be necessary and it also streamlines other 
frequent cacheline uses. These page -> page_struct and vice versa 
operations are key to the performance of various subsystem among them 
the slab allocator.

