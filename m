Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZFWJNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZFWJNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZFWJNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:13:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37895 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZFWJNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:13:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090623042442.GA15630@linux.vnet.ibm.com>
References: <20090623042442.GA15630@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v5 RCU: the bloatwatch edition
Date: Tue, 23 Jun 2009 10:12:38 +0100
Message-ID: <28711.1245748358@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch is a version of RCU designed for (!SMP && EMBEDDED)
> provided as a proof of concept of a small-footprint RCU implementation.
> In particular, the implementation of synchronize_rcu() is extremely
> lightweight and high performance.  It passes rcutorture testing in each
> of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> on x86.  This saves 1263 bytes compared to Classic RCU, and more than
> three kilobytes compared to Hierarchical RCU (updated to 2.6.30):

On FRV:

	CONFIG_CLASSIC_RCU=y

	   text    data     bss     dec     hex filename
	    884      32      20     936     3a8 kernel/rcupdate.o
	   2616     184       0    2800     af0 kernel/rcuclassic.o

	CONFIG_TREE_RCU=y

	   text    data     bss     dec     hex filename
	    884      32      20     936     3a8 kernel/rcupdate.o
	   4068     384       0    4452    1164 kernel/rcutree.o

	CONFIG_TINY_RCU=y

	   text    data     bss     dec     hex filename
	    836      32      20     888     378 kernel/rcupdate.o
	    816      24       0     840     348 kernel/rcutiny.o

On MN10300:

	CONFIG_CLASSIC_RCU=y

	   text    data     bss     dec     hex filename
	    900      28      48     976     3d0 kernel/rcupdate.o
	   1777     184       0    1961     7a9 kernel/rcuclassic.o

	CONFIG_TREE_RCU=y

	   text    data     bss     dec     hex filename
	    900      28      48     976     3d0 kernel/rcupdate.o
	   2733     384       0    3117     c2d kernel/rcutree.o

	CONFIG_PREEMPT_RCU=y

	   text    data     bss     dec     hex filename
	    961      28      48    1037     40d kernel/rcupdate.o
	   3314     128       8    3450     d7a kernel/rcupreempt.o

	CONFIG_TINY_RCU=y

	   text    data     bss     dec     hex filename
	    865      28      48     941     3ad kernel/rcupdate.o
	    500      24       0     524     20c kernel/rcutiny.o

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: David Howells <dhowells@redhat.com
