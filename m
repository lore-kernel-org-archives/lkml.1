Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbXCNSQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbXCNSQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXCNSQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:16:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57197 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbXCNSQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:16:01 -0400
Date: Wed, 14 Mar 2007 19:15:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314181508.GB12994@elte.hu>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <1173879210.31159.30.camel@localhost.localdomain> <20070314134112.GB13486@elte.hu> <Pine.LNX.4.64.0703140945530.9690@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703140945530.9690@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > symbolic links perhaps? In that case i'd also introduce a common 
> > naming scheme: x86_early_printk.c - to make sure we know it right 
> > away that those files are bi-arch.
> 
> Hey, I know! This is a radical idea, but what if we put the name at 
> the head of the file, and called it
> 
> 	arch/x86/kernel/early_printk.c
> 
> instead? Then we could teach each of i386 and x86-64 to include it 
> from that area, and we could put other shared files under the same 
> directory hierarchy so that it would be easy to see which ones are 
> shared?

that is nice too, but it has some disadvantages as well in practice. For 
example i often want to see 'everything' that belongs to an arch in just 
one subdirectory. That way one can grep it for example, instead of 
having to grep two separate places. Symlinks would be fine for that, but 
an explicit split not really i think - unless we can get some really 
significant chunk of code into that hierarchy, so that it makes 
functional /sense/ to look at it in isolation.

with the prefix suggestion we can keep these 'shared' files merged in a 
single, main functional tree (x86_64), but still have them marked in the 
VFS as being shared. But ... either way is fine to me - no strong 
feelings, really.

	Ingo
