Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXLRA5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXLRA5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXLRA5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:57:47 -0500
Received: from postel.suug.ch ([194.88.212.233]:38963 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbXLRA5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:57:46 -0500
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 19:57:46 EST
Date: Tue, 18 Dec 2007 01:33:12 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Patrick McHardy <kaber@trash.net>
Cc: Chris Friesen <cfriesen@nortel.com>, yoshfuji@linux-ipv6.org,
       dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: "ip neigh show" not showing arp cache entries?
Message-ID: <20071218003312.GR11220@postel.suug.ch>
References: <4760279E.1080203@nortel.com> <47602DD0.8070402@cosmosbay.com> <47605934.2060604@nortel.com> <20071213.070641.20411400.yoshfuji@linux-ipv6.org> <476696A5.1010101@nortel.com> <4766B99D.8060408@trash.net> <4766D261.1020005@nortel.com> <47670B88.4010906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47670B88.4010906@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Patrick McHardy <kaber@trash.net> 2007-12-18 00:51
> Chris Friesen wrote:
> >Patrick McHardy wrote:
> >
> >> From a kernel perspective there are only complete dumps, the
> >>filtering is done by iproute. So the fact that it shows them
> >>when querying specifically implies there is a bug in the
> >>iproute neighbour filter. Does it work if you omit "all"
> >>from the ip neigh show command?
> >
> >Omitting "all" gives identical results.  It is still missing entries 
> >when compared with the output of "arp".
> 
> 
> In that case the easiest way to debug this is probably if you
> add some debugging to ip/ipneigh.c:print_neigh() since I'm
> unable to reproduce this problem. A printf for all the filter
> conditions (=> return 0) at the top should do.

Alternatively, you can download libnl and run

	NLCB=debug src/nl-neigh-dump brief

and check if the netlink message is sent by the kenrel for the
neighbour in question. 
