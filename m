Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYJAPCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYJAPCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYJAPCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:02:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400AbYJAPCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:02:36 -0400
Message-ID: <48E390DA.9060109@linux-foundation.org>
Date: Wed, 01 Oct 2008 10:01:46 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for allocation
 by the reclaimer
References: <1222864261-22570-1-git-send-email-apw@shadowen.org> <1222864261-22570-5-git-send-email-apw@shadowen.org>
In-Reply-To: <1222864261-22570-5-git-send-email-apw@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> When a process enters direct reclaim it will expend effort identifying
> and releasing pages in the hope of obtaining a page.  However as these
> pages are released asynchronously there is every possibility that the
> pages will have been consumed by other allocators before the reclaimer
> gets a look in.  This is particularly problematic where the reclaimer is
> attempting to allocate a higher order page.  It is highly likely that
> a parallel allocation will consume lower order constituent pages as we
> release them preventing them coelescing into the higher order page the
> reclaimer desires.

The reclaim problem is due to the pcp queueing right? Could we disable pcp
queueing during reclaim? pcp processing is not necessarily a gain, so
temporarily disabling it should not be a problem.

At the beginning of reclaim just flush all pcp pages and then do not allow pcp
refills again until reclaim is finished?
