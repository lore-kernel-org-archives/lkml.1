Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbZFWPor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbZFWPor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbZFWPoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:44:39 -0400
Received: from xi.wantstofly.org ([80.101.37.227]:51597 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZFWPoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:44:39 -0400
Date: Tue, 23 Jun 2009 17:47:01 +0200
From: Lennert Buytenhek <kernel@wantstofly.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, niv@us.ibm.com,
       dvhltc@us.ibm.com, lethal@linux-sh.org, matthew@wil.cx,
       linux@arm.linux.org.uk
Subject: Re: [PATCH] v5 RCU: the bloatwatch edition
Message-ID: <20090623154701.GA19647@mail.wantstofly.org>
References: <20090623042442.GA15630@linux.vnet.ibm.com> <28711.1245748358@redhat.com> <20090623093208.GD23698@elte.hu> <20090623125832.GA6872@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623125832.GA6872@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 05:58:32AM -0700, Paul E. McKenney wrote:

> > > > This patch is a version of RCU designed for (!SMP && EMBEDDED)
> > > > provided as a proof of concept of a small-footprint RCU implementation.
> > > > In particular, the implementation of synchronize_rcu() is extremely
> > > > lightweight and high performance.  It passes rcutorture testing in each
> > > > of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> > > > on x86.  This saves 1263 bytes compared to Classic RCU, and more than
> > > > three kilobytes compared to Hierarchical RCU (updated to 2.6.30):
> > > 
> > > On FRV:
> > > 
> > > 	CONFIG_CLASSIC_RCU=y
> > > 
> > > 	   text    data     bss     dec     hex filename
> > > 	    884      32      20     936     3a8 kernel/rcupdate.o
> > > 	   2616     184       0    2800     af0 kernel/rcuclassic.o
> > > 
> > > 	CONFIG_TREE_RCU=y
> > > 
> > > 	   text    data     bss     dec     hex filename
> > > 	    884      32      20     936     3a8 kernel/rcupdate.o
> > > 	   4068     384       0    4452    1164 kernel/rcutree.o
> > > 
> > > 	CONFIG_TINY_RCU=y
> > > 
> > > 	   text    data     bss     dec     hex filename
> > > 	    836      32      20     888     378 kernel/rcupdate.o
> > > 	    816      24       0     840     348 kernel/rcutiny.o
> > > 
> > > On MN10300:
> > > 
> > > 	CONFIG_CLASSIC_RCU=y
> > > 
> > > 	   text    data     bss     dec     hex filename
> > > 	    900      28      48     976     3d0 kernel/rcupdate.o
> > > 	   1777     184       0    1961     7a9 kernel/rcuclassic.o
> > > 
> > > 	CONFIG_TREE_RCU=y
> > > 
> > > 	   text    data     bss     dec     hex filename
> > > 	    900      28      48     976     3d0 kernel/rcupdate.o
> > > 	   2733     384       0    3117     c2d kernel/rcutree.o
> > > 
> > > 	CONFIG_PREEMPT_RCU=y
> > > 
> > > 	   text    data     bss     dec     hex filename
> > > 	    961      28      48    1037     40d kernel/rcupdate.o
> > > 	   3314     128       8    3450     d7a kernel/rcupreempt.o
> > > 
> > > 	CONFIG_TINY_RCU=y
> > > 
> > > 	   text    data     bss     dec     hex filename
> > > 	    865      28      48     941     3ad kernel/rcupdate.o
> > > 	    500      24       0     524     20c kernel/rcutiny.o
> > > 
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Acked-by: David Howells <dhowells@redhat.com
> > 
> > Ok, that's more convincing than 900 bytes on x86.
> 
> It used to be 900 bytes.  In 2.6.30, it is 1263 bytes.  ;-)
> 
> That said, I agree that FRV and MN10300 savings are more impressive.
> 
> > Paul, i guess this is .32 material anyway, right?
> 
> I am personally OK with it being .32, as long as David Howells,
> Lennert Buytenhek, and Paul Mundt are OK with that schedule.

I like the patch, as nearly all ARM systems in the field right now are
non-SMP.  Russell King (CCd) is the ARM maintainer, so he should comment
on the proposed timeline.
