Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYKQSCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYKQSCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYKQSCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:02:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49639 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752465AbYKQSCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:02:15 -0500
Date: Mon, 17 Nov 2008 18:01:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
Message-ID: <20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
	<20081114190616.30dd273e@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
	<1226696221.7685.8148.camel@twins>
	<Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
	<1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
	<Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
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

> --- so if the driver processes more than 100000 requests between reboots, 
> wait queues actually slow things down.

Versus power consumption and virtualisation considerations. Plus your
numbers are wrong. You seem terribly keen to ignore the fact that the
true cost is a predicted branch and usually a predicted branch of a
cached variable and you'll only touch the wait queue in rare cases.

I'd also note as an aside modern drivers usually run off krefs so
destruction and thus closedown is refcounted and comes off the last kref
destruct.

Alan
