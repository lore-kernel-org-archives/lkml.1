Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZGJKag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZGJKag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZGJKa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:30:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:51809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZGJKa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:30:28 -0400
Date: Fri, 10 Jul 2009 12:30:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, fche@redhat.com, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using mudflap
Message-ID: <20090710103025.GK14666@wotan.suse.de>
References: <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop> <20090710090351.GD14666@wotan.suse.de> <1247217263.771.8.camel@penberg-laptop> <20090710092921.GF14666@wotan.suse.de> <1247218826.771.15.camel@penberg-laptop> <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com> <1247219506.771.22.camel@penberg-laptop> <alpine.DEB.2.00.0907100253560.14601@chino.kir.corp.google.com> <84144f020907100310gec596cfo718631df2c7d9b46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020907100310gec596cfo718631df2c7d9b46@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 01:10:11PM +0300, Pekka Enberg wrote:
> Hi David,
> 
> On Fri, Jul 10, 2009 at 1:03 PM, David Rientjes<rientjes@google.com> wrote:
> > It's my opinion that slab is on its way out when there's no benchmark that
> > shows it is superior by any significant amount.  If that happens (and if
> > its successor is slub, slqb, or a yet to be implemented allocator), we can
> > probably start a discussion on what's in and what's out at that time.
> 
> Performance matters a lot, but it's certainly not the only priority
> here. Look at slab, it's bootstrap code is a train-wreck which bit us
> in the ass when we did the earlyslab thing and the NUMA support is
> pretty horrible. The code base hasn't received much attention for the
> past few years so unless someone steps up to clean it all, it's on
> it's way out, like it or not.
> 
> So if you care about performance and have benchmarks that are _known_
> to regress, you might want to focus your efforts on SLUB and/or SLQB
> because that's where the action happens these days.

Well OTOH performance is something that has some pretty fixed limits
by the design. If SLQB has any performance problems I can't fix, I
do intend to try to take the SLAB base allocator design and implement
it with more modern SL[UQ]B coding style and bootstrap code.

The reason I made some changes with SLQB is because I was trying to
remove nr_cpus*nr_nodes*lots allocations for the alien caches, and
I think the linked list style of queueing allows you to be more flexible
in queue sizes, and more cache efficient (especially when moving them
around).

We'll see...

