Return-Path: <linux-kernel-owner+w=401wt.eu-S1751375AbXCSFOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbXCSFOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXCSFOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:14:43 -0400
Received: from p02c11o142.mxlogic.net ([208.65.144.75]:45292 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXCSFOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:14:42 -0400
Date: Mon, 19 Mar 2007 07:15:20 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070319051520.GR11078@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il> <20070318191238.GA20518@ms2.inr.ac.ru> <20070318203345.GF11078@mellanox.co.il> <20070318210616.GG11078@mellanox.co.il> <20070318212046.GI11078@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318212046.GI11078@mellanox.co.il>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 19 Mar 2007 05:17:45.0900 (UTC) FILETIME=[EDA836C0:01C769E5]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15058.001
X-TM-AS-Result: No--10.023600-4.000000-4
X-Spam: [F=0.1597049943; S=0.159(2007030701)]
X-MAIL-FROM: <mst@dev.mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Michael S. Tsirkin <mst@dev.mellanox.co.il>:
> Subject: Re: dst_ifdown breaks infiniband?
> 
> > Quoting Michael S. Tsirkin <mst@dev.mellanox.co.il>:
> > Subject: Re: dst_ifdown breaks infiniband?
> > 
> > > Quoting Michael S. Tsirkin <mst@dev.mellanox.co.il>:
> > > Subject: Re: dst_ifdown breaks infiniband?
> > > 
> > > Quoting Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
> > > Subject: Re: dst_ifdown breaks infiniband?
> > > > > Can dst->neighbour be changed to point to NULL instead, and the neighbour
> > > > > released?
> > > > 
> > > > It should be cleared and we should be sure it will not be destroyed
> > > > before quiescent state.
> > > > 
> > > > Seems, this is the only correct solution, but to do this we have
> > > > to audit all the places where dst->neighbour is dereferenced for
> > > > RCU safety.
> > > > 
> > > > Actually, it is very good you caught this eventually, the bug was
> > > > so _disgusting_ that it was "forgotten" all the time, waiting for
> > > > someone who will point out that the king is naked. :-)
> > > 
> > > Actually that might not be too bad:
> > > $grep -rIi 'dst->neighbour' net/ | wc -l
> > > 36
> > > 
> > > I'll try to do it.
> > 
> > Here's the list. Looks OK to me. What do you think?
> > 
> 
> So Alexey, how does the following (lightly tested) patch look?
> Is this what you had in mind?
> 
> -----------------------------
> 
> Fix dst_ifdown for infiniband.
> 
> Changing dst->neighbour->dev is unsafe because neigh->parms callbacks
> are set up for specific device.
> We should drop the dst->neighbour reference instead.
> 
> Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

Ugh, looked again and this looks obviously broken.
Note to self - stop writing code at 23:00.

-- 
MST
