Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZFOJlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZFOJlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZFOJls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:41:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:56306 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZFOJlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:41:47 -0400
Date: Mon, 15 Jun 2009 11:41:48 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615094148.GC1314@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:10:01PM +0300, Pekka Enberg wrote:
> On Mon, Jun 15, 2009 at 11:18 AM, Heiko
> Carstens<heiko.carstens@de.ibm.com> wrote:
> > I didn't look any deeper into this, but looks to me like doing something like
> > schedule_work() this early isn't ok.
> >
> > This is the conversion that leads to the crash:
> >
> > -               alloc_bootmem_low(sizeof(struct raw3215_info));
> > +               kzalloc(sizeof(struct raw3215_info), GFP_NOWAIT | GFP_DMA);
> >
> > Might be that I missed something. Maybe some special flag?
> 
> Btw, you should not need to use GFP_NOWAIT anymore and GFP_KERNEL
> should be fine even during early boot.

Is this the agreed way forward? I would like to maybe continue to
try having early allocations pass in special flags where possible
(it could even be a GFP_BOOT or something). It can make it easier
to perhaps reduce branches in core code in future and things can
be flagged in warnings....

I just like the idea of keeping such annotations.
