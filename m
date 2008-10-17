Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYJQAwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYJQAwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYJQAwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:52:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:39351 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbYJQAwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:52:22 -0400
Subject: Re: [PATCH] ftrace: powerpc: remove startup functions from tracing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.1.10.0810162046570.20570@gandalf.stny.rr.com>
References: <20080906050602.409299112@goodmis.org>
	 <20080906120346.GA30964@elte.hu>
	 <20081016181452.GA29739@yoda.jdub.homelinux.org>
	 <alpine.DEB.1.10.0810162046570.20570@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 11:50:46 +1100
Message-Id: <1224204646.7654.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 20:48 -0400, Steven Rostedt wrote:
> 
> The early init code in PowerPC is not mapped to their final locations
> and all jumps and memory references must be done with relative jumps
> and accesses.
> 
> The lib files in the powerpc directory are called in early boot, and
> since mcount will perform direct access to memory, the lib files need
> not be traced.

This is annoying though, because that means things like memcpy,
copy_to_from_user etc... can't be traced. On the other hand a lot
of that is asm and already doesn't call mcount.

Cheers,
Ben.


