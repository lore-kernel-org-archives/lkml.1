Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZLVPeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZLVPeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZLVPeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:34:01 -0500
Received: from mail15.bluewin.ch ([195.186.18.63]:25246 "EHLO
	mail15.bluewin.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZLVPeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:34:00 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Dec 2009 10:34:00 EST
X-FXIT-IP: IPv4[83.78.128.103] Epoch[1261495615]
Date: Tue, 22 Dec 2009 16:26:59 +0100
From: Roger Luethi <rl@hellgate.ch>
To: Andrey Rahmatullin <wrar@altlinux.org>
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: via_rhine kernel crashes in 2.6.32
Message-ID: <20091222152658.GA16043@core.hellgate.ch>
References: <alpine.DEB.2.01.0912211040100.3483@bogon.housecafe.de>
 <20091222123211.GA8546@ff.dom.local>
 <20091222132107.GA9060@ff.dom.local>
 <20091222133817.GA9208@ff.dom.local>
 <20091222150045.GA5355@wrars-comp.wrarsdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222150045.GA5355@wrars-comp.wrarsdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 20:00:45 +0500, Andrey Rahmatullin wrote:
> On Tue, Dec 22, 2009 at 01:38:17PM +0000, Jarek Poplawski wrote:
> > > > It looks like napi_disable() should be illegal in ndo_tx_timeout().
> > > > Here is a patch which moves most of the timeout work to a workqueue,
> > > > similarly to tg3 etc. It should prevent at least one of reported
> > > > bugs. Alas I can't even check-compile it at the moment, so let me
> > > > know on any problems.
> > > It seems I needlessly changed locking btw, so here it is again.
> > Hmm... On the other hand, it definitely needs at least _bh now...
> I've tried this patch. There are lots of "Transmit timed out", but no
> crashes.

ACK. Looks like you guys tracked down the crashing and fixed it (thanks!).
I suspect we shouldn't have to reset due to timeouts that often, but that's
another story.

Roger
