Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbZD1OZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbZD1OZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZD1OZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:25:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48913 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbZD1OZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:25:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090329203118.GA14005@linux.vnet.ibm.com>
References: <20090329203118.GA14005@linux.vnet.ibm.com> <20090203183426.GA14409@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Date: Tue, 28 Apr 2009 15:24:14 +0100
Message-ID: <13990.1240928654@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch is a version of RCU designed for (!SMP && EMBEDDED)
> provided as a proof of concept of a small-footprint RCU implementation.
> In particular, the implementation of synchronize_rcu() is extremely
> lightweight and high performance.  It passes rcutorture testing in each
> of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> on x86.  This saves about 900 bytes compared to Classic RCU, and a
> couple kilobytes compared to Hierarchical RCU:

On FRV, CLASSIC_RCU:

   text    data     bss     dec     hex filename
   2616     184       0    2800     af0 kernel/rcuclassic.o
    884      32      20     936     3a8 kernel/rcupdate.o

TREE_RCU:

   3940     328       0    4268    10ac kernel/rcutree.o
    884      32      20     936     3a8 kernel/rcupdate.o

TINY_RCU:

   1152      32       0    1184     4a0 kernel/rcutiny.o
    836      32      20     888     378 kernel/rcupdate.o

It works on my FRV board.

Possibly TINY_RCU could be shrunk a bit more by a judicious bit of inlining of
some of the very small functions.

Acked-by: David Howells <dhowells@redhat.com>
