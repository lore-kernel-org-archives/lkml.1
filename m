Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYKRV11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYKRV11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYKRV1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:27:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57382 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752656AbYKRV1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:27:18 -0500
Date: Tue, 18 Nov 2008 21:26:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
Message-ID: <20081118212652.46d36da5@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811181157260.13418@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
	<20081114190616.30dd273e@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
	<1226696221.7685.8148.camel@twins>
	<Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
	<1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
	<Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
	<20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
	<20081118144053.0072d54c@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811181157260.13418@hs20-bc2-1.build.redhat.com>
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

> This makes a code branch that is very rarely tested and a potential bug. 
> Every such rarely executed branch is a danger and even a silly typo in the 
> code can hide there for many years without being noticed.

Learn to use a debugger. You want an unusual timing to occur you
breakpoint the relevant task and suspend it for a bit.

> So, I say msleep(1) instead of yield(). What are the counterarguments to 
> msleep?

msleep isn't particularly a problem. You are giving up the CPU and not
wasting so much power and you won't deadlock in realtime. Assuming you
only expect one or two msleep cycles its fine.

And if you think virtualisation and power management and correctness
(as Ingo noted) are a "bad reason" you need to wake up to the real world.

Alan
