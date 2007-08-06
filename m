Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbXHFG54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbXHFG54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXHFG5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:57:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077AbXHFG5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:57:47 -0400
Date: Mon, 6 Aug 2007 08:57:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Claudio Martins <ctpm@ist.utl.pt>,
       Jeff Garzik <jeff@garzik.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070806065712.GA2818@elte.hu>
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu> <200708050051.40758.ctpm@ist.utl.pt> <20070805014926.400d0608@the-village.bc.nu> <20070805072805.GB4414@elte.hu> <20070805134640.2c7d1140@the-village.bc.nu> <20070805125847.GC22060@elte.hu> <20070805132925.GA4089@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805132925.GA4089@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> In your example above, maybe it's the opposite, users know they can 
> keep a file in /tmp one more week by simply cat'ing it.

sure - and i'm not arguing that noatime should the kernel-wide default. 
In every single patch i sent it was a .config option (and a boot option 
_and_ a sysctl option that i think you missed) that a user/distro 
enables or disabled. But i think the /tmp argument is not very strong: 
/tmp is fundamentally volatile, and you can grow dependencies on pretty 
much _any_ aspect of the kernel. So the question isnt "is there impact" 
(there is, at least for noatime), the question is "is it still worth 
doing it".

> Changing the kernel in a non-easily reversible way is not kind to the 
> users.

none of my patches did any of that...

anyway, my latest patch doesnt do noatime, it does the "more intelligent 
relatime" approach.

	Ingo
