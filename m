Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbZE0I5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbZE0I5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760622AbZE0I5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:57:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54735 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760122AbZE0I46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:56:58 -0400
Date: Wed, 27 May 2009 09:56:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090527085631.GA18768@n2100.arm.linux.org.uk>
References: <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal> <20090526155906.GC26713@n2100.arm.linux.org.uk> <20090526172322.GB19443@Krystal> <20090526182310.GG26713@n2100.arm.linux.org.uk> <20090527012243.GB29692@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527012243.GB29692@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 09:22:43PM -0400, Mathieu Desnoyers wrote:
> My point was not about the wmb() : we _clearly_ need a dmb there. My
> point is about the hidden
> 
> smp_read_barrier_depends() in rcu_dereference() :
> 
> cpyptr = ptr;
> smp_read_barrier_depends();
> access *cpyptr data
> 
> Which is needed to make sure we update our global view of memory between
> the pointer value read and the moment we read the data pointed to. This
> makes sure the data read is not garbage.

There is a dependency between reading 'ptr' and reading 'data'.
I think there was a paragraph in the ARM ARM about this which says
that they happen in program order, but I don't have access at the
moment to the ARM ARM to check right now.
