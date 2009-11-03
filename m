Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZKCPoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZKCPoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZKCPoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:44:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZKCPoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:44:54 -0500
Date: Tue, 3 Nov 2009 11:55:43 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-mm@kvack.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: Transparent Hugepage support
Message-ID: <20091103105543.GH11981@random.random>
References: <20091026185130.GC4868@random.random>
 <87ljiwk8el.fsf@basil.nowhere.org>
 <20091027193007.GA6043@random.random>
 <20091028042805.GJ7744@basil.fritz.box>
 <20091029094344.GA1068@elte.hu>
 <20091029103658.GJ9640@random.random>
 <20091030094037.9e0118d8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030094037.9e0118d8.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 09:40:37AM +0900, KAMEZAWA Hiroyuki wrote:
> Ah, please keep CONFIG_TRANSPARENT_HUGEPAGE for a while.
> Now, memcg don't handle hugetlbfs because it's special and cannot be freed by
> the kernel, only users can free it. But this new transparent-hugepage seems to
> be designed as that the kernel can free it for memory reclaiming.
> So, I'd like to handle this in memcg transparently.
> 
> But it seems I need several changes to support this new rule.
> I'm glad if this new huge page depends on !CONFIG_CGROUP_MEM_RES_CTRL for a
> while.

Yeah the accounting (not just memcg) should be checked.. I didn't pay
too much attention to stats at this point.

But we want to fix it fast instead of making the two options mutually
exclusive.. Where are the pages de-accounted when they are freed?
Accounting seems to require just two one liners
calling mem_cgroup_newpage_charge.
