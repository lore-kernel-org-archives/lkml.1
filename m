Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbYHASJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbYHASJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHASI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:08:59 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:23090 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYHASI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:08:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nSISwktFMWa2w8emnBQg69UxafWr13Y3U9P/HOpDoZt8L7z1b4lnCzqDqlKwlDEwsi
         UqFpg75xxvveM31fQI/qEgsMbpYaWP4JOYvbRWofcNea5A/qaoELfLU2ZWZvDLlR2Y57
         SPhAmFMSB7n1t6LVNthMZXvDIr9gpo/ihFmxc=
Message-ID: <48f7fe350808011108w2633451bv7e1507b6aa38f9dd@mail.gmail.com>
Date: Fri, 1 Aug 2008 14:08:57 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH][RESEND] mm: fix uninitialized variables for find_vma_prepare callers
Cc: "Benny Halevy" <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0808011749040.15379@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808010813u4e71c3e7h4d25127533a12726@mail.gmail.com>
	 <Pine.LNX.4.64.0808011749040.15379@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah original author should get credit, i just didnt go back an look,
thanks for doing that.

On Fri, Aug 1, 2008 at 1:31 PM, Hugh Dickins <hugh@veritas.com> wrote:
> On Fri, 1 Aug 2008, Ryan Hope wrote:
>> This was submitted for 2.6.26-rc8-mm1 but it must have gotten overlooked:
>
> True, thanks, I guess that's my fault: it got stalled by me, because I
> found it unsatisfying to fix the uninitialization from a compiler point
> of view, whilst leaving it in an undefined state from a usability point
> of view.  But since nothing does use those fields in this case, and my
> amateurish treephobic experiments didn't find a quick solution to that,
> I guess this is an improvement which should go in.
>
> But please, let's credit Benny who posted it, and give his explanation
> of what the patch is for, with some additional comment from me.  Which
> leaves you out - "Reminded-by: Ryan Hope <rmh3093@gmail.com>"?
>
> From: Benny Halevy <bhalevy@panasas.com>
>
> gcc 4.3.0 correctly emits the following warnings.
> When a vma covering addr is found, find_vma_prepare indeed returns without
> setting pprev, rb_link, and rb_parent.
>
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function 'insert_vm_struct':
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2085: warning: 'rb_parent' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2085: warning: 'rb_link' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2084: warning: 'prev' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function 'copy_vma':
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2124: warning: 'rb_parent' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2124: warning: 'rb_link' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2123: warning: 'prev' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function 'do_brk':
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1951: warning: 'rb_parent' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1951: warning: 'rb_link' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1949: warning: 'prev' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function 'mmap_region':
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1092: warning: 'rb_parent' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1092: warning: 'rb_link' may be used uninitialized in this function
> /usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1089: warning: 'prev' may be used uninitialized in this function
>
> Hugh adds: in fact, none of find_vma_prepare's callers use those values
> when a vma is found to be already covering addr, it's either an error
> or an occasion to munmap and repeat.  Okay, let's quieten the compiler
> (but I would prefer it if pprev, rb_link and rb_parent were meaningful
> in that case, rather than whatever's in them from descending the tree).
>
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
>
>  mm/mmap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> --- 2.6.27-rc1/mm/mmap.c
> +++ linux/mm/mmap.c
> @@ -370,7 +370,7 @@ find_vma_prepare(struct mm_struct *mm, unsigned long addr,
>                if (vma_tmp->vm_end > addr) {
>                        vma = vma_tmp;
>                        if (vma_tmp->vm_start <= addr)
> -                               return vma;
> +                               break;
>                        __rb_link = &__rb_parent->rb_left;
>                } else {
>                        rb_prev = __rb_parent;
