Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZJ3AnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZJ3AnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZJ3AnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:43:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42581 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZJ3AnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:43:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Oct 2009 09:40:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-mm@kvack.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: Transparent Hugepage support
Message-Id: <20091030094037.9e0118d8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091029103658.GJ9640@random.random>
References: <20091026185130.GC4868@random.random>
	<87ljiwk8el.fsf@basil.nowhere.org>
	<20091027193007.GA6043@random.random>
	<20091028042805.GJ7744@basil.fritz.box>
	<20091029094344.GA1068@elte.hu>
	<20091029103658.GJ9640@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 11:36:58 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> > A small comment regarding the patch itself: i think it could be 
> > simplified further by eliminating CONFIG_TRANSPARENT_HUGEPAGE and by 
> > making it a natural feature of hugepage support. If the code is correct 
> > i cannot see any scenario under which i wouldnt want a hugepage enabled 
> > kernel i'm booting to not have transparent hugepage support as well.
> 
> The two reasons why I added a config option are:
> 
> 1) because it was easy enough, gcc is smart enough to eliminate the
> external calls so I didn't need to add ifdefs with the exception of
> returning 0 from pmd_trans_huge and pmd_trans_frozen. I only had to
> make the exports of huge_memory.c visible unconditionally so it doesn't
> warn, after that I don't need to build and link huge_memory.o.
> 
> 2) to avoid breaking build of archs not implementing pmd_trans_huge
> and that may never be able to take advantage of it
> 
> But we could move CONFIG_TRANSPARENT_HUGEPAGE to an arch define forced
> to Y on x86-64 and N on power.

Ah, please keep CONFIG_TRANSPARENT_HUGEPAGE for a while.
Now, memcg don't handle hugetlbfs because it's special and cannot be freed by
the kernel, only users can free it. But this new transparent-hugepage seems to
be designed as that the kernel can free it for memory reclaiming.
So, I'd like to handle this in memcg transparently.

But it seems I need several changes to support this new rule.
I'm glad if this new huge page depends on !CONFIG_CGROUP_MEM_RES_CTRL for a
while.

Thanks,
-Kame

