Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXL1I0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXL1I0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 03:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXL1IZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 03:25:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64373 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXL1IZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 03:25:48 -0500
Message-ID: <4774B30B.3080507@cn.fujitsu.com>
Date: Fri, 28 Dec 2007 16:25:47 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fib6_del_route has redundant code
References: <477353B6.6000102@cn.fujitsu.com>	<20071227.211808.221171928.davem@davemloft.net>	<4774907D.5070806@cn.fujitsu.com> <20071228.001510.239311334.davem@davemloft.net>
In-Reply-To: <20071228.001510.239311334.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Date: Fri, 28 Dec 2007 13:58:21 +0800
> 
>>>> I think the following code in fib6_del_route in the latest kernel is useless.
>>>> 1125         if (fn->leaf == NULL && fn->fn_flags&RTN_TL_ROOT)
>>>> 1126                 fn->leaf = &ip6_null_entry;
>>>>
>>>> ip6_null_entry will never be unlinked from fn->leaf now, that is,
>>>> fn->leaf == NULL will never meet.
>>> I think you are right, but if it is true the next block of
>>> code is dead too:
>>>
>>> 	/* If it was last route, expunge its radix tree node */
>>> 	if (fn->leaf == NULL) {
>>> 		fn->fn_flags &= ~RTN_RTINFO;
>>> 		rt6_stats.fib_route_nodes--;
>>> 		fn = fib6_repair_tree(fn);
>>> 	}
>>>
>> I think this block of code can't be removed, because just the
>> root(default route) fn->leaf always has ip6_null_entry on it. The
>> normal fn->leaf becomes NULL when last route has been deleted, the
>> radix tree should be expunged.
> 
> But you said (still quoted above) that fn->leaf == NULL will not
> occur.
> 
> Do you mean this, only in the case that the RTN_TL_ROOT flag is set?
  yes, I mean this :-)

> 
> I thought you meant always when the function is called, fn->leaf
> cannot ever be NULL.
  its my fault, sorry for the inconvenient.

> 
> 
> 
