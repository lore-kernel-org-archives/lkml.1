Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYBDXLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYBDXLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbYBDXLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:11:20 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:42995 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758302AbYBDXLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:11:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Cj7JKdW/UeYjeBNVsrcZ9ihrp9kl8wEIusRfg4XpSdsrSKZNxp0QnSstHz3oDYBFlxGxYBKX2Cu6CKhITOBJFcf28QapCp0QDY8tgppEYP5Gkm4X9dwMkUnevAVDq3yKQEz5bjStSO73srEPKutKTUUYEVoBQGqUfPy5wMMoWv4=  ;
X-YMail-OSG: 5o9WDo0VM1n22hteVYq8FFQGZtTynYHbwyW8LEs0hqczt295kTXL0_35xd7siTQtHtFR3mV5ZA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] SLUB updates for 2.6.25
Date: Tue, 5 Feb 2008 10:10:49 +1100
User-Agent: KMail/1.9.5
Cc: clameter@sgi.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <Pine.LNX.4.64.0802041206190.3241@schroedinger.engr.sgi.com> <20080204142845.4c734f94.akpm@linux-foundation.org> <20080204143053.9fac9eac.akpm@linux-foundation.org>
In-Reply-To: <20080204143053.9fac9eac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051010.49372.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 09:30, Andrew Morton wrote:
> On Mon, 4 Feb 2008 14:28:45 -0800
>
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > > root (1):
> > >       SLUB: Do not upset lockdep
> >
> > err, what?  I though I was going to merge these:
> >
> > slub-move-count_partial.patch
> > slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
> > slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
> > slub-use-non-atomic-bit-unlock.patch
> > slub-fix-coding-style-violations.patch
> > slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.p
> >atch
> > slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.pat
> >ch
> > slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.pa
> >tch slub-__slab_alloc-exit-path-consolidation.patch
> > slub-provide-unique-end-marker-for-each-slab.patch
> > slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
> > slub-optional-fast-path-using-cmpxchg_local.patch
> > slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
> > slub-restructure-slab-alloc.patch
> > slub-comment-kmem_cache_cpu-structure.patch
> > slub-fix-sysfs-refcounting.patch
> >
> > before you went and changed things under my feet.
>
> erk, sorry, I misremembered.   I was about to merge all the patches we
> weren't going to merge.  oops.

While you're there, can you drop the patch(es?) I commented on
and didn't get an answer to. Like the ones that open code their
own locking primitives and do risky looking things with barriers
to boot...

Also, WRT this one:
slub-use-non-atomic-bit-unlock.patch

This is strange that it is unwanted. Avoiding atomic operations
is a pretty good idea. The fact that it appears to be slower on
some microbenchmark on some architecture IMO either means that
their __clear_bit_unlock or the CPU isn't implemented so well...
