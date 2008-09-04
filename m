Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYIDINZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYIDINZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbYIDINB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:13:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51336 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbYIDIM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:12:58 -0400
Date: Thu, 04 Sep 2008 17:11:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for allocation by the reclaimer
Cc: kosaki.motohiro@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <48BEFAF9.3030006@linux-foundation.org>
References: <1220475206-23684-1-git-send-email-apw@shadowen.org> <48BEFAF9.3030006@linux-foundation.org>
Message-Id: <20080904170016.B265.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cristoph

> How does page allocator fastpath behavior fare with this pathch?

Don't worry it because

1. shrink_zone() isn't fastpath because any reclaim isn't fastpath.
2. buddy combining on __free_one_page() isn't fastpath because
   any buddy combining isn't fastpath. (*)

(*)
all modern allocator have delayed buddy combining mecanism
because buddy combining increase cache miss.
(please imazine address X+1 is freed when address X is cold.
 combining cause next alloc get address X, then caller see cold page)

at least, allocator's fastpath should avoid its combining IMHO.

Unfortunately the linux buddy's one is limited because
zone->pcp only cache order-0 page.

Then, higher order pages's free always use slow path now.
but it isn't his patch failure.



