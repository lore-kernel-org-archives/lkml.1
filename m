Return-Path: <linux-kernel-owner+w=401wt.eu-S1751900AbYJRKtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbYJRKtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 06:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYJRKtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 06:49:16 -0400
Received: from ozlabs.org ([203.10.76.45]:47388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYJRKtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 06:49:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18681.48931.493345.839251@cargo.ozlabs.ibm.com>
Date: Sat, 18 Oct 2008 21:49:07 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch] mm: fix anon_vma races
In-Reply-To: <20081018054916.GB26472@wotan.suse.de>
References: <20081016041033.GB10371@wotan.suse.de>
	<Pine.LNX.4.64.0810172300280.30871@blonde.site>
	<alpine.LFD.2.00.0810171549310.3438@nehalem.linux-foundation.org>
	<Pine.LNX.4.64.0810180045370.8995@blonde.site>
	<20081018015323.GA11149@wotan.suse.de>
	<18681.20241.347889.843669@cargo.ozlabs.ibm.com>
	<20081018054916.GB26472@wotan.suse.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:

> > Not sure what you mean by causal consistency, but I assume it's the
> 
> I think it can be called transitive. Basically (assumememory starts off zeroed)
> CPU0
> x := 1
> 
> CPU1
> if (x == 1) {
>   fence
>   y := 1
> }
> 
> CPU2
> if (y == 1) {
>   fence
>   assert(x == 1)
> }

That's essentially the same as example 1 on page 415, so yes we are
talking about the same thing.

Paul.
