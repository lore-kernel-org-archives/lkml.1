Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZDVGnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZDVGnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZDVGnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:43:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZDVGnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:43:05 -0400
Date: Wed, 22 Apr 2009 08:42:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Peter Osterlund <petero2@telia.com>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/pktcdvd.h: add mempool.h dependency
Message-ID: <20090422064234.GB23258@elte.hu>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090422062053.GA20960@elte.hu> <20090422063833.GA23258@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422063833.GA23258@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Caused by:
> 
>   1ba0c7d: fs/compat_ioctl: fix build when !BLOCK
> 
> fixed by the patch below. The build error itself triggers with 
> !BLOCK
         [ ... so it is not very significant. ]

> pktcdvd.h relies on mempool_t but does not include mempool.h. This 
> worked until now accidentally: due to other headers including 
> mempool.h in compat_ioctl.c (and all other pktcdvd.h using sites). 
> But once the header file broke this implicit dependency got 
> uncovered and an uncleanliness turned into a build failure.
> 
> Add mempool.h to pktcdvd.h.

I think Sam's new include file self-sufficiency build checker could 
have caught it. (but there's a baseline to fix first: we have dozens 
and dozens of general purpose headers that do not build in a 
standalone .c file)

	Ingo
