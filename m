Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbXGYLe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbXGYLe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761761AbXGYLeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:34:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763466AbXGYLeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:34:18 -0400
Date: Wed, 25 Jul 2007 13:34:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, david@lang.hm,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070725113401.GA23341@elte.hu>
References: <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com> <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A70D37.3060005@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> On 07/25/2007 10:28 AM, Ingo Molnar wrote:
> 
> >>Regardless, I'll stand by "[by disabling updatedb] the problem will 
> >>for a large part be solved" as I expect approximately 94.372 percent 
> >>of Linux desktop users couldn't care less about locate.
> >
> > i think that approach is illogical: because Linux mis-handled a 
> > mixed workload the answer is to ... remove a portion of that 
> > workload?
> 
> No. It got snipped but I introduced the comment by saying it was a 
> "that's not the point" kind of thing. [...]

ok - with that qualification i understand.

still, especially for someone like me who frequently deals with source 
code, 'locate' is indispensible.

and the fact is: updatedb discards a considerable portion of the cache 
completely unnecessarily: on a reasonably complex box no way do all the 
inodes and dentries fit into all of RAM, so we just trash everything. 
Maybe the kernel could be extended with a method of opening files in a 
'drop from the dcache after use' way. (beagled and backup tools could 
make use of that facility too.) (Or some other sort of 
file-cache-invalidation syscall that already exist, which would _also_ 
result in the immediate zapping of the dentry+inode from the dcache.)

	Ingo
