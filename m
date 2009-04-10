Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbZDJTbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbZDJTbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761309AbZDJTax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:30:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761254AbZDJTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:30:52 -0400
Date: Fri, 10 Apr 2009 12:22:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ying Han <yinghan@google.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2] Move FAULT_FLAG_xyz into handle_mm_fault() callers
In-Reply-To: <604427e00904101215j50288988mf694cfe70aa24e13@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904101218330.4583@localhost.localdomain>
References: <604427e00904081302m7b29c538u7781cd8f4dd576f2@mail.gmail.com>  <20090409230205.310c68a7.akpm@linux-foundation.org>  <20090410073042.GB21149@localhost>  <alpine.LFD.2.00.0904100835150.4583@localhost.localdomain>  <alpine.LFD.2.00.0904100904250.4583@localhost.localdomain>
 <604427e00904101215j50288988mf694cfe70aa24e13@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, Ying Han wrote:
> 
> How about something like this for x86? If it looks sane, i will apply
> to other arches.

Eventually yes, but only _after_ doing the "mindless patch".

I really want the patches that change calling conventions to "obviously" 
do nothing else (sure, they can still have bugs, but it minimizes the 
risk). Then, _after_ the calling convention has changed, you can do a 
separate "clean up" patch.

> +	unsigned int fault_flags |= FAULT_FLAG_RETRY;

I assume you meant "fault_flags = FAULT_FLAG_RETRY;", ie without the "|=".

But yes, other than that, this is the kind of patch that makes sense - 
having the callers eventually be converted to not use that "write" kind of 
boolean, but use the FAULT_FLAG_WRITE flags themselves directly, and then 
eventually have no "conversion" between the boolean and the fault_flag 
models at all.

			Linus
