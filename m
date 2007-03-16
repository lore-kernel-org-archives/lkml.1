Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbXCPUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbXCPUrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXCPUrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:47:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40926
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753639AbXCPUrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:47:20 -0400
Date: Fri, 16 Mar 2007 13:47:18 -0700 (PDT)
Message-Id: <20070316.134718.95058720.davem@davemloft.net>
To: clameter@sgi.com
Cc: andi@firstfloor.org, rostedt@goodmis.org, torvalds@linux-foundation.org,
       mbligh@mbligh.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, chrisw@sous-sol.org, rusty@rustcorp.com.au,
       glommer@gmail.com
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
	<20070316114415.GA26403@one.firstfloor.org>
	<Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 16 Mar 2007 13:15:38 -0700 (PDT)

> On Fri, 16 Mar 2007, Andi Kleen wrote:
> 
> > > x86_64 is going to acquire more functionality that will not be available 
> > > for i386. We plan f.e. to add virtual memmap support for x86_64. Virtual 
> > 
> > What advantage would that have over the current setup?
> > We already should handle holes between nodes reasonably efficiently
> > and with nonlinear memory even holes inside nodes shouldn't be a problem.
> 
> It is primarily a performance improvement since the sparsemem table 
> lookups would no longer be necessary and it also streamlines other 
> frequent cacheline uses. These page -> page_struct and vice versa 
> operations are key to the performance of various subsystem among them 
> the slab allocator.

If you set the bit range small enough and don't use sparsemem-extreme,
the cost is extremely low considering the flexibility you obtain.

There are always going to be holes on large systems, there isn't
really a way to avoid this given how addressing is done on those
machines.
