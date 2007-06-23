Return-Path: <linux-kernel-owner+w=401wt.eu-S1761928AbXFWNcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928AbXFWNcZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760885AbXFWN1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:27:40 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:50651 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329AbXFWN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:27:39 -0400
Date: Sat, 23 Jun 2007 15:26:53 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about fair schedulers
Message-ID: <20070623152653.05ebac64@localhost>
In-Reply-To: <200706231001.02497.info@gnebu.es>
References: <200706230007.15622.info@gnebu.es>
 <20070623090655.36d1794c@localhost>
 <200706231001.02497.info@gnebu.es>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 10:01:02 +0200
Alberto Gonzalez <info@gnebu.es> wrote:

> I see. So you mean that in 90% of the cases the mainline scheduler behaves 
> better than fair schedulers, but when its "logic" fails it behaves much worse 
> (the other 10% cases)?

Yes and no... the "logic" is supposed to identify what processes are
somehow interactive and give them more priority / CPU time.

This makes the system behaves better when there are CPU hog processes
(like encoders etc...) because the interactive ones doesn't suffer too
much.

The big problem is that it can identify an almost CPU hog process as
interactive.... and giving him an insane amount of CPU starve the
others.

In my case it was "trancode", and I assure you... it wasn't funny.
Sometimes it happened that running it (at standard nice 0) made
the machine totally unusable!  (something like 30s to switch from X to
a virtual terminal... and I don't tell you how hard was doing login and
killing/renicing it).

So far I've seen these pathological behaviour only with trancode and
wine (only with particular programs I don't remember now).

But the fact is, the "interactivity estimator" is too fragile, and when
it fails it can do much damage.


Fair scheduler instead:
	- are robust
	- provide consistent behaviour
	- provide good interactivity within the bounds of fairness


> In my very simple test scenario the mainline scheduler 
> did behave much better.

Of course... because of the two competing processes the
"interactive" (for you) one needs 60%, that is more than it's 50% fair
share.

The real solution is to use nice levels so the scheduler doesn't have
to guess what process is more important.

And yes, programs/distributions should set good defaults for you... and
if they don't, just complain to them  :)

-- 
	Paolo Ornati
	Linux 2.6.22-rc5-g0864a4e2 on x86_64
