Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZCWNfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZCWNfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZCWNfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:35:01 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:55357 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZCWNfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:35:00 -0400
Date: Mon, 23 Mar 2009 10:35:03 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, riel@redhat.com, mingo@elte.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, ehabkost@redhat.com
Subject: Re: PATCH: Introduce struct vma_link_info
Message-ID: <20090323103503.1a09d6d4@mandriva.com.br>
In-Reply-To: <1237581389.4667.130.camel@laptop>
References: <20090320103438.08e67358@doriath.conectiva>
	<1237581389.4667.130.camel@laptop>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 20 Mar 2009 21:36:29 +0100
Peter Zijlstra <peterz@infradead.org> escreveu:

| On Fri, 2009-03-20 at 10:34 -0300, Luiz Fernando N. Capitulino wrote:
| > Andrew,
| > 
| >   Currently find_vma_prepare() and low-level VMA functions (eg. __vma_link())
| > require callers to provide three parameters to return/pass "link" information
| > (pprev, rb_link and rb_parent):
| > 
| > static struct vm_area_struct *
| > find_vma_prepare(struct mm_struct *mm, unsigned long addr,
| >                 struct vm_area_struct **pprev, struct rb_node ***rb_link,
| >                 struct rb_node ** rb_parent);
| > 
| >  With this patch callers can pass a struct vma_link_info instead:
| > 
| > static struct vm_area_struct *
| > find_vma_prepare(struct mm_struct *mm, unsigned long addr,
| >                 struct vma_link_info *link_info);
| > 
| >  The code gets simpler and it should be better because less variables
| > are pushed into the stack/registers. As shown by the following
| > kernel build test:
| > 
| > kernel			real	user	sys
| > 
| > 2.6.29-rc8-vanilla      1136.64 1033.38 82.88
| > 2.6.29-rc8-linfo        1135.07 1032.44 82.92
| > 
| >  I have also ran hackbench, but I can't understand why its result
| > indicates a regression:
| > 
| > kernel                 Avarage of three runs (25 processes groups)
| > 
| > 2.6.29.rc8-vanilla                2.03
| > 2.6.29.rc8-linfo                  2.12
| > 
| >  Rik has said to me that this could be inside error margin. So, I'm
| > submitting the patch for inclusion.
| > 
| > Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
| 
| I'd rather we look into using the threaded RB-tree to get rid of all
| this prev crap.

 Okay, it makes sense. Also, Eduardo has a point for the hackbench's
regression: the patch is probably dropping some of gcc's optimizations
on the variables that got packed into the struct (although I haven't
checked the assembly yet).

 So, better to forget this one.

 Are there patches for the threaded tree available already?

-- 
Luiz Fernando N. Capitulino
