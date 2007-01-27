Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbXA0JIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbXA0JIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 04:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXA0JIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 04:08:51 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:12569 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbXA0JIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 04:08:49 -0500
X-AuditID: d80ac287-9eee9bb000007e48-6d-45bb18a9c651 
Date: Sat, 27 Jan 2007 09:08:58 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ken Chen <kenchen@google.com>
cc: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@osdl.org>,
       William Irwin <wli@holomorphy.com>,
       David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't allow the stack to grow into hugetlb reserved
 regions
In-Reply-To: <b040c32a0701261448k122f5cc7q5368b3b16ee1dc1f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701270904360.15686@blonde.wat.veritas.com>
References: <20070125214052.22841.33449.stgit@localhost.localdomain> 
 <Pine.LNX.4.64.0701262025590.22196@blonde.wat.veritas.com>
 <b040c32a0701261448k122f5cc7q5368b3b16ee1dc1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 27 Jan 2007 09:08:48.0199 (UTC) FILETIME=[C129ED70:01C741F2]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Ken Chen wrote:
> On 1/26/07, Hugh Dickins <hugh@veritas.com> wrote:
> > Less trivial (and I wonder whether you've come to this from an ia64
> > or a powerpc direction): I notice that ia64 has more stringent REGION
> > checks in its ia64_do_page_fault, before calling expand_stack or
> > expand_upwards.  So on that path, the usual path, I think your
> > new check in acct_stack_growth is unnecessary on ia64;
> 
> I think you are correct. This appears to affect powerpc only. On ia64,
> hugetlb lives in a completely different region and they can never step
> into normal stack address space. And for x86, there isn't a thing called
> "reserved address space" for hugetlb mapping.

Thanks, that's reassuring for the hugetlb case, and therefore Adam's
patch should not be delayed.  But it does leave open the question I
was raising in the text you've snipped: if ia64 needs those stringent
REGION checks in its ia64_do_page_fault path, don't we need to add
them some(messy)how in the get_user_pages find_extend_vma path?

Hugh
