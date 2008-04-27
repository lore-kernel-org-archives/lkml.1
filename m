Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbYD0SdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbYD0SdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759270AbYD0SdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:33:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbYD0SdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:33:04 -0400
Date: Sun, 27 Apr 2008 14:32:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Adrian Bunk <bunk@kernel.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427183252.GB23828@infradead.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org> <20080427174714.GB2252@cs181133002.pp.htv.fi> <20080427180007.GB28483@infradead.org> <20080427180957.GA25964@uranus.ravnborg.org> <20080427181411.GA31667@infradead.org> <alpine.LFD.1.10.0804271118500.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804271118500.2896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 11:24:28AM -0700, Linus Torvalds wrote:
> The thing is, the "inline" vs "always_inline" thing _could_ make sense, 
> but sadly doesn't much.
> 
> Part of it is that gcc imnsho inlines too aggressively anyway in the 
> absense of "inline", so there's no way "inline" can mean "you might 
> inline" this, because gcc will do that anyway even without it. As a 
> result, in _practice_ "inline" and "always_inline" end up being very close 
> to each other - perhaps more so than they should.

Yes, absolutely.   In recent gcc versions it's in fact so bad that xfs
had to add a hack to mark every function not explicitly marker inline
noinline because otherwise gcc would inline gazillions of big functions
which combines with it's horrible liveness analysis led to enormous
stack useage.  (I think the liveness part is getting better these days
to be fair)

> It will take time before we've sorted out all the fall-out, because I bet 
> there is still code out there that _should_ use __always_inline, but 
> doesn't.

Given that __always_inline only shows up in non-x86 arch code in
homeopathic quantity it's a fair bet that there's a lot of breakage
waiting there.  Which was one of the initial complains about the way
it's done..
