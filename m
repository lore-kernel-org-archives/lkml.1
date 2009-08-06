Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZHFNNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZHFNNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZHFNN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:13:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49102 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbZHFNN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:13:28 -0400
Message-ID: <4A7AD6EB.9090208@redhat.com>
Date: Thu, 06 Aug 2009 09:13:15 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com>
In-Reply-To: <4A7AC201.4010202@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 08/06/2009 01:59 PM, Wu Fengguang wrote:

>> As a refinement, the static variable 'recent_all_referenced' could be
>> moved to struct zone or made a per-cpu variable.
> 
> Definitely this should be made part of the zone structure, consider the 
> original report where the problem occurs in a 128MB zone (where we can 
> expect many pages to have their referenced bit set).

The problem did not occur in a 128MB zone, but in a 128MB cgroup.

Putting it in the zone means that the cgroup, which may have
different behaviour from the rest of the zone, due to excessive
memory pressure inside the cgroup, does not get the right
statistics.

-- 
All rights reversed.
