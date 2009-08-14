Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZHNNUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZHNNUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbZHNNU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:20:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45533 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbZHNNU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:20:27 -0400
Message-ID: <4A856467.6050102@redhat.com>
Date: Fri, 14 Aug 2009 09:19:35 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Avi Kivity <avi@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com> <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com> <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com> <4A846581.2020304@redhat.com> <20090813211626.GA28274@cmpxchg.org> <4A850F4A.9020507@redhat.com> <20090814091055.GA29338@cmpxchg.org> <20090814095106.GA3345@localhost>
In-Reply-To: <20090814095106.GA3345@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> On Fri, Aug 14, 2009 at 05:10:55PM +0800, Johannes Weiner wrote:

>> So even with the active list being a FIFO, we keep usage information
>> gathered from the inactive list.  If we deactivate pages in arbitrary
>> list intervals, we throw this away.
> 
> We do have the danger of FIFO, if inactive list is small enough, so
> that (unconditionally) deactivated pages quickly get reclaimed and
> their life window in inactive list is too small to be useful.

This one of the reasons why we unconditionally deactivate
the active anon pages, and do background scanning of the
active anon list when reclaiming page cache pages.

We want to always move some pages to the inactive anon
list, so it does not get too small.

-- 
All rights reversed.
