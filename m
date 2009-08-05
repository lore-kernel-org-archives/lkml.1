Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZHER0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZHER0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZHER0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:26:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZHER0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:26:20 -0400
Message-ID: <4A79C076.2090000@redhat.com>
Date: Wed, 05 Aug 2009 13:25:10 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
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
References: <20090805024058.GA8886@localhost> <4A793B92.9040204@redhat.com> <4A7993F4.9020008@redhat.com> <20090805163143.GF23385@random.random>
In-Reply-To: <20090805163143.GF23385@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Wed, Aug 05, 2009 at 10:15:16AM -0400, Rik van Riel wrote:
>> Not having a hardware accessed bit would explain why
>> the VM is not reactivating the pages that were accessed
>> while on the inactive list.
> 
> Problem is, even with young bit functional the VM isn't reactivating
> those pages anyway because of that broken check... 

That check is only done where active pages are moved to the
inactive list!   Inactive pages that were referenced always
get moved to the active list (except for unmapped file pages).

> I think it'll still better than current situation, as young bit is
> always set for ptes. Otherwise EPT pages are too penalized, we need
> them to stay one round more in active list like everything else.

NOTHING ELSE stays on the active anon list for two rounds,
for very good reasons.  Please read up on what has changed
in the VM since 2.6.27.

-- 
All rights reversed.
