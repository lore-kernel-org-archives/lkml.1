Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYFSIUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYFSIUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 04:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbYFSITn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 04:19:43 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:24376 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756697AbYFSITk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 04:19:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UmQdDzqp7bMRE0i5sv0CEGV5bY4or2wCcJe0ggOlk8CR0HwFgMAEQOzb80VFcnkgMRqAkwA1rNRMzplMsy12wixSiwvZnx0Y2KrYDwpVsN0T71FugtITxp7kgM+v7H5vmoJol5hencWhXmDn9cyqfxmTfFdb9uyAfOPaBuNfz80=  ;
X-YMail-OSG: 1s7hLi4VM1nJlo.SCS68tM1143VxbGNwfEMG9YpZ49.I1wbSEWpvyHTVOkyybr7kcKPviyyTD6gZY0VK.yHqQK_hc8EUa7vypO56p27PLJ3YUPCoZhXrE60zTzTFwDbr10g-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Date: Thu, 19 Jun 2008 18:19:31 +1000
User-Agent: KMail/1.9.5
Cc: Ryan Hope <rmh3093@gmail.com>, linux-mm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com> <1213863122.16944.257.camel@twins>
In-Reply-To: <1213863122.16944.257.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806191819.31968.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2008 18:12, Peter Zijlstra wrote:
> On Wed, 2008-06-18 at 17:15 -0400, Ryan Hope wrote:
> > I applied the following patches from 2.6-26-rc5-mm3 to 2.6.26-rc6 and
> > they caused a hardlock under heavy IO:
>
> What kind of machine, how much memory, how many spindles, what
> filesystem and what is heavy load?
>
> Furthermore, try the NMI watchdog with serial/net-console to capture its
> output.


Good suggestions. A trace would be really helpful.

As Arjan suggested, debug options especially CONFIG_DEBUG_VM would be
a good idea to turn on if you haven't already.

BTW. what was the reason for applying those patches? Did you hit the
problem with -mm also, and hope to narrow it down?


> > x86-implement-pte_special.patch
> > mm-introduce-get_user_pages_fast.patch
> > mm-introduce-get_user_pages_fast-fix.patch
> > mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
> > x86-lockless-get_user_pages_fast.patch
> > x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
> > x86-lockless-get_user_pages_fast-fix.patch
> > x86-lockless-get_user_pages_fast-fix-2.patch
> > x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
> > x86-lockless-get_user_pages_fast-fix-warning.patch
> > dio-use-get_user_pages_fast.patch
> > splice-use-get_user_pages_fast.patch
> > x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
> > #
> > mm-readahead-scan-lockless.patch
> > radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
> > #mm-speculative-page-references.patch: clameter saw bustage
> > mm-speculative-page-references.patch
> > mm-speculative-page-references-fix.patch
> > mm-speculative-page-references-fix-fix.patch
> > mm-speculative-page-references-hugh-fix3.patch
> > mm-lockless-pagecache.patch
> > mm-spinlock-tree_lock.patch
> > powerpc-implement-pte_special.patch
> >
> > I am on an x86_64. I dont know what other info you need...

Can you isolate it to one of the two groups of patches? I suspect it
might be the latter so you might try that first -- this version of
speculative page references is very nice in theory but it is a little
more complex to implement the slowpaths so it could be an error there.
