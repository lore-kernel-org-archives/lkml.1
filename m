Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbYH1Qkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbYH1Qkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYH1Qke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:40:34 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58165 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYH1Qkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:40:33 -0400
Date: Thu, 28 Aug 2008 17:38:20 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       William Irwin <wli@holomorphy.com>, Adam Litke <agl@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
In-Reply-To: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0808281724300.11072@blonde.site>
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, KOSAKI Motohiro wrote:
> Now, hugepage's vma has VM_RESERVED flag because it cannot be swapped.

(Ooh, don't get me started on what VM_RESERVED means or does not mean.)

> 
> and VM_RESERVED vma isn't core dumped because its flag often be used for
> kernel internal vma (e.g. vmalloc, sound related).
> 
> So, hugepage is never dumped and it indicate hugepages's program can't
> be debugged easily.
> 
> In these days, demand on making use of hugepage is increasing.
> IMO, native support for coredump of hugepage is useful.
> 
> 
> I think VM_RESERVED default dumping bahavior is good,
> then I'd like to add coredump_filter mask.
> 
> This patch doesn't change dafault behavior.

This seems very reasonable to me
(though I've little use for coredumps or hugepages myself).

One caution though: how well does it behave when coredumping a large
area of hugepages which have not actually been instantiated prior to
the coredump?  We have that funny FOLL_ANON ZERO_PAGE code in
follow_page() to avoid wasting memory on large uninstantiated anon
areas, but hugepages won't go that way.  If the dump hangs waiting for
memory to be freed, or OOMkills other processes, that wouldn't be good;
whereas if hugepage reservations (I've not followed what happens with
them) or whatever just make it skip when no more, that should be okay.

Hugh
