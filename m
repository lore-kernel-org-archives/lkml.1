Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZD1Tpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZD1Tpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZD1Tpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:45:42 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49843 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbZD1Tpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:45:42 -0400
Date: Tue, 28 Apr 2009 12:45:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-ID: <20090428194537.GN6730@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090329203118.GA14005@linux.vnet.ibm.com> <20090203183426.GA14409@linux.vnet.ibm.com> <13990.1240928654@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13990.1240928654@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 03:24:14PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This patch is a version of RCU designed for (!SMP && EMBEDDED)
> > provided as a proof of concept of a small-footprint RCU implementation.
> > In particular, the implementation of synchronize_rcu() is extremely
> > lightweight and high performance.  It passes rcutorture testing in each
> > of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> > on x86.  This saves about 900 bytes compared to Classic RCU, and a
> > couple kilobytes compared to Hierarchical RCU:
> 
> On FRV, CLASSIC_RCU:
> 
>    text    data     bss     dec     hex filename
>    2616     184       0    2800     af0 kernel/rcuclassic.o
>     884      32      20     936     3a8 kernel/rcupdate.o
> 
> TREE_RCU:
> 
>    3940     328       0    4268    10ac kernel/rcutree.o
>     884      32      20     936     3a8 kernel/rcupdate.o
> 
> TINY_RCU:
> 
>    1152      32       0    1184     4a0 kernel/rcutiny.o
>     836      32      20     888     378 kernel/rcupdate.o
> 
> It works on my FRV board.
> 
> Possibly TINY_RCU could be shrunk a bit more by a judicious bit of inlining of
> some of the very small functions.
> 
> Acked-by: David Howells <dhowells@redhat.com>

Thank you for looking this over!

Your thought is that some of the functions could be moved to tinyrcu.h?
Indeed, some of them would be smaller if inlined than even the call
sequence.  For example, rcu_needs_cpu() should remove code from the
dynticks implementation given that it always returns zero.

							Thanx, Paul
