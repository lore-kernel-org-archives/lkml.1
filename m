Return-Path: <linux-kernel-owner+w=401wt.eu-S934778AbXHMXUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbXHMXUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbXHMXUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:20:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:47098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbXHMXUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:20:33 -0400
Date: Tue, 14 Aug 2007 02:14:41 +0200
From: Andi Kleen <ak@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070814001441.GN3406@bingen.suse.de>
References: <20070813225020.GE3406@bingen.suse.de> <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com> <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com> <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com> <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com> <20070814000041.GL3406@bingen.suse.de> <20070814002223.2d8d42c5@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814002223.2d8d42c5@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 12:22:23AM +0100, Alan Cox wrote:
> > The only tricky part were skbs in a few drivers, but luckily they are only
> > needed for bouncing which can be done without a skb too. For RX it adds
> > one copy, but we can live with that because they're only slow devices.
> 
> Usually found on slow hardware that can't cope with extra copies very
> well.

It's essentially only lance, meth, b44 and bcm43xx and lots of s390.

meth is only used on SGI O2s which are not that slow and unlikely
to work in tree anyways.

b44 and bcm43xx run in fast enough new systems to have no trouble
with copies.

s390 won't change.

That only leaves lance. If it runs in a system with <= 16MB 
of memory is fine. I checked with David if he would consider
adding a second destructor to the skb for this case and he 
said no. Which was an answer which was fine for m.e

So the only systems really affected are lance systems with >16MB.
I don't think we can stop Linux evolution for those sorry. They'll
just have to live with it.

-Andi

