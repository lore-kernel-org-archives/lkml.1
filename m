Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbXJZTeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbXJZTeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXJZTd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:33:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37945 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbXJZTd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:33:56 -0400
Date: Fri, 26 Oct 2007 21:33:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: spamtrap@knobisoft.de, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, wfg@mail.ustc.edu.cn,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: 2.6.24-rc1: First impressions
Message-ID: <20071026193339.GA21799@elte.hu>
References: <796505.25770.qm@web32612.mail.mud.yahoo.com> <20071026152221.GA26619@elte.hu> <20071026122155.45ce72e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026122155.45ce72e7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > dd1 - copy 16 GB from /dev/zero to local FS
> > > dd1-dir - same, but using O_DIRECT for output
> > > dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to local FS
> > > dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo local FS
> > > net1 - copy 5.2 GB from NFS3 share to local FS
> > > mix3 - copy 3x5.2 GB from /dev/zero to local disk and two NFS3 shares
> > > 
> > >  I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1. All units 
> > >  are MB/sec.
> > > 
> > > test           2.6.19.2     2.6.22.6    2.6.24.-rc1
> > > ----------------------------------------------------------------
> > > dd1                  28           50             96
> > > dd1-dir              88           88             86
> > > dd2              2x16.5         2x11         2x44.5
> > > dd2-dir            2x44         2x44           2x43
> > > dd3               3x9.8        3x8.7           3x30
> > > dd3-dir          3x29.5       3x29.5         3x28.5
> > > net1              30-33        50-55          37-52
> > > mix3              17/32        25/50          96/35 (disk/combined-network)
> > 
> > wow, really nice results!
> 
> Those changes seem suspiciously large to me.  I wonder if there's less 
> physical IO happening during the timed run, and correspondingly more 
> afterwards.

so a final 'sync' should be added to the test too, and the time it takes 
factored into the bandwidth numbers?

> > I think the MM should get out of deep-feature-freeze mode - there's 
> > tons of room to improve :-/
>
> Kidding.  We merge about 265 MM patches in 2.6.24-rc1:
>
>  482 files changed, 8071 insertions(+), 5142 deletions(-)

impressive :)

	Ingo
