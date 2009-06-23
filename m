Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZFWJc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZFWJc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZFWJcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:32:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZFWJcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:32:20 -0400
Date: Tue, 23 Jun 2009 11:32:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v5 RCU: the bloatwatch edition
Message-ID: <20090623093208.GD23698@elte.hu>
References: <20090623042442.GA15630@linux.vnet.ibm.com> <28711.1245748358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28711.1245748358@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This patch is a version of RCU designed for (!SMP && EMBEDDED)
> > provided as a proof of concept of a small-footprint RCU implementation.
> > In particular, the implementation of synchronize_rcu() is extremely
> > lightweight and high performance.  It passes rcutorture testing in each
> > of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> > on x86.  This saves 1263 bytes compared to Classic RCU, and more than
> > three kilobytes compared to Hierarchical RCU (updated to 2.6.30):
> 
> On FRV:
> 
> 	CONFIG_CLASSIC_RCU=y
> 
> 	   text    data     bss     dec     hex filename
> 	    884      32      20     936     3a8 kernel/rcupdate.o
> 	   2616     184       0    2800     af0 kernel/rcuclassic.o
> 
> 	CONFIG_TREE_RCU=y
> 
> 	   text    data     bss     dec     hex filename
> 	    884      32      20     936     3a8 kernel/rcupdate.o
> 	   4068     384       0    4452    1164 kernel/rcutree.o
> 
> 	CONFIG_TINY_RCU=y
> 
> 	   text    data     bss     dec     hex filename
> 	    836      32      20     888     378 kernel/rcupdate.o
> 	    816      24       0     840     348 kernel/rcutiny.o
> 
> On MN10300:
> 
> 	CONFIG_CLASSIC_RCU=y
> 
> 	   text    data     bss     dec     hex filename
> 	    900      28      48     976     3d0 kernel/rcupdate.o
> 	   1777     184       0    1961     7a9 kernel/rcuclassic.o
> 
> 	CONFIG_TREE_RCU=y
> 
> 	   text    data     bss     dec     hex filename
> 	    900      28      48     976     3d0 kernel/rcupdate.o
> 	   2733     384       0    3117     c2d kernel/rcutree.o
> 
> 	CONFIG_PREEMPT_RCU=y
> 
> 	   text    data     bss     dec     hex filename
> 	    961      28      48    1037     40d kernel/rcupdate.o
> 	   3314     128       8    3450     d7a kernel/rcupreempt.o
> 
> 	CONFIG_TINY_RCU=y
> 
> 	   text    data     bss     dec     hex filename
> 	    865      28      48     941     3ad kernel/rcupdate.o
> 	    500      24       0     524     20c kernel/rcutiny.o
> 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: David Howells <dhowells@redhat.com

Ok, that's more convincing than 900 bytes on x86.

Paul, i guess this is .32 material anyway, right?

Since there's plenty of time, could we perhaps also do the 
classic-rcu removal and integrate-rcupreempt-into-tree-rcu steps, to 
reduce the (significant) config complexity perhaps?

	Ingo
