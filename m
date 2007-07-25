Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbXGYLuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbXGYLuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXGYLub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:50:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49299 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbXGYLua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:50:30 -0400
Date: Wed, 25 Jul 2007 13:50:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, david@lang.hm,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070725115012.GB27498@elte.hu>
References: <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com> <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com> <20070725113401.GA23341@elte.hu> <46A736C9.4090701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A736C9.4090701@gmail.com>
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

> > and the fact is: updatedb discards a considerable portion of the 
> > cache completely unnecessarily: on a reasonably complex box no way 
> > do all the inodes and dentries fit into all of RAM, so we just trash 
> > everything.
> 
> Okay, but unless I've now managed to really quite horribly confuse 
> myself, that wouldn't have anything to do with _swap_ prefetch would 
> it?

it's connected: it would remove updatedb from the VM picture altogether. 
(updatedb would just cycle through the files with leaving minimal cache 
disturbance.)

hence swap-prefetch could concentrate on the cases where it makes sense 
to start swap prefetching _without_ destroying other, already cached 
content: such as when a large app exits and frees gobs of memory back 
into the buddy allocator. _That_ would be a definitive "no costs and 
side-effects" point for swap-prefetch to kick in, and it would eliminate 
this pretty artificial (and unnecessary) 'desktop versus server' 
controversy and would turn it into a 'helps everyone' feature.

	Ingo
