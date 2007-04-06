Return-Path: <linux-kernel-owner+w=401wt.eu-S1767715AbXDFPIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767715AbXDFPIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767716AbXDFPIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:08:32 -0400
Received: from stinky.trash.net ([213.144.137.162]:41518 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767715AbXDFPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:08:31 -0400
Message-ID: <4616626C.9020100@trash.net>
Date: Fri, 06 Apr 2007 17:08:28 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Vasily Averin <vvs@sw.ru>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 2.6.21-rc6] [netfilter] early_drop imrovement
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com> <4616203A.80203@sw.ru>
In-Reply-To: <4616203A.80203@sw.ru>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Averin wrote:
> No, I've not investigated this scenario. It looks like you are right and my
> patch can leads to a long delays.
> 
> In my experiments I've decreased ip_conntrack_max lower than number of hash
> buckets and got the "table full, dropping packet" errors in logs. I've looked on
> the conntrack list and found a huge number of conntracks that can be freed.
> However my hash bucket was empty and therefore I even did not have any chances
> to free something. That's why I would like to check the other hash buckets too.
> 
> Ok, let's limit the number of conntracks that can be checked inside
> early_drop(). What do you prefer: some round number (for example 100) or
> fraction of ip_conntrack_max (for example 1%)?


A (small) fraction sounds better. We could even consider keeping track
of the number of conntracks that can be evicted (not assured), so in a
DOS situation we could save unnecessary table scans. Not sure if its
worth the effort though.

Anyway, please base your patch on the net-2.6.22 tree, which doesn't
include ip_conntrack anymore.

