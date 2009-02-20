Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZBTK3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZBTK3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZBTK30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:29:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbZBTK3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:29:25 -0500
Date: Fri, 20 Feb 2009 11:29:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stefanr@s5r6.in-berlin.de, yanghy@cn.fujitsu.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       petkovbb@googlemail.com
Subject: Re: [PATCHv2 00/11]Get rid of all the old macro DMA_nBIT_MASK and
	use DMA_BIT_MASK(n) instead
Message-ID: <20090220102904.GA28581@elte.hu>
References: <499CFDC8.1070600@cn.fujitsu.com> <499D0221.9090407@cn.fujitsu.com> <20090219081403.GA5400@elte.hu> <499D1ED9.4040005@cn.fujitsu.com> <499D2728.1080208@cn.fujitsu.com> <499D54F6.7000108@s5r6.in-berlin.de> <20090219150851.GC22611@elte.hu> <20090219151409.0d61de2a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219151409.0d61de2a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 19 Feb 2009 16:08:51 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > 
> > > Yang Hongyang wrote:
> > > > v1->v2:fix s/micro/macro typo and keep the old defines
> > > >             of DMA_nBIT_MASK
> > > > ----------------------
> > > > Replace all DMA_nBIT_MASK macro with the new DMA_BIT_MASK(n) macro
> > > > 
> > > > 01:Replace all DMA_64BIT_MASK macro with DMA_BIT_MASK(64)
> > > > 02:Replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)
> > > > 03:Replace all DMA_40BIT_MASK macro with DMA_BIT_MASK(40)
> > > > 04:Replace all DMA_39BIT_MASK macro with DMA_BIT_MASK(39)
> > > > 05:Replace all DMA_35BIT_MASK macro with DMA_BIT_MASK(35)
> > > > 06:Replace all DMA_32BIT_MASK macro with DMA_BIT_MASK(32)
> > > > 07:Replace all DMA_31BIT_MASK macro with DMA_BIT_MASK(31)
> > > > 08:Replace all DMA_30BIT_MASK macro with DMA_BIT_MASK(30)
> > > > 09:Replace all DMA_28BIT_MASK macro with DMA_BIT_MASK(28)
> > > > 10:Replace all DMA_24BIT_MASK macro with DMA_BIT_MASK(24)
> > > > 11:Update the old macro DMA_nBIT_MASK related documentations
> > > > 
> > > 
> > > Shouldn't you organize the patch series per subsystem, not per old
> > > macro?  And then Cc the respective maintainers?
> > > 
> > > As it stands, the patches cannot be routed through the normal channels;
> > > yet there is no fundamental reason to handle these patches differently
> > > from normal patches.
> > 
> > Traditionally such trivially correct convert-it-all patches 
> > lived in -mm and were merged upstream in one go, near the end of 
> > the merge window.
> > 
> > Sprinkling it into dozens of subsystem channels (some of which 
> > are very unreliable) is neither good nor an economic use of our 
> > resources.
> > 
> > Patches that can potentially cause trouble should go via the 
> > usual channels.
> > 
> 
> yes, fun.
> 
> I hit several rejects merging these, easily fixed.  After this 
> lot is merged there will probably be a few unconverted sites 
> which will need a second pass.  After that we can think about 
> removing the old #defines.

Yeah. I wanted to suggest for you to _drop_ all conflicts - 
because the old defines still live.

That makes it the easiest for you to keep it all merged up in 
the future too with minimum fuss, and we need a second pass 
anyway so dropping a few hunks is no big issue.

[ But since you merged it up that's fine too - it's just that 
  code that got changed recently and created conflicts has a 
  higher chance of being changed in the near future too - and 
  causing you ongoing conflicts in that area, in the next ~1.5 
  months until the next merge window closes. ]

	Ingo
