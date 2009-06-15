Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZFOJtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZFOJtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbZFOJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:48:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54452 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbZFOJso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:48:44 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org,
       benh@kernel.crashing.org
In-Reply-To: <20090615094148.GC1314@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de>
Date: Mon, 15 Jun 2009 12:48:44 +0300
Message-Id: <1245059324.23207.13.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Mon, Jun 15, 2009 at 11:18 AM, Heiko Carstens<heiko.carstens@de.ibm.com> wrote:
> > > I didn't look any deeper into this, but looks to me like doing something like
> > > schedule_work() this early isn't ok.
> > >
> > > This is the conversion that leads to the crash:
> > >
> > > -               alloc_bootmem_low(sizeof(struct raw3215_info));
> > > +               kzalloc(sizeof(struct raw3215_info), GFP_NOWAIT | GFP_DMA);
> > >
> > > Might be that I missed something. Maybe some special flag?

On Mon, Jun 15, 2009 at 12:10:01PM +0300, Pekka Enberg wrote:
> > Btw, you should not need to use GFP_NOWAIT anymore and GFP_KERNEL
> > should be fine even during early boot.

On Mon, 2009-06-15 at 11:41 +0200, Nick Piggin wrote:
> Is this the agreed way forward? I would like to maybe continue to
> try having early allocations pass in special flags where possible
> (it could even be a GFP_BOOT or something). It can make it easier
> to perhaps reduce branches in core code in future and things can
> be flagged in warnings....
> 
> I just like the idea of keeping such annotations.

I don't know if we agreed or not but Linus expressed his liking to the
masking patch (that is merged now).

I was more on the GFP_BOOT side also but I am beginning to like the fact
that we can just do GFP_KERNEL and expect that to work in a sane way
during boot (and perhaps later on during suspend). We can probably shave
off even more cycles for production configs if we push the masking down
to the page allocator so I am not sure if extra cycles are going to be a
real issue.

			Pekka

