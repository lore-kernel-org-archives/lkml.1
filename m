Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZBJNlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZBJNlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZBJNll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:41:41 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:52081 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZBJNlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wBl+yGQywZj022eO8mxUi119rwQA8rtzAN1EbleOdwGEq4X+pBrqSe8/sZ58phEK6w
         hFrye4viyjxXQ5Q7L+7wHI+ZCEIkKWr1iT93gkkdCxMjDzTTptd0s1U0yk/RYRseLeD2
         yKlOpohOMaNgma2umLA0SOKBHVv1aJ8iKZGOo=
MIME-Version: 1.0
In-Reply-To: <16182.1234199195@redhat.com>
References: <1232919337-21434-1-git-send-email-righi.andrea@gmail.com>
	 <16182.1234199195@redhat.com>
Date: Tue, 10 Feb 2009 14:41:37 +0100
Message-ID: <a2776ec50902100541p1503adaay52d221411d92c842@mail.gmail.com>
Subject: Re: [PATCH -mmotm] mm: unify some pmd_*() functions
From: Andrea Righi <righi.andrea@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 6:06 PM, David Howells <dhowells@redhat.com> wrote:
> Andrea Righi <righi.andrea@gmail.com> wrote:
>
>> Unify all the identical implementations of pmd_free(), __pmd_free_tlb(),
>> pmd_alloc_one(), pmd_addr_end() in include/asm-generic/pgtable-nopmd.h
>
> NAK for FRV on two fronts:

This patch generates too many followup fixes and it's better to simply drop it
for now.

I think we need to use a different approach and, more important, we need to
clean a lot of .h files before to avoid the include hell problems.

-Andrea

>
>  (1) The definition of pud_t in pgtable-nopud.h:
>
>        typedef struct { pgd_t pgd; } pud_t;
>
>     is not consistent with the one in FRV's page.h:
>
>        typedef struct { unsigned long  ste[64];} pmd_t;
>        typedef struct { pmd_t          pue[1]; } pud_t;
>        typedef struct { pud_t          pge[1]; } pgd_t;
>
>     The upper intermediate page table is contained within the page directory
>     entry, not the other way around.  Having a pgd_t inside a pud_t is
>     upside-down, illogical and makes things harder to follow IMNSHO.
>
>  (2) It produces the following errors:
>
> mm/memory.c: In function 'free_pmd_range':
> mm/memory.c:176: error: implicit declaration of function '__pmd_free_tlb'
>  CC      fs/seq_file.o
> mm/memory.c: In function '__pmd_alloc':
> mm/memory.c:2896: error: implicit declaration of function 'pmd_alloc_one_bug'
> mm/memory.c:2896: warning: initialization makes pointer from integer without a cast
> mm/memory.c:2905: error: implicit declaration of function 'pmd_free'
>
> David
