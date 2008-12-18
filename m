Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYLRWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYLRWxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYLRWxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:53:03 -0500
Received: from ozlabs.org ([203.10.76.45]:33810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbYLRWxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:53:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: local_add_return
Date: Fri, 19 Dec 2008 09:22:56 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, benh@kernel.crashing.org, linux-ia64@vger.kernel.org,
       linux-s390@vger.kernel.org, Christoph Lameter <christoph@lameter.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Martin Bligh <mbligh@google.com>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com> <200812170908.05423.rusty@rustcorp.com.au> <20081217000155.GA28174@Krystal>
In-Reply-To: <20081217000155.GA28174@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812190922.57629.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2008 10:31:55 Mathieu Desnoyers wrote:
> I think we have two different use-cases here :
> 
> - local_t is useful as-is for things such as a tracer, which need to
>   modify an element of data atomically wrt local interrupts. The
>   atomic_long_t, in this case, is the correct fallback.
> - local_count_t could be used for fast counters.

Hi Mathieu,

   Complete agreement.

   I guess I'm biassed towards local_t == counter version, something else
== nmi-safe version because that's what it was originally.  Looking through
the tree, there are only 5 users: module, dmaengine and percpu_counter want
a counter, and tracing and x86 nmi.c want nmi-safe.  There are several other
places I know of which want local_t-the-counter.

   I'll prepare a patch which adds nmi_safe_t, and see how it looks.  There's
no amazing hurry on this, so I won't race to hit the merge window.

Thanks!
Rusty.
