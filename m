Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYIOVvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYIOVvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYIOVu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:50:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56883 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752855AbYIOVuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:50:55 -0400
Date: Mon, 15 Sep 2008 16:50:53 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080915215053.GA11657@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914153522.GJ29290@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 05:35:22PM +0200, Ingo Molnar wrote:
> 
> * Dean Nelson <dcn@sgi.com> wrote:
> 
> > On Mon, Aug 11, 2008 at 12:39:22PM -0700, Eric W. Biederman wrote:
> > >
> > > Although I am not at all convinced that dynamic allocation of
> > > the vector number (instead of statically reserving it makes sense).
> > 
> > We (SGI) need somewhere around eight vectors.
> > 
> > There are two kernel modules, sgi-gru and sgi-xp (in drivers/misc), 
> > that each need two vectors. And there's the broadcast assist unit 
> > (BAU) that is involved in tlb shootdown on uv, which currently uses 
> > statically reserved vector 0xf8 (UV_BAU_MESSAGE -- see uv_bau_init()). 
> 
> while i understand the UV_BAU_MESSAGE case (TLB flushes are special), 
> why does sgi-gru and sgi-xp need to go that deep? They are drivers, they 
> should be able to make use of an ordinary irq just like the other 2000 
> drivers we have do.

The sgi-gru driver needs to be able to allocate a single irq/vector pair for
all CPUs even those that are not currently online. The sgi-xp driver has
similar but not as stringent needs.

The current __assign_irq_vector() restricts the allocation of the irq/vector
pair to a single CPU and its vector_allocation_domain().


> > I know of a debugger that also uses 0xf8 because it was previously 
> > available until UV_BAU_MESSAGE came along. The BAU would be happy with 
> > a dynamically allocated system vector. We have a couple of other 
> > things in the works that also need vectors.
> 
> which debugger is this?

KDB.
