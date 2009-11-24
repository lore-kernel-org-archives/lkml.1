Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbZKXIjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbZKXIjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbZKXIjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:39:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbZKXIjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:39:44 -0500
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Yong Zhang <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <4B0B782A.4030901@linux.intel.com>
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>
	 <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>
	 <1258968980.2697.9.camel@ppwaskie-mobl2> <1258995923.4531.715.camel@laptop>
	  <4B0B782A.4030901@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 09:39:46 +0100
Message-ID: <1259051986.4531.1057.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 22:07 -0800, Arjan van de Ven wrote:
> Peter Zijlstra wrote:
> > On Mon, 2009-11-23 at 01:36 -0800, Peter P Waskiewicz Jr wrote:
> > 
> >> This mechanism isn't going to be used by any internal kernel mechanism
> >> for determining interrupt placement or operation.  It's purely something
> >> that either a driver can modify, or external script (through /proc),
> >> that irqbalance will make use of.  If irqbalance isn't running, or the
> >> current version of irqbalance doesn't support reading node_affinity,
> >> then it won't affect the system's operation.
> >>
> >> If irqbalance does support it, it'll read whatever the supplied mask is,
> >> and then will try and balance interrupts within that mask.  It will bail
> >> if the mask is invalid, or won't apply to the running system, just like
> >> how putting a bogus mask into smp_affinity is ignored.
> >>
> >> If there's something I'm missing beyond this with the two suggestions
> >> you've made (I looked into those two parameters and tried to draw
> >> conclusions), please let me know.
> > 
> > I don't see the point in adding it, if the driver wants to set a node
> > cpu mask it can already do that using the regular smp affinity settings.
> > 
> > Same for userspace.
> 
> the problem is that there is no way currently that the driver can communicate
> "I allocated all my metadata on THIS numa node". irqbalance and sysadmins need
> that to not make really stupid decisions.....

And what exactly is struct device::numa_node good for then?

