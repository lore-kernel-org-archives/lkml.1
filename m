Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZKWRst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZKWRst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZKWRss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:48:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbZKWRsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:48:47 -0500
Date: Mon, 23 Nov 2009 18:48:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Cc: Mike Galbraith <efault@gmx.de>, Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091123174839.GC6717@elte.hu>
References: <20091121222319.GA3905@swanrl.gmail.com>
 <20091122063926.GA18224@elte.hu>
 <20091122122312.71a343d9@lxorguk.ukuu.org.uk>
 <1258952431.6261.38.camel@marge.simson.net>
 <20091123113110.15063a0a@lxorguk.ukuu.org.uk>
 <20091123114845.GC25575@elte.hu>
 <20091123115949.29bcf89d@lxorguk.ukuu.org.uk>
 <20091123120409.GA32009@elte.hu>
 <20091123133423.64f34c73@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123133423.64f34c73@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > So you'd prefer to detect devices that are byte based or message based 
> > > by what method ?
> > 
> > I'd not delay the worklet by default - i.e. i'd do Mike's patch.
> 
> Certainly stuff like pty should not delay
> > 
> > Havent tested all effects of it though - do you have any estimation 
> > about negative effects from such a change? We do have hard numbers 
> > (latencies in the millisecs range) from the opposite direction and those 
> > numbers arent pretty.
> 
> On a PC I'm not too worried - we might burn a bit more CPU and Arjan
> might even manage to measure it somewhere. There is the theoretical bad
> case where we end up at 100% CPU because the irq, wake, process one char,
> irq wake, process one char sequence fits the CPU so we don't sleep.
> 
> Embedded might be more of a concern, the old behaviour comes from 386/486
> days with low CPU power.
> 
> USB doesn't worry me - USB devices generally have their own buffering
> algorithm and use a timer so that they batch data efficiently into USB
> buffers.
> 
> The drivers/serial layer is often run with low latency set anyway so that
> seems to be ok for the most part.
> 
> Give it a go, send the patch to the maintainer, try it in -next and see
> if anyone screams.

(Doh, i should have Cc:-ed Greg first time around - fixed that.)

	Ingo
