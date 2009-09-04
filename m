Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbZIDFIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbZIDFIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZIDFIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:08:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40639
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300AbZIDFIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:08:54 -0400
Date: Thu, 03 Sep 2009 22:09:06 -0700 (PDT)
Message-Id: <20090903.220906.44384937.davem@davemloft.net>
To: mingo@elte.hu
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com
Subject: Re: [PATCH] basic perf support for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090904050256.GA8382@elte.hu>
References: <20090817064851.GQ12579@kernel.dk>
	<20090903.213702.250776705.davem@davemloft.net>
	<20090904050256.GA8382@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 4 Sep 2009 07:02:56 +0200

> 
> * David Miller <davem@davemloft.net> wrote:
> 
>> Does this build for you without adding an
>> arch/sparc/include/asm/perf_counter.h that looks
>> something like the following?
>> 
>> #ifndef _ASM_SPARC_PERF_COUNTER_H
>> #define _ASM_SPARC_PERF_COUNTER_H
>> 
>> #define PERF_COUNTER_INDEX_OFFSET	0
>> 
>> #endif
>> 
>> Or is this somehow now required in the -tip trees?
> 
> This used to be required but i recently fixed this (and that fix is 
> upstream as well) via:
> 
>   f738eb1: perf_counter: Fix the PARISC build
> 
> there's now a default define of 0 so you dont have to define it and 
> can leave out this chunk.
> 
> ( That index is only interesting if the architecture has a way to 
>   allow unprivileged user-space to access counter registers 
>   directly. In that case the index reflects the offset from the 
>   (constantly changing) dynamix index which we put into the mmap 
>   header. With Sparc not having a hw-PMU implementation this index 
>   is entirely uninteresting at this stage. )

But you still do need at least an empty perf_counter.h file
right?  Jens must have left the file out of his submission
by accident, and that's what I'm trying to get to the bottom
of here :-)

I assume there was a similar change to deal with references to
set_perf_counter_pending() too or is at least a NOP definition
still needed?
