Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbXL1IPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbXL1IPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 03:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXL1IPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 03:15:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57206
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbXL1IPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 03:15:11 -0500
Date: Fri, 28 Dec 2007 00:15:10 -0800 (PST)
Message-Id: <20071228.001510.239311334.davem@davemloft.net>
To: guijianfeng@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fib6_del_route has redundant code
From: David Miller <davem@davemloft.net>
In-Reply-To: <4774907D.5070806@cn.fujitsu.com>
References: <477353B6.6000102@cn.fujitsu.com>
	<20071227.211808.221171928.davem@davemloft.net>
	<4774907D.5070806@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Fri, 28 Dec 2007 13:58:21 +0800

> >> I think the following code in fib6_del_route in the latest kernel is useless.
> >> 1125         if (fn->leaf == NULL && fn->fn_flags&RTN_TL_ROOT)
> >> 1126                 fn->leaf = &ip6_null_entry;
> >>
> >> ip6_null_entry will never be unlinked from fn->leaf now, that is,
> >> fn->leaf == NULL will never meet.
> > 
> > I think you are right, but if it is true the next block of
> > code is dead too:
> > 
> > 	/* If it was last route, expunge its radix tree node */
> > 	if (fn->leaf == NULL) {
> > 		fn->fn_flags &= ~RTN_RTINFO;
> > 		rt6_stats.fib_route_nodes--;
> > 		fn = fib6_repair_tree(fn);
> > 	}
> > 
> 
> I think this block of code can't be removed, because just the
> root(default route) fn->leaf always has ip6_null_entry on it. The
> normal fn->leaf becomes NULL when last route has been deleted, the
> radix tree should be expunged.

But you said (still quoted above) that fn->leaf == NULL will not
occur.

Do you mean this, only in the case that the RTN_TL_ROOT flag is set?

I thought you meant always when the function is called, fn->leaf
cannot ever be NULL.

