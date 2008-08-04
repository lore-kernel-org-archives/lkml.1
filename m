Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbYHDV34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbYHDV34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYHDV3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:29:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:37601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbYHDV3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:29:47 -0400
Date: Mon, 4 Aug 2008 14:27:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>,
       Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
 mm_take_all_locks
Message-ID: <20080804142752.23a59073@infradead.org>
In-Reply-To: <20080804210954.GC12464@duo.random>
References: <20080804145318.GA17867@redhat.com>
	<1217861763.3589.13.camel@twins>
	<20080804162657.GI11476@duo.random>
	<1217867935.3589.35.camel@twins>
	<20080804172728.GJ11476@duo.random>
	<20080804174659.GK11476@duo.random>
	<20080804175730.GL11476@duo.random>
	<1217875739.3589.56.camel@twins>
	<20080804201514.GB12464@duo.random>
	<1217882242.3589.90.camel@twins>
	<20080804210954.GC12464@duo.random>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 23:09:54 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> On Mon, Aug 04, 2008 at 10:37:22PM +0200, Peter Zijlstra wrote:
> > You're so wrong it not even funny. It reports about deadlocks before
> > they happen. All it needs is to observe a lock order violation and
> > it
> 
> Now tell me how it helps to report them... It tells me the system has
> crashed and where, 


I think you totally misunderstand things then.

Lockdep will report a problem if it *ever* sees a BA order after it has
seen a BA order. They don't have to happen at the same time. Or even
within hours of eachother.

They MIGHT happen... in a narrow time window, when you have a deadlock.
But lockdep will warn you about the order violation without actually
having to dealock... because the AB is likely to be done already most
of the time when the BA happens.
