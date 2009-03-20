Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZCTUhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZCTUhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZCTUhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:37:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:57478 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbZCTUhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:37:06 -0400
Subject: Re: PATCH: Introduce struct vma_link_info
From: Peter Zijlstra <peterz@infradead.org>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: akpm@linux-foundation.org, riel@redhat.com, mingo@elte.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090320103438.08e67358@doriath.conectiva>
References: <20090320103438.08e67358@doriath.conectiva>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 21:36:29 +0100
Message-Id: <1237581389.4667.130.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 10:34 -0300, Luiz Fernando N. Capitulino wrote:
> Andrew,
> 
>   Currently find_vma_prepare() and low-level VMA functions (eg. __vma_link())
> require callers to provide three parameters to return/pass "link" information
> (pprev, rb_link and rb_parent):
> 
> static struct vm_area_struct *
> find_vma_prepare(struct mm_struct *mm, unsigned long addr,
>                 struct vm_area_struct **pprev, struct rb_node ***rb_link,
>                 struct rb_node ** rb_parent);
> 
>  With this patch callers can pass a struct vma_link_info instead:
> 
> static struct vm_area_struct *
> find_vma_prepare(struct mm_struct *mm, unsigned long addr,
>                 struct vma_link_info *link_info);
> 
>  The code gets simpler and it should be better because less variables
> are pushed into the stack/registers. As shown by the following
> kernel build test:
> 
> kernel			real	user	sys
> 
> 2.6.29-rc8-vanilla      1136.64 1033.38 82.88
> 2.6.29-rc8-linfo        1135.07 1032.44 82.92
> 
>  I have also ran hackbench, but I can't understand why its result
> indicates a regression:
> 
> kernel                 Avarage of three runs (25 processes groups)
> 
> 2.6.29.rc8-vanilla                2.03
> 2.6.29.rc8-linfo                  2.12
> 
>  Rik has said to me that this could be inside error margin. So, I'm
> submitting the patch for inclusion.
> 
> Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

I'd rather we look into using the threaded RB-tree to get rid of all
this prev crap.

