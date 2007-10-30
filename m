Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbXJ3S62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbXJ3S62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXJ3S6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:58:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36309 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753398AbXJ3S6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:58:09 -0400
Date: Tue, 30 Oct 2007 11:58:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       penberg@cs.helsinki.fi,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-arch@vger.kernel.org
Subject: Re: [patch 08/10] SLUB: Optional fast path using cmpxchg_local
In-Reply-To: <20071030114933.904a4cf8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710301155240.12746@schroedinger.engr.sgi.com>
References: <20071028033156.022983073@sgi.com> <20071028033300.240703208@sgi.com>
 <20071030114933.904a4cf8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007, Andrew Morton wrote:

> Let's cc linux-arch: presumably other architectures can implement cpu-local
> cmpxchg and would see some benefit from doing so.

Matheiu had a whole series of cmpxchg_local patches. Ccing him too. I 
think he has some numbers for other architectures.
 
> The semantics are "atomic wrt interrutps on this cpu, not atomic wrt other
> cpus", yes?

Right.

> Do you have a feel for how useful it would be for arch maintainers to implement
> this?  IOW, is it worth their time?

That depends on the efficiency of a cmpxchg_local vs. the interrupt 
enable/ disable sequence on a particular arch. On x86 this yields about 
50% so it doubles the speed of the fastpath. On other architectures the 
cmpxchg is so slow that it is not worth it (ia64 f.e.)
