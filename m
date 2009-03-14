Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZCNDrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZCNDrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 23:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZCNDrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 23:47:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:43190 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZCNDrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 23:47:12 -0400
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090311131007.GB1074@elte.hu>
References: <20090310172605.GA28767@elte.hu>
	 <Pine.LNX.4.44L0.0903101620390.4325-100000@iolanthe.rowland.org>
	 <20090311121220.GI2282@elte.hu> <20090311125013.GA9547@in.ibm.com>
	 <20090311131007.GB1074@elte.hu>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 14:46:03 +1100
Message-Id: <1237002363.25062.82.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 14:10 +0100, Ingo Molnar wrote:
> 
> Kernel gets debug registers in db4..db3..db2..db1 order, and its 
> allocation is essentially hardcoded - i.e. we dont try to be 
> fancy.
> 
> User-space (gdb) on the other hand will try to allocate in the 
> db1..db2..db3..db4 order.
> 
> Maintain a 'max debug register index' value driven by ptrace and 
> maintain a 'min debug register index' driven by kernel-space 
> hw-breakpoint allocations.

A few added details from the perspective of powerpc ...

breakpoints and watchpoints are separate resources with different
capacity depending on the chip, so far nothing fancy.

We also have the ability to do range breakpoints/watchpoints on some
processors by using pairs of registers, which adds some constraints to
the allocation.

We also have a value compare capability for watchpoint, but this can
also have a different capacity limitation from either the breakpoints
and the watchpoints themselves.

Cheers,
Ben.

