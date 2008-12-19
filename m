Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYLSFzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYLSFzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYLSFyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:54:52 -0500
Received: from ozlabs.org ([203.10.76.45]:55627 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYLSFyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:54:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: local_add_return
Date: Fri, 19 Dec 2008 16:24:45 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, benh@kernel.crashing.org, linux-ia64@vger.kernel.org,
       linux-s390@vger.kernel.org, Christoph Lameter <christoph@lameter.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Martin Bligh <mbligh@google.com>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com> <200812190922.57629.rusty@rustcorp.com.au> <20081219033514.GA7162@Krystal>
In-Reply-To: <20081219033514.GA7162@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812191624.46580.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 December 2008 14:05:14 Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> But can we turn what you call "nmi_safe_t" into "local_atomic_t" then ?
> Because we have to specify that this type must only be used as part of
> per-cpu data with preemption disabled, and we also specify that it is
> atomic.
> 
> Plus, nmi_safe_t does not make much sense on architectures without NMIs,
> where we sometimes disable interrupts to make the modification "atomic"
> wrt all other interrupts that can happen.

But those archs can use local_t.  I don't like either name local_t nor
atomic_local_t, but renaming sucks too.

OK, how about a different approach?  Since there's really only one case
where we need this local_t property outside arch-specific code, how about
we define ARCH_LOCAL_T_TRACE_SAFE for x86?

Then some trace-specific typedef like "trace_counter_t" which goes to local_t
or atomic_(long?)_t?

Should be a simple patch and pretty clear.

Thanks,
Rusty.
