Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZGMHDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZGMHDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZGMHC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:02:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42623 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbZGMHC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:02:59 -0400
Date: Mon, 13 Jul 2009 09:02:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
Message-ID: <20090713070248.GB28499@elte.hu>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com> <20090711004339.GA6125@nowhere> <d82e647a0907102025s655a82bg11af0eb901349c31@mail.gmail.com> <20090711210902.GB6641@nowhere> <d82e647a0907111929u72ebe4b5t7cf638568e195adc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0907111929u72ebe4b5t7cf638568e195adc@mail.gmail.com>
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


* Ming Lei <tom.leiming@gmail.com> wrote:

> > I don't have a strong opinion on this. I just don't think the 
> > shortest path is the most important if there are many many 
> > paths. Whatever AB-BA is encountered, all of them must be fixed. 
> > What might give a degree of importance for such bad circle is 
> > the window in which it triggers.
> 
> The shortest path is just a characteristic of BFS, and we do not 
> need to pay extra work for it.  So finding the shortest circle 
> have not any bad effect at least.
> 
> IMHO, troubleshooting from the shortest circle is easier than from 
> other circle.

Agreed. Making lockdep reports more readable (i.e. smaller) is a 
very important goal.

Often the longer circles are just a side-effect of the shorter 
circles and fixing the short one will fix the large ones too. So 
printing the smallest is an advantage IMO.

	Ingo
