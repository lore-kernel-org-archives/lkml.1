Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXJZTnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXJZTnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXJZTnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:43:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbXJZTng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:43:36 -0400
Date: Fri, 26 Oct 2007 12:42:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: spamtrap@knobisoft.de, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, wfg@mail.ustc.edu.cn,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: 2.6.24-rc1: First impressions
Message-Id: <20071026124252.aba97af4.akpm@linux-foundation.org>
In-Reply-To: <20071026193339.GA21799@elte.hu>
References: <796505.25770.qm@web32612.mail.mud.yahoo.com>
	<20071026152221.GA26619@elte.hu>
	<20071026122155.45ce72e7.akpm@linux-foundation.org>
	<20071026193339.GA21799@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 21:33:40 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > dd1 - copy 16 GB from /dev/zero to local FS
> > > > dd1-dir - same, but using O_DIRECT for output
> > > > dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to local FS
> > > > dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo local FS
> > > > net1 - copy 5.2 GB from NFS3 share to local FS
> > > > mix3 - copy 3x5.2 GB from /dev/zero to local disk and two NFS3 shares
> > > > 
> > > >  I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1. All units 
> > > >  are MB/sec.
> > > > 
> > > > test           2.6.19.2     2.6.22.6    2.6.24.-rc1
> > > > ----------------------------------------------------------------
> > > > dd1                  28           50             96
> > > > dd1-dir              88           88             86
> > > > dd2              2x16.5         2x11         2x44.5
> > > > dd2-dir            2x44         2x44           2x43
> > > > dd3               3x9.8        3x8.7           3x30
> > > > dd3-dir          3x29.5       3x29.5         3x28.5
> > > > net1              30-33        50-55          37-52
> > > > mix3              17/32        25/50          96/35 (disk/combined-network)
> > > 
> > > wow, really nice results!
> > 
> > Those changes seem suspiciously large to me.  I wonder if there's less 
> > physical IO happening during the timed run, and correspondingly more 
> > afterwards.
> 
> so a final 'sync' should be added to the test too, and the time it takes 
> factored into the bandwidth numbers?

That's one way of doing it.  Or just run the test for a "long" time.  ie:
much longer than (total-memory / disk-bandwidth).  Probably the latter
will give a more accurate result, but it can get boring.

> > > I think the MM should get out of deep-feature-freeze mode - there's 
> > > tons of room to improve :-/
> >
> > Kidding.  We merge about 265 MM patches in 2.6.24-rc1:
> >
> >  482 files changed, 8071 insertions(+), 5142 deletions(-)
> 
> impressive :)

A lot of that was new functionality.  That's easier to add than things
which change long-standing functionality.
