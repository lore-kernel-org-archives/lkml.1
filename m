Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZIMXFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZIMXFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 19:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZIMXFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 19:05:10 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:38667 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbZIMXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 19:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=P7j8EMn4XJUHlJPUbiT+9/297qcK7t4fQCxH2ePQoMWRuuZKZoCx+3BYbp0wsnXN3b
         5RMA+VYj7ecI3P65n6+IDtUNJpJaVOmYEGII77lMp/9aSj3z70jNen005bkMnZKd2E2o
         Halv/D17vhdKJOvEJ3rgNpIgLA91zMFtf0Pis=
Date: Mon, 14 Sep 2009 08:05:01 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm: FOLL_DUMP replace FOLL_ANON
Message-Id: <20090914080501.bfe32d4b.minchan.kim@barrios-desktop>
In-Reply-To: <Pine.LNX.4.64.0909131636540.22865@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
	<Pine.LNX.4.64.0909072233240.15430@sister.anvils>
	<28c262360909090916w12d700b3w7fa8a970f3aba3af@mail.gmail.com>
	<Pine.LNX.4.64.0909131636540.22865@sister.anvils>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hugh.

On Sun, 13 Sep 2009 16:46:12 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Thu, 10 Sep 2009, Minchan Kim wrote:
> > >        /*
> > >         * When core dumping an enormous anonymous area that nobody
> > > -        * has touched so far, we don't want to allocate page tables.
> > > +        * has touched so far, we don't want to allocate unnecessary pages or
> > > +        * page tables.  Return error instead of NULL to skip handle_mm_fault,
> > > +        * then get_dump_page() will return NULL to leave a hole in the dump.
> > > +        * But we can only make this optimization where a hole would surely
> > > +        * be zero-filled if handle_mm_fault() actually did handle it.
> > >         */
> > > -       if (flags & FOLL_ANON) {
> > > -               page = ZERO_PAGE(0);
> > > -               if (flags & FOLL_GET)
> > > -                       get_page(page);
> > > -               BUG_ON(flags & FOLL_WRITE);
> > > -       }
> > > +       if ((flags & FOLL_DUMP) &&
> > > +           (!vma->vm_ops || !vma->vm_ops->fault))
> > 
> > How about adding comment about zero page use?
> 
> What kind of comment did you have in mind?
> We used to use ZERO_PAGE there, but with this patch we're not using it.
> I thought the comment above describes what we're doing well enough.
> 
> I may have kept too quiet about ZERO_PAGEs, knowing that a later patch
> was going to change the story; but I don't see what needs saying here.

I meant following as line. 

> > > +       if ((flags & FOLL_DUMP) &&
> > > +           (!vma->vm_ops || !vma->vm_ops->fault))

Why do we care about anonymous vma and FOLL_DUMP?
Yeah, comment above mentioned page tables. 
But i think someone who first look at can't think it easily. 

If you think the comment is enough, I don't mind it. 

> Hugh


-- 
Kind regards,
Minchan Kim
