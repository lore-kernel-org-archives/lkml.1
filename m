Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYJBQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYJBQbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYJBQa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:30:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935AbYJBQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:30:58 -0400
Message-ID: <48E4F6EC.7010500@linux-foundation.org>
Date: Thu, 02 Oct 2008 11:29:32 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for	allocation
 by the reclaimer
References: <1222864261-22570-1-git-send-email-apw@shadowen.org> <1222864261-22570-5-git-send-email-apw@shadowen.org> <48E390DA.9060109@linux-foundation.org> <20081002143508.GE11089@brain>
In-Reply-To: <20081002143508.GE11089@brain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:

>> At the beginning of reclaim just flush all pcp pages and then do not allow pcp
>> refills again until reclaim is finished?
> 
> Not entirely, some pages could get trapped there for sure.  But it is
> parallel allocations we are trying to guard against.  Plus we already flush
> the pcp during reclaim for higher orders.

So we just would need to forbid refilling the pcp.

Parallel allocations are less a problem if the freed order 0 pages get merged
immediately into the order 1 freelist. Of course that will only work 50% of
the time but it will have a similar effect to this patch.

