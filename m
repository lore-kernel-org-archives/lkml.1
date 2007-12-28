Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbXL1FSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbXL1FSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 00:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXL1FSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 00:18:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47420
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbXL1FSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 00:18:10 -0500
Date: Thu, 27 Dec 2007 21:18:08 -0800 (PST)
Message-Id: <20071227.211808.221171928.davem@davemloft.net>
To: guijianfeng@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fib6_del_route has redundant code
From: David Miller <davem@davemloft.net>
In-Reply-To: <477353B6.6000102@cn.fujitsu.com>
References: <477353B6.6000102@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Thu, 27 Dec 2007 15:26:46 +0800

> I think the following code in fib6_del_route in the latest kernel is useless.
> 1125         if (fn->leaf == NULL && fn->fn_flags&RTN_TL_ROOT)
> 1126                 fn->leaf = &ip6_null_entry;
> 
> ip6_null_entry will never be unlinked from fn->leaf now, that is,
> fn->leaf == NULL will never meet.

I think you are right, but if it is true the next block of
code is dead too:

	/* If it was last route, expunge its radix tree node */
	if (fn->leaf == NULL) {
		fn->fn_flags &= ~RTN_RTINFO;
		rt6_stats.fib_route_nodes--;
		fn = fib6_repair_tree(fn);
	}

But I am not completely convinced that all of these lines
of code can be removed :-)
