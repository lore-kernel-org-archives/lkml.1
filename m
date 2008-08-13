Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYHMNho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYHMNho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYHMNhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:37:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:49503 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbYHMNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:37:32 -0400
Date: Wed, 13 Aug 2008 06:35:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pardo <pardo@google.com>, akpm@linux-foundation.org, hugh@veritas.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, briangrant@google.com,
       cgd@google.com, mbligh@google.com, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
 64b context switch optimization?
Message-ID: <20080813063533.444c650d@infradead.org>
In-Reply-To: <20080813104445.GA24632@elte.hu>
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com>
	<af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com>
	<20080813104445.GA24632@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 12:44:45 +0200
Ingo Molnar <mingo@elte.hu> wrote:


> There are various other options to solve the (severe!) performance 
> breakdown:
> 
> 1- glibc could start not using MAP_32BIT for 64-bit thread stacks
> (the boxes where context-switching is slow probably do not matter all
> that much anymore - they were very slow at everything 64-bit anyway)
> 
>      Pros: easiest solution.
>      Cons: slows down the affected machines and needs a new glibc.
> 
> 
> i'd go for 1) or 2).

I would go for 1) clearly; it's the cleanest thing going forward for
sure.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
