Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXCRUSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXCRUSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXCRUSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:18:30 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:43867 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750773AbXCRUS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:18:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=Cd+e1XXsMxIayn47zCsiEM1N/7oIkyXQjvO1MZ6Okg/DZGgoW1nFBrGQ+nVvvlxSiOxtY+Mz2Mdh9+TBWuKccivFv0Da5522Dz7Ncu/1Yvz6jYFpmi2UwRHbB5Pc5AEYl6BeSEwOKnPUy7IPUvFF3rj6SG5OSMxS1OiGj31FYyk=;
Date: Sun, 18 Mar 2007 23:18:26 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318201826.GB27004@ms2.inr.ac.ru>
References: <20070318155532.GG7958@mellanox.co.il> <20070318191238.GA20518@ms2.inr.ac.ru> <20070318195355.GB11078@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318195355.GB11078@mellanox.co.il>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> > It should be cleared and we should be sure it will not be destroyed
> > before quiescent state.
> 
> I'm confused. didn't you say dst_ifdown is called after quiescent state?

Quiescent state should happen after dst->neighbour is invalidated.
And this implies that all the users of dst->neighbour check validity
after dereference and do not use it after quiescent state.


> This does not sound like something that's likely to be accepted in 2.6.21, right?
> 
> Any simpler ideas?

Well, if inifiniband destructor really needs to take that lock... no.
Right now I do not see.

Alexey
