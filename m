Return-Path: <linux-kernel-owner+w=401wt.eu-S932322AbYBHO6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbYBHO6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 09:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbYBHO6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 09:58:09 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:61939 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbYBHO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 09:58:08 -0500
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [git pull] more SLUB updates for 2.6.25
References: <Pine.LNX.4.64.0802071755580.7473@schroedinger.engr.sgi.com>
	<200802081812.22513.nickpiggin@yahoo.com.au>
	<47AC04CD.9090407@cosmosbay.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Feb 2008 15:58:05 +0100
In-Reply-To: <47AC04CD.9090407@cosmosbay.com>
Message-ID: <87ve4z1on6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Feb 2008 14:51:45.0563 (UTC) FILETIME=[1FF63EB0:01C86A62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:
> 
> What about IRQ masking then ?
> 
> Many CPU pay high cost for cli/sti pair...

Many? In the x86 world only P4. On the other cores cli/sti (and even
pushf ; cli ; popf) is reasonably fast.

> 
> And SLAB/SLUB allocators, even if only used from process context, want
> to disable/re-enable interrupts...
> 
> I understand kmalloc() want generic pools, but dedicated pools could
> avoid this cli/sti

While there are a lot of P4s around they are obsolete by now and I would
advise against major redesigns for tuning obsolete CPUs.

-Andi
