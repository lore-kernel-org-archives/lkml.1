Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZCZWsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZCZWsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbZCZWsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:48:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbZCZWsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:48:31 -0400
Date: Thu, 26 Mar 2009 15:39:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Ingo Molnar <mingo@elte.hu>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
In-Reply-To: <20090326181106.GC17159@duck.suse.cz>
Message-ID: <alpine.LFD.2.00.0903261534490.3032@localhost.localdomain>
References: <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
 <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326181106.GC17159@duck.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Jan Kara wrote:
>
>   Reads are measurably better with the patch - the test with cat you
> describe below took ~0.5s per file without the patch and always less than
> 0.02s with the patch. So it seems to help something.

That would seem to be a _huge_ improvement.

Reads are the biggest issue for starting a new process (eg starting 
firefox while under load), and if cat'ing that small file improved by that 
much, then I bet there's a huge practical implication for a lot of desktop 
uses.

The fundamental fsync() latency problem we sadly can't help much with, the 
way ext3 seems to work. But I do suspect that the whole "don't synchronize 
with the journal for normal write-outs" may end up helping even fsync just 
a bit, if only because I suspect it will improve writeout throughput too 
and thus avoid one particular bottleneck.

			Linus
