Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZIDFDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZIDFDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZIDFDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:03:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbZIDFDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:03:07 -0400
Date: Fri, 4 Sep 2009 07:02:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090904050256.GA8382@elte.hu>
References: <20090806070242.GF12579@kernel.dk> <20090816.183134.90977928.davem@davemloft.net> <20090817064851.GQ12579@kernel.dk> <20090903.213702.250776705.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903.213702.250776705.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Mon, 17 Aug 2009 08:48:51 +0200
> 
> >     sparc: add basic support for 'perf'
> >     
> >     This wires up the perf_counter_open() syscall so that basic
> >     software support for perf is working.
> >     
> >     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Does this build for you without adding an
> arch/sparc/include/asm/perf_counter.h that looks
> something like the following?
> 
> #ifndef _ASM_SPARC_PERF_COUNTER_H
> #define _ASM_SPARC_PERF_COUNTER_H
> 
> #define PERF_COUNTER_INDEX_OFFSET	0
> 
> #endif
> 
> Or is this somehow now required in the -tip trees?

This used to be required but i recently fixed this (and that fix is 
upstream as well) via:

  f738eb1: perf_counter: Fix the PARISC build

there's now a default define of 0 so you dont have to define it and 
can leave out this chunk.

( That index is only interesting if the architecture has a way to 
  allow unprivileged user-space to access counter registers 
  directly. In that case the index reflects the offset from the 
  (constantly changing) dynamix index which we put into the mmap 
  header. With Sparc not having a hw-PMU implementation this index 
  is entirely uninteresting at this stage. )

	Ingo
