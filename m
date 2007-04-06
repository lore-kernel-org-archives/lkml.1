Return-Path: <linux-kernel-owner+w=401wt.eu-S1767550AbXDFIYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767550AbXDFIYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 04:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767552AbXDFIYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 04:24:37 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:46271 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767550AbXDFIYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 04:24:36 -0400
Date: Fri, 6 Apr 2007 10:24:33 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Vasily Averin <vvs@sw.ru>
Cc: "David S. Miller" <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 2.6.21-rc6] [netfilter] early_drop imrovement
Message-Id: <20070406102433.d3a670a5.dada1@cosmosbay.com>
In-Reply-To: <4615FE1D.80206@sw.ru>
References: <4615FE1D.80206@sw.ru>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 12:00:29 +0400
Vasily Averin <vvs@sw.ru> wrote:

> When the number of conntracks is reached ip_conntrack_max limit, early_drop() is
> called and tries to free one of already used conntracks in one of the hash
> buckets. If it does not find any conntracks that may be freed, it
> leads to transmission errors.
> However it is not fair because of current hash bucket may be empty but the
> neighbour ones can have the number of conntracks that can be freed. With the
> following patch early_drop() will search conntracks in all hash buckets.

Have you tested your patch in a DOS situation ?
Some machines have a huge ip_conntrack_max.
A single scan of the whole table might take 1000 ms or even more.


