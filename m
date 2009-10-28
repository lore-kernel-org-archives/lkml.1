Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZJ1Fh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZJ1Fh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbZJ1Fh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:37:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbZJ1Fh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:37:28 -0400
Date: Wed, 28 Oct 2009 03:36:36 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Walls <awalls@radix.net>, Stefani Seibold <stefani@seibold.net>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
Message-ID: <20091028033636.07e547b4@pedra.chehab.org>
In-Reply-To: <20091028032049.GB7744@basil.fritz.box>
References: <1256694571.3131.26.camel@palomino.walls.org>
	<20091028032049.GB7744@basil.fritz.box>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 28 Oct 2009 04:20:49 +0100
Andi Kleen <andi@firstfloor.org> escreveu:

With respect to the kfifo series of patches:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> > Here's a V4L-DVB cx23885 module change, that is on its way upstream,
> > that uses kfifo as is:
> > 
> > http://linuxtv.org/hg/v4l-dvb/rev/a2d8d3d88c6d
> > 
> > Do you really have to break the old API?
> 
> That was extensively discussed in the original patch kit submission,
> and yes there are good reasons. You will just have to adapt
> the driver if it gets in after the new kfifo patches; if kfifo
> gets in later it'll have to adapt it.

I agree. The current kfifo implementation is very limited that can't be
used on several places. Changing its implementation to be generic enough
requires changing the API, since, on several places, we don't want to have
a spinlock. So, as we'll need to change the API anyway, better to do it at the
right way.

That's said, i7core_edac will also need the new kfifo API for 2.6.33, so I'll
have to handle this upstream change anyway. So, the faster this change went into
upstream, the better, since I'll hold my pull requests to happen after it.

Since I'll have 2 -git trees depending on this change (i7core_edac and v4l-dvb),
the better is if you could put the kfifo code on a git tree that won't be
rebased. This way, we can make our trees based on kfifo -git tree, having
everything rebased there to avoid any merge or bisect conflict (in my case,
cx23885 will need to be rebased, and i7core_edac will need kfifo -git objects
for a new NMI-aware fifo implementation using kfifo)



Cheers,
Mauro
