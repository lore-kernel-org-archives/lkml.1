Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXCRTxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXCRTxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbXCRTxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:53:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:52349 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbXCRTxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:53:13 -0400
Date: Sun, 18 Mar 2007 21:53:55 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318195355.GB11078@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318191238.GA20518@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
Subject: Re: dst_ifdown breaks infiniband?
> 
> Hello!
> 
> > This is not new code, and should have triggered long time ago,
> > so I am not sure how come we are triggering this only now,
> > but somehow this did not lead to crashes in 2.6.20
> 
> I see. I guess this was plain luck.
> 
> 
> > Why is neighbour->dev changed here?
> 
> It holds reference to device and prevents its destruction.
> If dst is held somewhere, we cannot destroy the device and deadlock
> while unregister.
> 
> We could not invalidate dst->neighbour but it looked safe to invalidate
> neigh->dev after quiescent state. Obviosuly, it is not and it never was safe.
> Was supposed to be repaired asap, but this did not happen. :-(
> 
> > Can dst->neighbour be changed to point to NULL instead, and the neighbour
> > released?
> 
> It should be cleared and we should be sure it will not be destroyed
> before quiescent state.

I'm confused. didn't you say dst_ifdown is called after quiescent state?

> Seems, this is the only correct solution, but to do this we have
> to audit all the places where dst->neighbour is dereferenced for
> RCU safety.
> 
> Actually, it is very good you caught this eventually, the bug was
> so _disgusting_ that it was "forgotten" all the time, waiting for
> someone who will point out that the king is naked. :-)
> 
> Alexey

This does not sound like something that's likely to be accepted in 2.6.21, right?

Any simpler ideas?

-- 
MST
