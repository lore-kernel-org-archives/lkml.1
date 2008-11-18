Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbYKROoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbYKROoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYKROnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:43:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46219 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751076AbYKROnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:43:50 -0500
Date: Tue, 18 Nov 2008 14:40:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
Message-ID: <20081118144053.0072d54c@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
	<20081114190616.30dd273e@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
	<1226696221.7685.8148.camel@twins>
	<Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
	<1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
	<Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
	<20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You will touch the wait queue always when finishing the last pending 
> request --- just to find out that there is no one waiting on it.

Why ? If my fast path for this something like

	if (unlikely(foo->unload_pending) && count == 0)
		wake_up(..)

chances are that I can put unload_pending somewhere in a cache line with
other stuff (certainly for L2) and it will get predicted well.

> And besides cache line, there is coding and testing overhead with wait 
> queues.

If you want correctness you don't want busy waiting with yields - as Ingo
pointed out already thats a bug in itself with hard realtime.

> So what are the reasons why you (and others) are against active waiting? 
> All you are saying is that my reasons are wrong, but you haven't single 
> example when active waiting causes trouble. If there is a workload when 

Untrue - I've given very clear reasons twice, and Ingo has given you
more. If you don't wish to accept the answers that is your problem not
mine, just expect such hacks to get a NAK and not make the kernel.

Alan
--
"I can only provide the information, I can't make you hear it."
		- Shelley Bainter

