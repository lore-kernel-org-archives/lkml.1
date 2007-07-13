Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbXGMMm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbXGMMm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXGMMmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:42:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44777 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755253AbXGMMms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:42:48 -0400
Date: Fri, 13 Jul 2007 05:42:45 -0700
From: Paul Jackson <pj@sgi.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: akpm@linux-foundation.org, joe.jin@oracle.com, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070713054245.b1319207.pj@sgi.com>
In-Reply-To: <20070713121846.GA25236@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<20070713080336.GB21833@joejin-pc.cn.oracle.com>
	<20070713011543.22797645.akpm@linux-foundation.org>
	<20070713121846.GA25236@joejin-pc.cn.oracle.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe wrote:
> --- linux-2.6.22/mm/hugetlb.c.orig	2007-07-12 15:02:19.000000000 +0800
> +++ linux-2.6.22/mm/hugetlb.c	2007-07-13 17:33:45.000000000 +0800
> @@ -101,13 +101,20 @@ static void free_huge_page(struct page *
>  
>  static int alloc_fresh_huge_page(void)
>  {
>	...

Patch looks ok to me, except for ...

> Ha.., the patch against 2.6.22, at your patch have use htlb_alloc_mask, but I
> cannot found it at 2.6.22 kernel tree, I think you must use difference kernel
> tree :)

Yes, as a matter of fact, he does have a different kernel tree, found at:

    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/

This is the infamous *-mm tree, which is currently at the following
version 2.6.22-rc6-mm1, and also available as a quilt patch set,
beneath:

    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/

My guess is Andrew will prefer a patch against this *-mm kernel, though
sometimes he is a good chap and fixes up minor differences, such as
this involving htlb_alloc_mask replacing GFP_HIGHUSER.  If you had the
chance to verify your testing of this change against this
2.6.22-rc6-mm1, that would be worth doing.  Probably the change to
htlb_alloc_mask from GFP_HIGHUSER won't be any problem, but I suppose
that there's a small chance that some other patch in *-mm will interact
poorly with your proposed change.

Thanks for getting on this so quickly.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
