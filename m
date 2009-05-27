Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbZE0JTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbZE0JTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZE0JS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:18:56 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44952 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756344AbZE0JS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:18:56 -0400
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20090527085631.GA18768@n2100.arm.linux.org.uk>
References: <20090524145633.GA14754@Krystal>
	 <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal>
	 <20090525161941.GA3667@n2100.arm.linux.org.uk>
	 <20090526145950.GB26713@n2100.arm.linux.org.uk>
	 <20090526153654.GA17096@Krystal>
	 <20090526155906.GC26713@n2100.arm.linux.org.uk>
	 <20090526172322.GB19443@Krystal>
	 <20090526182310.GG26713@n2100.arm.linux.org.uk>
	 <20090527012243.GB29692@Krystal>
	 <20090527085631.GA18768@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 27 May 2009 10:18:28 +0100
Message-Id: <1243415908.1947.27.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 09:18:29.0053 (UTC) FILETIME=[18EA76D0:01C9DEAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 09:56 +0100, Russell King - ARM Linux wrote:
> On Tue, May 26, 2009 at 09:22:43PM -0400, Mathieu Desnoyers wrote:
> > My point was not about the wmb() : we _clearly_ need a dmb there. My
> > point is about the hidden
> > 
> > smp_read_barrier_depends() in rcu_dereference() :
> > 
> > cpyptr = ptr;
> > smp_read_barrier_depends();
> > access *cpyptr data
> > 
> > Which is needed to make sure we update our global view of memory between
> > the pointer value read and the moment we read the data pointed to. This
> > makes sure the data read is not garbage.
> 
> There is a dependency between reading 'ptr' and reading 'data'.
> I think there was a paragraph in the ARM ARM about this which says
> that they happen in program order, but I don't have access at the
> moment to the ARM ARM to check right now.

You are right, there is an address dependency here and there is no need
for an explicit barrier (probably another difference from Alpha).

-- 
Catalin

