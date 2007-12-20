Return-Path: <linux-kernel-owner+w=401wt.eu-S933396AbXLTRNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbXLTRNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761550AbXLTRNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:13:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361AbXLTRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:13:08 -0500
Date: Thu, 20 Dec 2007 09:12:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Dave Hansen <haveblue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in
 free_hot_cold_page
Message-Id: <20071220091215.a87d2588.akpm@linux-foundation.org>
In-Reply-To: <476A972F.6050904@linux.vnet.ibm.com>
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
	<1198084473.15321.48.camel@localhost>
	<Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com>
	<1198158702.6821.8.camel@twins>
	<Pine.LNX.4.64.0712201411510.22773@blonde.wat.veritas.com>
	<1198160410.6821.13.camel@twins>
	<476A972F.6050904@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 21:54:15 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> >> struct page_cgroup *page_get_page_cgroup(struct page *page)
> >> {
> >> 	return (struct page_cgroup *)
> >> 		(page->page_cgroup & ~PAGE_CGROUP_LOCK);
> >> }
> >>
> >> I guess the issue is that often a "get" function has a complementary
> >> "put" function, but this isn't one of them.  Would page_page_cgroup
> >> be a better name, perhaps?  I don't know.
> > 
> > Ah, yes, I mistakenly assumed it was a reference get. In that case I
> > stand corrected and do not have any objections.
> > 
> 
> I was going to say the same thing, page_get_page_cgroup() does not hold
> any references. May be _get_ in the name is confusing.

It is a bit unconventional.  page_cgroup()?
