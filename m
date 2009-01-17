Return-Path: <linux-kernel-owner+w=401wt.eu-S1763797AbZAQB20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763797AbZAQB20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 20:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZAQB2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 20:28:17 -0500
Received: from ozlabs.org ([203.10.76.45]:56176 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZAQB2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 20:28:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18801.13239.198051.944029@cargo.ozlabs.ibm.com>
Date: Sat, 17 Jan 2009 12:26:15 +1100
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net, maynardj@us.ibm.com
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <4970CB6F.9000301@linux.vnet.ibm.com>
References: <20081214212829.GA9435@elte.hu>
	<18758.18810.350923.806445@cargo.ozlabs.ibm.com>
	<1229437341.7025.11.camel@twins>
	<18760.13407.568536.198724@cargo.ozlabs.ibm.com>
	<87ljuf1s75.fsf@basil.nowhere.org>
	<4970CB6F.9000301@linux.vnet.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> Over time, it seems clear that we will see multi-core processor designs 
> with increasingly large uncore/nest facilities, so this could become 
> more and more of an issue.

Those nest events still get counted on counters that are in the CPU
core, right?  So that sounds like they can be counted by one or more
per-cpu perf_counter instances.  That means that you're measuring them
across all processes.  Does it make any sense to try to attribute
those events to individual processes?  How would one do that?

Clearly, something has to know enough about the system topology to
know how many counters are needed and which (virtual) cpus they should
be on.  At present that defaults to userspace, but we could extend
perf_counters to handle it in the kernel by adding 'core' and 'node'
specifiers to the hw_event structure (assuming a three-level node /
core / cpu hierarchy for the system structure).

Paul.
