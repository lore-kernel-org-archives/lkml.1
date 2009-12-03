Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZLCRBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZLCRBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZLCRBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:01:44 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57514 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753406AbZLCRBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:01:44 -0500
Date: Thu, 3 Dec 2009 11:01:49 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091203170149.GA15151@sgi.com>
References: <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com> <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain> <1259069986.4531.1453.camel@laptop> <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain> <20091124065022.6933be1a@infradead.org> <m1ws1f6csh.fsf@fess.ebiederm.org> <20091125074033.4c46c1b0@infradead.org> <20091203165004.GA14665@sgi.com> <Pine.WNT.4.64.0912030851500.13880@ppwaskie-MOBL2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.WNT.4.64.0912030851500.13880@ppwaskie-MOBL2.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 08:53:23AM -0800, Waskiewicz Jr, Peter P wrote:
> On Thu, 3 Dec 2009, Dimitri Sivanich wrote:
> 
> > On Wed, Nov 25, 2009 at 07:40:33AM -0800, Arjan van de Ven wrote:
> > > On Tue, 24 Nov 2009 09:41:18 -0800
> > > ebiederm@xmission.com (Eric W. Biederman) wrote:
> > > > Oii.
> > > > 
> > > > I don't think it is bad to export information to applications like
> > > > irqbalance.
> > > > 
> > > > I think it pretty horrible that one of the standard ways I have heard
> > > > to improve performance on 10G nics is to kill irqbalance.
> > > 
> > > irqbalance does not move networking irqs; if it does there's something
> > > evil going on in the system. But thanks for the bugreport ;)
> > 
> > It does move networking irqs.
> > 
> > > 
> > > we had that; it didn't work.
> > > what I'm asking for is for the kernel to expose the numa information;
> > > right now that is the piece that is missing.
> > > 
> > 
> > I'm wondering if we should expose that numa information in the form of a node or the set of allowed cpus, or both?
> > 
> > I'm guessing 'both' is the correct answer, so that apps like irqbalance can make a qualitative decision based on the node (affinity to cpus on this node is better), but an absolute decision based on allowed cpus (I cannot change affinity to anything but this set of cpus).
> 
> That's exactly what my patch in the thread "irq: Add node_affinity CPU 
> masks for smarter irqbalance hints" is doing.  I've also done the 
> irqbalance changes based on that kernel patch, and Arjan currently has 
> that patch.

So if I understand correctly, you're patch takes care of the qualitative portion of it (we prefer to set affinity to these cpus, which may be on more than one node), but not the restrictive part of it (we cannot change affinity to anything but these cpus)?
