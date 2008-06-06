Return-Path: <linux-kernel-owner+w=401wt.eu-S1764572AbYFFHsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764572AbYFFHsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYFFHse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:48:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbYFFHsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:48:33 -0400
Date: Fri, 6 Jun 2008 00:47:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606004743.a78180c3.akpm@linux-foundation.org>
In-Reply-To: <20080606074137.GA28962@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 09:41:37 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > did SLUB change in linux-next? There is no such problem in -tip.
> > > 
> > > i just successfully booted your config on 4 separate 64-bit 
> > > test-systems with latest -tip. (two dual-core boxes, a quad and a 
> > > 16way box) Latest -tip includes sched-next and x86-next as well.
> > 
> > What's the point in testing a radically differenet kernel from the one 
> > which is known to be crashing?
> 
> well, you Cc:-ed me, so i wanted to exclude -tip's 750+ commits in this 
> area (scheduling, 64-bit x86) in the first step.
> 

What's the relationship between -tip and linux-next?

The crash seems to be due to sched_domains startup ordering, at a guess.

My third bisect iteration has hit this:

arch/x86/mm/kmmio.c: In function 'get_kmmio_probe':
arch/x86/mm/kmmio.c:85: error: implicit declaration of function 'list_for_each_entry_rcu'
arch/x86/mm/kmmio.c:85: error: 'list' undeclared (first use in this function)
arch/x86/mm/kmmio.c:85: error: (Each undeclared identifier is reported only once
arch/x86/mm/kmmio.c:85: error: for each function it appears in.)
arch/x86/mm/kmmio.c:85: error: syntax error before '{' token
arch/x86/mm/kmmio.c:88: warning: no return statement in function returning non-void
arch/x86/mm/kmmio.c: In function 'get_kmmio_fault_page':
arch/x86/mm/kmmio.c:100: error: 'list' undeclared (first use in this function)
arch/x86/mm/kmmio.c:100: error: syntax error before '{' token
arch/x86/mm/kmmio.c:103: warning: no return statement in function returning non-void
arch/x86/mm/kmmio.c: In function 'add_kmmio_fault_page':
arch/x86/mm/kmmio.c:328: error: implicit declaration of function 'list_add_rcu'
arch/x86/mm/kmmio.c: In function 'remove_kmmio_fault_pages':
arch/x86/mm/kmmio.c:420: error: implicit declaration of function 'list_del_rcu'

