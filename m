Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbYE3GQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbYE3GQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYE3GQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:16:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33378 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752230AbYE3GQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:16:12 -0400
Date: Thu, 29 May 2008 23:16:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
In-Reply-To: <20080529224959.3297a4f1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805292313240.12457@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080529215827.b659d032.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
 <20080529222143.5d7aa1e5.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0805292224540.12329@schroedinger.engr.sgi.com>
 <20080529224959.3297a4f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Andrew Morton wrote:

> > No. The module subsystem has its own alloc_percpu subsystem that the 
> > cpu_alloc replaces.
> 
> That is to support DEFINE_PER_CPU, not alloc_percpu().

Right but it needs to have its own section of the percpu space from which 
it allocates the percpu segments for the modules. So it effectively 
implements an allocator.

> If we were to merge all this code and then run into the problems which
> I fear then we are tremendously screwed.  We must examine this
> exhaustively, in the most paranoid fashion.

Well V2 virtually mapped the cpu alloc area which allowed extending it 
arbitrarily. But that made things very complicated.

The number of per cpu resources needed is mostly fixed. The number of 
zones, nodes, slab caches, network interfaces etc etc does not change much 
during typical operations.
 
