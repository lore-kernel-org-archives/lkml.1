Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667Ab0AKVUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0AKVUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249Ab0AKVUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:20:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0AKVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:20:11 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v3a)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100111205250.GA6866@Krystal>
References: <20100110014456.GG25790@Krystal>
	 <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com>
	 <1263124209.28171.3798.camel@gandalf.stny.rr.com>
	 <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal>
	 <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal>
	 <20100111042903.GC32213@Krystal> <1263232240.4244.70.camel@laptop>
	 <20100111205250.GA6866@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 22:19:17 +0100
Message-ID: <1263244757.4244.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 15:52 -0500, Mathieu Desnoyers wrote:
> 
> So the clear bit can occur far, far away in the future, we don't care.
> We'll just send extra IPIs when unneeded in this time-frame.

I think we should try harder not to disturb CPUs, particularly in the
face of RT tasks and DoS scenarios. Therefore I don't think we should
just wildly send to mm_cpumask(), but verify (although speculatively)
that the remote tasks' mm matches ours.



