Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZGPFWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZGPFWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 01:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbZGPFWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 01:22:25 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:58846 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbZGPFWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 01:22:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <d82e647a0907152139x12edd66agde44f155fa60506b@mail.gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1247476574.7529.55.camel@twins>
	 <d82e647a0907152139x12edd66agde44f155fa60506b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 07:22:33 +0200
Message-Id: <1247721753.15471.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 12:39 +0800, Ming Lei wrote:
> 2009/7/13 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Sun, 2009-06-28 at 23:04 +0800, tom.leiming@gmail.com wrote:
> >> Hi,Peter
> >>
> >> Currently lockdep uses recursion DFS(depth-first search) algorithm to
> >> search target in checking lock circle(check_noncircular()),irq-safe
> >> -> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
> >> lock dependency. This patches replace the current DFS with BFS, based on
> >> the following consideration:
> >>
> >>     1,no loss of efficiency, no matter DFS or BFS, the running time
> >>     are O(V+E) (V is vertex count, and E is edge count of one
> >>     graph);
> >
> > I'd still like to get some feedback on the loss of that generation count
> > optimization done by DaveM, I haven't had time to analyze the
> > ramifications of that.
> >
> >
> 
> Hi, Ingo and Peter
> 
> As you said, BFS patch-set is valuable(decrease kernel stack consume
> largely, and report
> the shortest circle).
> 
> It has been pending on lkml silently for several monthes, and I hope
> it may be merged to
> tip-tree or other tree. I don't know what we should and can do to make
> it being accepted by tip-tree.
> Anyway, I'd like to do any fixes for it to be merged.
> 
> Any suggestions, ideas or objections?

I've asked several times to comment on the removal of that generation
count DaveM did. Is that a normal part of DFS, or was that an
optimization on top particular to this problem, can something similar be
done for BFS, etc.

Other than that it does seem to hold up, I've got the patches running on
my laptop. Don't worry they're not getting lost.

