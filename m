Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZFVXPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZFVXPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZFVXPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:15:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38031
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZFVXO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:14:59 -0400
Date: Mon, 22 Jun 2009 16:15:02 -0700 (PDT)
Message-Id: <20090622.161502.74508182.davem@davemloft.net>
To: mel@csn.ul.ie
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, htd@fancy-poultry.org
Subject: Re: [PATCH 3/3] net-dccp: Suppress warning about large allocations
 from DCCP
From: David Miller <davem@davemloft.net>
In-Reply-To: <1245685414-8979-4-git-send-email-mel@csn.ul.ie>
References: <1245685414-8979-1-git-send-email-mel@csn.ul.ie>
	<1245685414-8979-4-git-send-email-mel@csn.ul.ie>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mel@csn.ul.ie>
Date: Mon, 22 Jun 2009 16:43:34 +0100

> The DCCP protocol tries to allocate some large hash tables during
> initialisation using the largest size possible.  This can be larger than
> what the page allocator can provide so it prints a warning. However, the
> caller is able to handle the situation so this patch suppresses the warning.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

It's probably much more appropriate to make this stuff use
alloc_large_system_hash(), like TCP does (see net/ipv4/tcp.c
tcp_init()).

All of this complicated DCCP hash table size computation code will
simply disappear.  And it'll fix the warning too :-)

