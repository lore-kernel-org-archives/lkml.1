Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZKWNce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZKWNce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZKWNcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:32:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58759 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754282AbZKWNcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:32:32 -0500
Date: Mon, 23 Nov 2009 13:34:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091123133423.64f34c73@lxorguk.ukuu.org.uk>
In-Reply-To: <20091123120409.GA32009@elte.hu>
References: <20091121222319.GA3905@swanrl.gmail.com>
	<20091122063926.GA18224@elte.hu>
	<20091122122312.71a343d9@lxorguk.ukuu.org.uk>
	<1258952431.6261.38.camel@marge.simson.net>
	<20091123113110.15063a0a@lxorguk.ukuu.org.uk>
	<20091123114845.GC25575@elte.hu>
	<20091123115949.29bcf89d@lxorguk.ukuu.org.uk>
	<20091123120409.GA32009@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So you'd prefer to detect devices that are byte based or message based 
> > by what method ?
> 
> I'd not delay the worklet by default - i.e. i'd do Mike's patch.

Certainly stuff like pty should not delay
> 
> Havent tested all effects of it though - do you have any estimation 
> about negative effects from such a change? We do have hard numbers 
> (latencies in the millisecs range) from the opposite direction and those 
> numbers arent pretty.

On a PC I'm not too worried - we might burn a bit more CPU and Arjan
might even manage to measure it somewhere. There is the theoretical bad
case where we end up at 100% CPU because the irq, wake, process one char,
irq wake, process one char sequence fits the CPU so we don't sleep.

Embedded might be more of a concern, the old behaviour comes from 386/486
days with low CPU power.

USB doesn't worry me - USB devices generally have their own buffering
algorithm and use a timer so that they batch data efficiently into USB
buffers.

The drivers/serial layer is often run with low latency set anyway so that
seems to be ok for the most part.

Give it a go, send the patch to the maintainer, try it in -next and see
if anyone screams.

Alan
