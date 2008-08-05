Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYHECFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYHECFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbYHECAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:00:11 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:41037 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569AbYHECAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:00:09 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan <arjan@infradead.org>
Subject: Re: [PATCH] workaround minor lockdep bug triggered by mm_take_all_locks
References: <20080804145318.GA17867@redhat.com>
	<1217861763.3589.13.camel@twins> <20080804162657.GI11476@duo.random>
	<1217867935.3589.35.camel@twins> <20080804172728.GJ11476@duo.random>
	<20080804174659.GK11476@duo.random>
	<20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins>
	<20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins>
	<20080804210954.GC12464@duo.random>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 04 Aug 2008 19:00:03 -0700
In-Reply-To: <20080804210954.GC12464@duo.random> (Andrea Arcangeli's message
	of "Mon, 4 Aug 2008 23:09:54 +0200")
Message-ID: <adar694rzks.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Aug 2008 02:00:03.0632 (UTC) FILETIME=[F9CD8300:01C8F69E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The point is that this is a runtime evaluation of lock orders, if
 > runtime isn't the lucky one that reproduces the deadlock, it'll find
 > nothing at all.

I think the point you miss is that lockdep can report a potential
deadlock, even if the deadlock does not actually occur.  For example
suppose there is an AB-BA deadlock somewhere.  For this to actually
trigger, we have to have one CPU running the AB code path at exactly the
moment another CPU runs the BA code path, with the right timing so one
CPU holds A and tries to grab B while the other CPU already holds B.

With lockdep, we just have to have the AB code path run once at any
point, and then the BA code path run at any later time (even days after
the AB code path has released all the locks).  And then we get a
warning dump that explains the exact potential deadlock.

 - R.
