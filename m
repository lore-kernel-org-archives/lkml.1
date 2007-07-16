Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbXGPSNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbXGPSNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXGPSNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:13:44 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2626 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXGPSNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:13:43 -0400
Date: Mon, 16 Jul 2007 20:12:53 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707162000400.1817@scrub.home>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos>
 <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu>
 <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home>
 <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Linus Torvalds wrote:

> How about trying a much less aggressive nice-level (and preferably linear, 
> not exponential)?

I think the exponential increase isn't the problem. The old code did 
approximate something like this rather crudely with the result that there 
was a big gap between level 0 and -1.

Something like this:

echo 'for (i=-20;i<=20;i++) print i, " : ", 1024*e(l(2)*(-i/20*3)), "\n";' | bc -l

would produce a range similiar to the old code. Replacing the factor 3 
with 4 would be IMO a more reasonable increase and had the advantage for 
the user that it's easier to understand that every 5 levels the time a 
process gets is doubled.

bye, Roman
