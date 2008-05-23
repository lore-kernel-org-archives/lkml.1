Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYEWPHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYEWPHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbYEWPGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:06:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbYEWPGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:06:44 -0400
Date: Fri, 23 May 2008 17:06:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: SMP support
Message-ID: <20080523150622.GA9782@elte.hu>
References: <20080523141759.GA1833@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523141759.GA1833@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> This works on real hw, but not on qemu. It seems to get stuck waiting 
> for one of the atomic values to change. Don't know why yet, it might 
> just be yet another bug in qemu... (we've hit at least two of them so 
> far. And they were real bugs too.)
> 
> But do you think this approach is feasible? It will kill 
> interactivity, that's for sure, though only when kmemcheck is run-time 
> enabled and number of CPUs > 1 (the more the worse).

i think we definitely want it - if for no other purpose but for people 
to become disgusted at the overhead and fixing it ;-)

Vegard, wanna have a look at introducing per CPU kernel pagetables? I 
tried that once in the past and it wasnt too horrible. (the patches are 
gone though) We could do it before bringing other CPUs online, i.e. much 
of the really yucky boot time pagetable juggling phase would be over 
already. Hm?

	Ingo
