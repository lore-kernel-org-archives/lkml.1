Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZGNRfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZGNRfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZGNRfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:35:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48825 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZGNRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:35:36 -0400
Date: Tue, 14 Jul 2009 13:35:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Alan.Brunelle@hp.com,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Fix blktrace unaligned memory access
In-Reply-To: <20090710093601.GF23611@kernel.dk>
Message-ID: <alpine.DEB.2.00.0907141332060.32740@gandalf.stny.rr.com>
References: <20090710075339.GX23611@kernel.dk> <4A5704EA.5000807@cn.fujitsu.com> <20090710091337.GD23611@kernel.dk> <4A570A34.5090002@cn.fujitsu.com> <20090710093601.GF23611@kernel.dk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jul 2009, Jens Axboe wrote:

> On Fri, Jul 10 2009, Li Zefan wrote:
> > Jens Axboe wrote:
> > > On Fri, Jul 10 2009, Li Zefan wrote:
> > >> Jens Axboe wrote:
> > >>> Hi,
> > >>>
> > >>> It seems that relay_reserve() (or the ring_buffer_event_data(), that one
> > >>> still needs some love) can return unaligned memory, there's no way
> > >>> around that when you have pdu lengths that aren't a nice size. This can
> > >>> cause unaligned access warnings on platforms that care about alignment.
> > >>>
> > >> Seems relay_reserve() does nothing for alignment..On the other hand,
> > >> ring_buffer_event_data() returns a ptr which is 32bit-aligned, but
> > >> this still means it can cause unaligned accesses on 64bits arch, while
> > >> I think it's fixable in ring buffer, it's certainly not an easy job.

Correct, this is only needed if the data is bigger than 32 bits.


> > > 
> > > Right, it's a bit nasty...
> > > 
> > 
> > Lai Jiangshan noticed this issue long ago and had some ideas in mind
> > how to fix ring buffer, but never try it out for it will probably be
> > frustrating..

Perhaps we can make an attribute for the ring buffer itself that would 
allow the user to give an alignment. Would anything ever need a bigger 
than 64bit (8 byte) alignment? We can set a flag that says, make all 
entries 8 bytes aligned.

-- Steve

