Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbYARV2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbYARV2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYARV2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:28:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757487AbYARV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:28:31 -0500
Date: Fri, 18 Jan 2008 13:27:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Salikhmetov <salikhmetov@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, peterz@infradead.org,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
In-Reply-To: <4df4ef0c0801181303o6656832g8b63d2a119a86a9c@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0801181325510.2957@woody.linux-foundation.org>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>  <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org>  <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu>  <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org> 
 <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu>  <alpine.LFD.1.00.0801181106340.2957@woody.linux-foundation.org>  <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>  <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>  <4df4ef0c0801181158s3f783beaqead3d7049d4d3fa7@mail.gmail.com>
  <alpine.LFD.1.00.0801181214440.2957@woody.linux-foundation.org> <4df4ef0c0801181303o6656832g8b63d2a119a86a9c@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 19 Jan 2008, Anton Salikhmetov wrote:
> 
> Before using pte_wrprotect() the vma_wrprotect() routine uses the
> pte_offset_map_lock() macro to get the PTE and to acquire the ptl
> spinlock. Why did you say that this code was not SMP-safe? It should
> be atomic, I think.

It's atomic WITH RESPECT TO OTHER PEOPLE WHO GET THE LOCK.

Guess how much another x86 CPU cares when it sets the accessed bit in 
hardware?

> The POSIX standard requires the ctime and mtime stamps to be updated
> not later than at the second call to msync() with the MS_ASYNC flag.

.. and that is no excuse for bad code.

			Linus
