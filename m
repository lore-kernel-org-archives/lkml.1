Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbZBKBH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbZBKBH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZBKBHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:07:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50594
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbZBKBHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:07:47 -0500
Date: Tue, 10 Feb 2009 17:07:40 -0800 (PST)
Message-Id: <20090210.170740.208470781.davem@davemloft.net>
To: swise@opengridcomputing.com
Cc: rdreier@cisco.com, randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
From: David Miller <davem@davemloft.net>
In-Reply-To: <499223F8.1010204@opengridcomputing.com>
References: <20090210184448.22891.31130.stgit@dell3.ogc.int>
	<adamyctajv8.fsf@cisco.com>
	<499223F8.1010204@opengridcomputing.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>
Date: Tue, 10 Feb 2009 19:03:52 -0600

> Roland Dreier wrote:
> > I'll roll this into the offending patch (that is in -next).
> >
> > But:
> >
> >  > -		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
> >  > -				(1UL << (12 + page_size[i])));
> >  > +		wqe->recv.sgl[i].to = cpu_to_be64(((u64) wr->sg_list[i].addr) &
> >  > +				((1UL << (12 + page_size[i]))-1));
> >
> > Is this required?  Strength reduction optimization should do this
> > automatically (and the code has been there for quite a while, so
> > obviously it isn't causing problems)
> >
> >  - R.
> >   
> Ok.

GCC won't optimize that modulus the way you expect, try for yourself
and look at the assembler if you don't believe me. :-)

