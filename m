Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbXHUHdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbXHUHdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbXHUHdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:33:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:55986 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751082AbXHUHdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:33:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX186XyFGOVw6U1h1VKx100aDOp+ek2UXNhGuRGihKe
	re4mByG7OKGVaV
Subject: Re: CFS review
From: Mike Galbraith <efault@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708191936110.1817@scrub.home>
References: <Pine.LNX.4.64.0708011955430.1817@scrub.home>
	 <20070801190556.GA1199@elte.hu>
	 <Pine.LNX.4.64.0708100037460.1817@scrub.home>
	 <20070810054948.GA5908@elte.hu>
	 <Pine.LNX.4.64.0708101459530.1817@scrub.home>
	 <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com>
	 <Pine.LNX.4.64.0708101919270.1817@scrub.home>
	 <20070810194705.GH6002@1wt.eu>
	 <Pine.LNX.4.64.0708102235320.1817@scrub.home>
	 <20070810213630.GA13910@elte.hu> <20070811003052.GA18812@elte.hu>
	 <Pine.LNX.4.64.0708191936110.1817@scrub.home>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 09:33:03 +0200
Message-Id: <1187681583.6183.25.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 00:19 +0200, Roman Zippel wrote: 
> Hi,
> 
> On Sat, 11 Aug 2007, Ingo Molnar wrote:
> 
> > the only relevant thing that comes to mind at the moment is that last 
> > week Peter noticed a buggy aspect of sleeper bonuses (in that we do not 
> > rate-limit their output, hence we 'waste' them instead of redistributing 
> > them), and i've got the small patch below in my queue to fix that - 
> > could you give it a try?
> 
> It doesn't make much of a difference.

I thought this was history.  With your config, I was finally able to
reproduce the anomaly (only with your proggy though), and Ingo's patch
does indeed fix it here.

Freshly reproduced anomaly and patch verification, running 2.6.23-rc3
with your config, both with and without Ingo's patch reverted:

6561 root      20   0  1696  492  404 S 32.0  0.0   0:30.83 0 lt
6562 root      20   0  1696  336  248 R 32.0  0.0   0:30.79 0 lt
6563 root      20   0  1696  336  248 R 32.0  0.0   0:30.80 0 lt
6564 root      20   0  2888 1236 1028 R  4.6  0.1   0:05.26 0 sh

6507 root      20   0  2888 1236 1028 R 25.8  0.1   0:30.75 0 sh
6504 root      20   0  1696  492  404 R 24.4  0.0   0:29.26 0 lt
6505 root      20   0  1696  336  248 R 24.4  0.0   0:29.26 0 lt
6506 root      20   0  1696  336  248 R 24.4  0.0   0:29.25 0 lt

	-Mike

