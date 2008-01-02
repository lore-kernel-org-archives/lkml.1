Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYABLY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYABLY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYABLYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:24:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53572 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbYABLYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:24:18 -0500
Subject: Re: 2.6.24-rc6-mm1
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <200801022212.29303.nickpiggin@yahoo.com.au>
References: <9DtBq-2jD-3@gated-at.bofh.it>
	 <200801022131.15482.nickpiggin@yahoo.com.au>
	 <1199271676.6821.112.camel@twins>
	 <200801022212.29303.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 12:24:07 +0100
Message-Id: <1199273047.6821.119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 22:12 +1100, Nick Piggin wrote:
> On Wednesday 02 January 2008 22:01, Peter Zijlstra wrote:

> > I've seen 1s+ desktop latencies due to PREEMPT_BKL when I was still
> > using reiserfs.
> 
> Fair enough; so the former ifdefery would be preferable for now then.

To be honest, I must mention that the load that did that was a kernel
build -j5 on a dual socket Athlon MP box. With a current kernel and XFS
that load is making the box slow but its still very servicable.

> > Both reiserfs and tty were fighting for the bkl and massive prio
> > inversion ensued. Turning PREEMPT_BKL off made the system usable again.
> 
> Are either of those subsystems actually using the BKL to protect against
> anything else (than themselves)?

I doubt it.

IIRC Alan is working on getting tty BKL free.

>  It would be sweet to have them use
> private mutexes for the job instead (although even then it probably
> wouldn't be a straight conversion)...

I tried a quick conversion of reiser3 at the time, but it really wants a
recursive lock and I couldn't be bothered to fix a 'legacy' filesystem
so I just gave up and converted the filesystem to XFS.

