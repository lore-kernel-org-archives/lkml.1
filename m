Return-Path: <linux-kernel-owner+w=401wt.eu-S965962AbXDGWQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965962AbXDGWQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 18:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965975AbXDGWQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 18:16:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34961 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965962AbXDGWQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 18:16:50 -0400
Date: Sat, 7 Apr 2007 15:15:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Dave Jones <davej@redhat.com>, "Ulrich Drepper" <drepper@gmail.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       "pravin b shelar" <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
Message-Id: <20070407151556.4f58cb94.akpm@linux-foundation.org>
In-Reply-To: <20070407104339.6674336b.dada1@cosmosbay.com>
References: <20060808070708.GA3931@localhost.localdomain>
	<200608090826.28249.dada1@cosmosbay.com>
	<200608090843.52893.dada1@cosmosbay.com>
	<200703152010.35614.dada1@cosmosbay.com>
	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	<20070405194942.1414c030.dada1@cosmosbay.com>
	<20070407104339.6674336b.dada1@cosmosbay.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 10:43:39 +0200 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Hi all
> 
> Updates on this take4 :
> 
> - All remarks from Nick were addressed I hope
> 
> - Current mm code have a problem with 64bit futexes, as spoted by Nick :
> 
> get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
> So it is possible a 64bit futex spans two pages of memory...
> I had to change get_futex_key() prototype to be able to do a correct test.
> 

Cold we please have that in a separate patch?  It's logically a part of the
64-bit-futex work, is it not?

> +
> +/**
> + * get_futex_key - Get parameters which are the keys for a futex.
> + * @uaddr: virtual address of the futex
> + * @size: size of futex (4 or 8)
> + * @shared: NULL for a PROCESS_PRIVATE futex,
> + *	&current->mm->mmap_sem for a PROCESS_SHARED futex
> + * @key: address where result is stored.
> + *
> + * Returns an error code or 0
> + */
> +int get_futex_key(void __user *uaddr, int size, struct rw_semaphore *shared,
> +		  union futex_key *key);

Thanks for documenting the interface, but please do it in the .c file at
the function's definition site.

